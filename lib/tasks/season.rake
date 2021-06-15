namespace :season do
  desc 'Create Fall 2019'
  task create_fall_2019: :environment do
    fall = Season.find_or_create_by(name: 'Fall 2019') do |s|
      s.start_date = '2019-09-09'
      s.playoff_date = '2019-11-10'
      s.banquet_date = '2019-11-11'
    end

    Division.find_or_create_by(name: 'Monday Pilot', season: fall) do |d|
      d.day_of_week = 1
      d.time = '18:30'
    end

    Division.find_or_create_by(name: 'Monday Cherry', season: fall) do |d|
      d.day_of_week = 1
      d.time = '19:30'
    end

    Division.find_or_create_by(name: 'Monday Hammer', season: fall) do |d|
      d.day_of_week = 1
      d.time = '20:30'
    end

    Division.find_or_create_by(name: 'Tuesday Pilot', season: fall) do |d|
      d.day_of_week = 2
      d.time = '18:30'
    end

    Division.find_or_create_by(name: 'Tuesday Cherry', season: fall) do |d|
      d.day_of_week = 2
      d.time = '19:30'
    end

    Division.find_or_create_by(name: 'Tuesday Hammer', season: fall) do |d|
      d.day_of_week = 2
      d.time = '20:30'
    end
  end

  desc 'Set up Schedule for a Season'
  task schedule: :environment do
    ActiveRecord::Base.logger.level = 1
    season = Season.find_by(name: 'Brooklyn Mini-Season #2')

    abort 'Season already has matches scheduled, aborting' if season.matches.any?

    season.divisions.each do |d|
      matches = d.setup_matches

      # TODO: Check for uneven bye automatically and re-schedule

      matches.each(&:save!)
    end
  end

  desc 'Report on uneven bye weeks'
  task bye_report: :environment do
    ActiveRecord::Base.logger.level = 1
    season = Season.find_by(name: 'Fall 2019')

    season.divisions.each do |d|
      away_teams = d.matches_for_week(1).map(&:away_team)
      home_teams = d.matches_for_week(1).map(&:home_team)
      combos = away_teams.map(&:id).product(home_teams.map(&:id))

      # Remove matches that are scheduled
      d.matches.each do |m|
        combos.reject! { |z| z[0] == m.away_team_id && z[1] == m.home_team_id }
      end

      bye_teams = d.teams.map { |t| [t.display_name, 0] }.to_h

      combos.each do |m|
        away_team = Team.find(m[0])
        home_team = Team.find(m[1])

        if away_team.match_count == 8 && home_team.match_count > 8
          bye_teams[home_team.display_name] = bye_teams[home_team.display_name] + 1
        elsif home_team.match_count == 8 && away_team.match_count > 8
          bye_teams[away_team.display_name] = bye_teams[away_team.display_name] + 1
        end
      end

      puts d.name
      bye_teams.reject! { |_t, c| c.zero? }
      bye_teams.each { |t, c| puts "#{c}\t#{t}" }
      puts '-----------------------'
    end
  end

  desc 'Create Brooklyn Leagues and Divisions'
  task create_brooklyn: :environment do
    require 'csv'

    brooklyn = Location.find_by(name: 'Royal Palms Brooklyn')

    # Update existing Brooklyn 2020 Season
    winter = Season.find_by(location: brooklyn, name: 'Brooklyn 2020')
    winter.update(name: 'Winter 2020') if winter

    rows = CSV.read(Rails.root.join('lib/brooklyn_divisions.csv'), headers: true)

    rows.each do |r|
      # Create Season if needed
      season = Season.find_or_create_by(location: brooklyn, name: r['season_name']) do |s|
        s.start_date = r['season_start_date']
      end

      # Create Division
      div = Division.find_or_create_by(season: season, name: r['division_name']) do |d|
        d.day_of_week = r['division_day_of_week'].to_i
        d.time = r['division_time']
        d.league_apps_site_id = r['league_apps_site_id']
        d.league_apps_program_id = r['league_apps_program_id']
      end

      # Import Matches
      div.import_league_apps_matches
    end
  end
end
