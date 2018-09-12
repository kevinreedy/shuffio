# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seasons = {}

seasons[:spring] = Season.create!(
  name: 'Spring 2018',
  start_date: '2018-04-09',
  playoff_date: '2018-06-10',
  banquet_date: '2018-06-11'
)

seasons[:summer] = Season.create!(
  name: 'Summer 2018',
  start_date: '2018-06-25',
  playoff_date: '2018-08-26',
  banquet_date: '2018-08-27'
)

seasons[:fall] = Season.create!(
  name: 'Fall 2018',
  start_date: '2018-09-10',
  playoff_date: '2018-11-11',
  banquet_date: '2018-11-12'
)

divisions = {}
seasons.each do |k, v|
  divisions[k] = {}

  divisions[k][:mp] = Division.create!(
    name: 'Monday Pilot',
    day_of_week: 1,
    time: '18:30:00',
    season: seasons[k]
  )

  divisions[k][:mc] = Division.create!(
    name: 'Monday Cherry',
    day_of_week: 1,
    time: '19:30:00',
    season: seasons[k]
  )

  divisions[k][:mh] = Division.create!(
    name: 'Monday Hammer',
    day_of_week: 1,
    time: '20:30:00',
    season: seasons[k]
  )

  divisions[k][:tp] = Division.create!(
    name: 'Tuesday Pilot',
    day_of_week: 2,
    time: '18:30:00',
    season: seasons[k]
  )

  divisions[k][:tc] = Division.create!(
    name: 'Tuesday Cherry',
    day_of_week: 2,
    time: '19:30:00',
    season: seasons[k]
  )

  divisions[k][:th] = Division.create!(
    name: 'Tuesday Hammer',
    day_of_week: 2,
    time: '20:30:00',
    season: seasons[k]
  )
end

# Monday Cherry
t = Team.create!(name: '6151 Richmond St', captain: 'Amber Sauer')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Ace Shufflers and Robert', captain: 'Leslie von Husen')
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'American Shuffle', captain: 'Jessica Thelen')
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Biscuit Club', captain: 'Marcus Rodriguez', former_names: 'USA Curling Team')
t.divisions << divisions[:spring][:mp]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Del Boca Vista Condo Association', captain: 'Kevin Lada', former_names: 'Bonavista Condo Association')
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Do The Downes Shuffle', captain: 'Elena Frankel')
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Srinkers with a Biscuit Problem', captain: 'Samantha Bankmann')
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Fancy Pants', captain: 'John Summy')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Golden GILFs', captain: 'Silas Hoxie')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Grand Pappy and the Shifty Shafts Retirement Home', captain: 'Jason Wyeth')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: "Grandma Ain't No Floozy", captain: 'Rob Sikkel')
t.divisions << divisions[:spring][:tp]
t.divisions << divisions[:summer][:tc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: "Nymeria's Favorites", captain: 'Amy McFarlane')
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Risk It For The Biscuit', captain: 'Stefan Levay-Young')
t.divisions << divisions[:summer][:mp]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Shuffle Birds', captain: 'Daniel Collado', former_names: 'The Royal Cluster Pucks')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Shuffleboard Jones', captain: 'Michael Holm', former_names: 'Northside Lee-side Sliders')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Shufflepuff', captain: 'Kali Williams')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'The Cupid Shufflers', captain: 'Adam Schlafhauser', former_names: 'Del Boca Vista All-Stars')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: "We Don't See Why Not", captain: 'Dave Berman')
t.divisions << divisions[:summer][:mp]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'We Thought This Was Quidditch', captain: 'Bonnie, El Capitan')
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: '31crew', captain: 'Michael Malek')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]

t = Team.create!(name: 'Biscuit Buddies', captain: 'Corey Taustein')
t.divisions << divisions[:summer][:mc]

t = Team.create!(name: "Breakin' Biscuits", captain: "Brian O'Connell")
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mp]

t = Team.create!(name: 'Cherry Pies', captain: 'Alissa barks')
t.divisions << divisions[:summer][:mc]

t = Team.create!(name: 'Disky Business', captain: 'Caroline Brown')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]

t = Team.create!(name: 'Gucci Tang, Gucci Tang, Gucci Tang', captain: 'Alisha Phillips')
t.divisions << divisions[:spring][:th]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'Half Acre', captain: 'Gustavo Villatoro')
t.divisions << divisions[:summer][:mc]

t = Team.create!(name: 'Powershuff Girls', captain: 'Alison Suzukamo')
t.divisions << divisions[:summer][:mc]

t = Team.create!(name: 'Shuffleupagus', captain: 'Jeff Seroogy')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:mc]

t = Team.create!(name: 'Hammered Hammers', captain: 'Matt OBrien')
t.divisions << divisions[:spring][:mc]

t = Team.create!(name: 'Big Baller Biscuits', captain: 'Hanna Anderson', former_names: 'Here for the Beer')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:tc]

t = Team.create!(name: 'Nothing but 10s', captain: 'Christine Mcpherson')
t.divisions << divisions[:spring][:mc]

t = Team.create!(name: 'Pun-free Shuffling', captain: 'Jake Miner')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:summer][:tc]
t.divisions << divisions[:fall][:tc]

t = Team.create!(name: 'Seven Dwarves', captain: 'Cooper Annenberg')
t.divisions << divisions[:spring][:mc]

t = Team.create!(name: 'Shuffle Now or Puck Later', captain: 'Ross Modjeska')
t.divisions << divisions[:spring][:mc]

t = Team.create!(name: 'The Hip Replacements', captain: 'Lindsay Saewitz')
t.divisions << divisions[:spring][:mc]

t = Team.create!(name: 'The Homer', captain: 'Matthew Summy')
t.divisions << divisions[:spring][:mc]

t = Team.create!(name: 'The Tangge-Uppes', captain: 'Alyssa Russler')
t.divisions << divisions[:spring][:mc]
t.divisions << divisions[:fall][:mp]


# Monday Hammer
t = Team.create!(name: 'Boca Breeze', captain: 'Ian Firestone', former_names: 'Wu Tang Financial')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Dirty Larz and the Boys', captain: 'Caitlin Kohli')
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Gosh Tang It!', captain: 'Patrick Ragan', former_names: 'Del Boca Breeze')
t.divisions << divisions[:summer][:th]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Mr. Dr. Nut', captain: 'Tim McLoughlin')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mc]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Nothing but Pepp', captain: 'Rob OMahoney')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Off The Rails', captain: 'Laura Keener')
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Quite The Kershuffle', captain: 'Ashley Jacobson')
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Shuff It, Shuff It Real Good!', captain: 'Kevin Reedy')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Shuffalo Gang', captain: 'Melissa Long')
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Shuffle Butter', captain: 'Kelsey Cunniff')
t.divisions << divisions[:spring][:tc]
t.divisions << divisions[:summer][:tc]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Shuffleboard of Directors', captain: 'Kyle Bingham')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Shufflepuffers', captain: 'Brett Brewer')
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Slippery Biscuits', captain: "Ryan O'Maley")
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Straight Outta Shady Pines', captain: 'David Macey', former_names: 'Shady Pines Shufflers')
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Super Board Shuffle', captain: 'Ethan Simonds')
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'The Chicago Butts', captain: 'Craig Sutton', former_names: 'The Risky Biscuits')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'The Hard Sticks', captain: 'Amber Lenstrom')
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Tangy Millies', captain: 'Buddy', former_names: 'Somethin... Also maybe Spring')
t.divisions << divisions[:summer][:mp]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'The Shufflebaes', captain: 'Jennifer Yip')
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Tu-Tang Clan', captain: 'Sophie Milam')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mh]

t = Team.create!(name: 'Bougie Biscuit Boozers', captain: 'Justin Busby')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]

t = Team.create!(name: 'Clawed Monets', captain: 'Kate Calkins')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]

t = Team.create!(name: 'FC Pencils', captain: 'Clayton Pfeiffer')
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:th]

t = Team.create!(name: 'Get Rich or Die Shufflin', captain: 'Derek Falk', former_names: 'Everybody Shufflin')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:th]

t = Team.create!(name: 'Motley Crue Tang Clan', captain: 'Nate ONeil')
t.divisions << divisions[:summer][:mh]

t = Team.create!(name: 'New Tang Clan', captain: 'Chris Allen')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]

t = Team.create!(name: 'Big Disc Energy', captain: 'Alex Howard', former_names: 'Nice Disc, How I Pucked Your Mother')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:th]

t = Team.create!(name: 'Shuffin Tops', captain: 'Sara Geoghegan')
t.divisions << divisions[:summer][:mh]

t = Team.create!(name: 'Stranger Tangs', captain: 'Ryan Beattie')
t.divisions << divisions[:summer][:mh]

t = Team.create!(name: 'Tangy Biscuits', captain: 'Kathleen OConnor')
t.divisions << divisions[:summer][:mh]
t.divisions << divisions[:fall][:mc]

t = Team.create!(name: 'We thought this was curling', captain: 'Kylie Martineau')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mh]

t = Team.create!(name: 'A and N Mortgage Shuffle', captain: 'Louann Luck')
t.divisions << divisions[:spring][:mh]

t = Team.create!(name: 'Concrete Curlers', captain: 'Ryan Pasiewicz')
t.divisions << divisions[:spring][:mh]

t = Team.create!(name: 'Shuff Riders', captain: 'Daniel Floberg')
t.divisions << divisions[:spring][:mh]

t = Team.create!(name: 'Survey Says', captain: 'Kevin Loftus')
t.divisions << divisions[:spring][:mh]

t = Team.create!(name: 'Tang It!', captain: 'Tom Theiss')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mp]
t.divisions << divisions[:fall][:mp]

t = Team.create!(name: 'VSOP', captain: 'Simon Le Conservateur Kristak')
t.divisions << divisions[:spring][:mh]
t.divisions << divisions[:summer][:mc]
