namespace :location do
  desc 'Seed location information and update Matches to new schema'
  task seed_and_update: :environment do
    load Rails.root.join('db/seeds/locations.rb')

    chicago = Location.find_by(name: 'Royal Palms Chicago')

    # Update existing matches to use the new models
    Match.all.each do |m|
      next unless m.location

      court = Court.find_by(name: m.location, location: chicago)
      m.update(court: court, location: nil) if court
    end
  end

  desc 'Set original location information for teams'
  task set_team_location: :environment do
    chicago = Location.find_by(name: 'Royal Palms Chicago')
    brooklyn = Location.find_by(name: 'Royal Palms Brooklyn')

    # Find Chicago Seasons
    Season.where('id <= 8').each do |s|
      s.teams.where(location: nil).each do |t|
        t.update(location: chicago)
      end
    end

    Season.find(42).teams.where(location: nil).each do |t|
      t.update(location: chicago)
    end

    Season.find(43).teams.where(location: nil).each do |t|
      t.update(location: chicago)
    end

    # Update the few Brooklyn teams we have
    Season.find(9).teams.where(location: nil).each do |t|
      t.update(location: brooklyn)
    end

    # One Offs
    Team.find_by(name: 'Slippery Millies').update(location: chicago)
    Team.find_by(name: 'Risk It For The Biscuit (summer)').update(location: chicago)

    # Destroy Can-Am Fake Names
    Team.where(id: 386..645).each(&:destroy) if Team.find(386).name == 'Larry Salazar' && Team.find(645).name == 'Frances Morales'
  end

  desc 'Add Locations To Seasons'
  task add_to_seasons: :environment do
    chicago = Location.find_by(name: 'Royal Palms Chicago')
    brooklyn = Location.find_by(name: 'Royal Palms Brooklyn')

    # Find Seasons prior to Brooklyn
    Season.where('id <= 8').each do |s|
      s.update(location: chicago)
    end

    Season.find(42).update(location: chicago)
    Season.find(43).update(location: chicago)

    # Update the one Brooklyn sSason
    Season.find(9).update(location: brooklyn)
  end
end
