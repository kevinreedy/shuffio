class Division < ApplicationRecord
  belongs_to :season
  has_and_belongs_to_many :teams
  has_many :matches

  def match_time_for_week(week)
    day = season.start_date
    if day_of_week
      days_diff = day_of_week - 1
      day += days_diff.days
    end

    (week - 1).times do
      day += 1.week
    end

    Time.find_zone('America/Chicago').parse("#{day} #{time}")
  end

  def matches_for_week(week)
    matches.where(time: match_time_for_week(week)).order(:court_id)
  end

  def report_for_week(week)
    output = "\e[36mResults (winner underlined):\e[0m\n"
    output += "#{season.name} - #{name} Division\n"
    output += match_time_for_week(week).in_time_zone('America/Chicago').to_s + "\n\n"

    matches_for_week(week).each do |m|
      output += "#{m.id}\t"
      output += "#{m.location}\t"
      output += "\e[4m" if m.away_score > m.home_score
      output += m.away_team.name + ' (A)'
      output += "\e[24m" if m.away_score > m.home_score
      output += ' vs. '
      output += "\e[4m" if m.home_score > m.away_score
      output += m.home_team.name + ' (H)'
      output += "\e[24m" if m.home_score > m.away_score
      output += "\n"
    end

    output
  end

  def sorted_teams
    return Division.frozen_id_to_team(JSON.parse(final_standings)) if final_standings

    Team.sort_by_rank(teams.map do |t|
                        {
                          team: t,
                          wins: t.league_record(self)[:wins],
                          losses: t.league_record(self)[:losses]
                        }
                      end)
  end

  def freeze!
    self.final_standings = nil
    save
    self.final_standings = JSON.pretty_generate(Division.frozen_team_to_id(sorted_teams))
    save
  end

  def la_name
    output = season.name
    output += ' ' + (day_of_week == 1 ? 'Monday' : 'Tuesday')
    output += ' (' + Time.parse(time).strftime('%-l:%M%P') + ')'
    output += ' ' + name.split.last + ' Division'
    output
  end

  def la_csv
    require 'csv'

    attributes = %w[
      SUB_PROGRAM
      HOME_TEAM
      AWAY_TEAM
      DATE
      START_TIME
      END_TIME
      LOCATION
      SUB_LOCATION
      TYPE
      NOTES
    ]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      matches.order(:time, :location).each do |m|
        row = []
        row << nil
        row << m.home_team.name
        row << m.away_team.name
        row << m.time.in_time_zone('America/Chicago').strftime('%-m/%-d/%Y')
        row << m.time.in_time_zone('America/Chicago').strftime('%H:%M')
        row << (m.time + 1.hour).in_time_zone('America/Chicago').strftime('%H:%M')
        row << 'the royal palms shuffleboard club'
        row << m.court.name
        row << 'REGULAR_SEASON'
        row << nil
        csv << row
      end
    end
  end

  def self.frozen_id_to_team(input)
    output = []

    input.each do |t|
      output.push(
        team: Team.find(t['team_id']),
        wins: t['wins'],
        losses: t['losses']
      )
    end

    output
  end

  def self.frozen_team_to_id(input)
    output = []

    input.each do |t|
      output.push(
        team_id: t[:team].id,
        wins: t[:wins],
        losses: t[:losses]
      )
    end

    output
  end

  def next_division
    d = Division.find_by(id: id + 1)
    return d if d && season_id == d.season_id

    nil
  end

  def playoff_prediction
    output = []

    teams.each do |t|
      record = t.league_record(self)

      matches = t.matches.where(division: self, away_score: 0, home_score: 0)

      matches.each do |m|
        estimate = if m.home_team_id == t.id
                     ::Elo::Rating.new(old_rating: m.home_team.elo_cache, other_rating: m.away_team.elo_cache).send(:expected)
                   else
                     ::Elo::Rating.new(old_rating: m.away_team.elo_cache, other_rating: m.home_team.elo_cache).send(:expected)
                   end

        record[:wins] += estimate
        record[:losses] += (1 - estimate)
      end
      output.push(
        team: t,
        wins: record[:wins],
        losses: record[:losses]
      )
    end

    Team.sort_by_rank(output).map do |t|
      {
        team: t[:team],
        wins: t[:wins].round,
        losses: t[:losses].round
      }
    end
  end

  # Returns array of Matches, but doesn't save them
  def setup_matches(location = Location.find_by(name: 'Royal Palms Chicago'))
    output_matches = []

    # Sort teams into away and home via snake order
    s_teams = teams.order(:elo_cache)

    raise 'Automatic schedule requires 12 teams' unless teams.count == 12

    away_teams = [
      s_teams[0],
      s_teams[3],
      s_teams[4],
      s_teams[7],
      s_teams[8],
      s_teams[11]
    ]
    home_teams = [
      s_teams[1],
      s_teams[2],
      s_teams[5],
      s_teams[6],
      s_teams[9],
      s_teams[10]
    ]

    courts = [
      Court.find_by(location: location, name: 'Court 01'),
      Court.find_by(location: location, name: 'Court 03'),
      Court.find_by(location: location, name: 'Court 05'),
      Court.find_by(location: location, name: 'Court 06'),
      Court.find_by(location: location, name: 'Court 08'),
      Court.find_by(location: location, name: 'Court 10')
    ]

    # Randomize teams
    away_teams.shuffle!
    home_teams.shuffle!

    # Set up 4 weeks
    4.times do |w|
      # Set up week 1
      courts.count.times do |i|
        output_matches.push(Match.new(
                              time: match_time_for_week(w + 1),
                              division: self,
                              court: courts[i],
                              away_team: away_teams[i],
                              home_team: home_teams[i],
                              away_score: 0,
                              home_score: 0
                            ))
      end

      # Away teams increase court # (1,2,3,4,etc)
      away_teams.rotate!(-1)
      # Home teams decreate court # (2,1,10,9,etc)
      home_teams.rotate!(1)
      # In week 4, home moves twice
      home_teams.rotate!(1) if w == 2
    end

    output_matches
  end

  # CSV of the weeks matchups
  def matchup_csv(week)
    require 'csv'

    CSV.generate(headers: true) do |csv|
      csv << ["#{season.name} - #{name}"]
      csv << ["Week #{week}"]

      # Leave space at top
      4.times { csv << [] }

      matches_for_week(week).each do |m|
        m.matchup_summary.each { |r| csv << r }

        # Leave room for manual info
        3.times { csv << [] }
      end
    end
  end
end
