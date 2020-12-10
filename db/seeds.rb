puts 'Seeding Music Category and Answers...'
music = Category.create!(name: 'music')
puts 'Created Category "music"'

Answer.create!(category: music, term: 'the beatles', variants: ['the beat alls', 'beatles', 'thebeatles', 'george harrison', 'paul mccartney', 'ringo starr', 'john lennon'])
Answer.create!(category: music, term: 'pink floyd', variants: [])
Answer.create!(category: music, term: 'daft punk', variants: [])
Answer.create!(category: music, term: 'keane', variants: ['whiney english band'])
Answer.create!(category: music, term: 'the lightning seeds', variants: ['whiney english band 2'])
Answer.create!(category: music, term: 'queen', variants: ['freddie mercury'])
Answer.create!(category: music, term: 'electric light orchestra', variants: ['elo'])
Answer.create!(category: music, term: 'black kids', variants: ['the black kids'])
Answer.create!(category: music, term: 'psy', variants: ['gangnam style'])
Answer.create!(category: music, term: 'tame impala', variants: [])
puts 'Created music Answers'


puts 'Seeding Video Game Category and Answers...'
video_games = Category.create!(name: 'video games')
puts 'Created Category "video games"'

Answer.create!(category: video_games, term: 'half life', variants: ['halflife', 'halflife 2', 'half life 2', 'hl', 'hl2'])
Answer.create!(category: video_games, term: 'dwarf fortress', variants: ['dorf fortress', 'dwarffortress', 'df'])
Answer.create!(category: video_games, term: 'spelunky', variants: ['spelunky classic', 'spelunky 1', 'spelunky 2', 'spelunky2', 'spelunky1', 'spelunk'])
Answer.create!(category: video_games, term: 'starcraft', variants: ['sc', 'star craft', 'sc2', 'star craft 2', 'starcraft 2', 'starcraft2', 'warcraft'])
Answer.create!(category: video_games, term: 'portal', variants: ['portal 2', 'portal2'])
Answer.create!(category: video_games, term: 'hotline miami', variants: ['hotline miami 2', 'hotlinemiami', 'hotline miami 2: wrong number'])
Answer.create!(category: video_games, term: 'super smash brothers', variants: ['ssb', 'brawl', 'melee', 'smash', 'super smash bros'])
Answer.create!(category: video_games, term: 'stardew valley', variants: ['stardew'])
Answer.create!(category: video_games, term: 'into the breach', variants: [])
Answer.create!(category: video_games, term: 'league of legends', variants: ['league', 'lol', 'dota 2', 'smite', 'heroes of the storm', 'hots']) # let's be honest they're all just as terrible and awesome as each other and as heroin
puts 'Created video games Answers'
