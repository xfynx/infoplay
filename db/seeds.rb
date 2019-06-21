team1 = Team.create!(name: "хищники")
team2 = Team.create!(name: "травоядные")
team3 = Team.create!(name: "Независимый фрилансер")

p1 = Player.create!(name: "Крадущийся тигр", team: team1)
p2 = Player.create!(name: "Затаившийся дракон", team: team1)
p3 = Player.create!(name: "Толян", team: team2)
p4 = Player.create!(name: "Аркадий Петрович", team: team2)
p5 = Player.create!(name: "Фрилансер", team: team3)

team1.update_attribute(:players, [p1, p2])
team2.update_attribute(:players, [p3, p4])

match1 = Match.create!(teams: [team1, team2], players: [team1.players + team2.players].flatten)
match2 = Match.create!(teams: [team1, team3], players: [team1.players + team3.players].flatten)
match3 = Match.create!(teams: [team1, team2], players: [team1.players + team2.players].flatten)

[match1, match2, match3].map(&:plays).flatten.each do |play|
  total_pass = rand(20)
  play.update_attributes(total_pass: total_pass, success_pass: rand(total_pass), distance: rand(20))
end