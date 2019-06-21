# README
Команды, игроки, матчи, и всё такое.

## Как развернуть 
```
git clone git@github.com:xfynx/infoplay.git
cd infoplay
bundle
rake db:create db:migrate db:seed
```

## Прогоняем тесты
```
rspec
```

## Примеры использования

После прогона seed-данных, в БД будет некоторый набор данных, с которым можно поэкспериментировать. Например:

```
# Получить все имена игроков из первого матча
Match.first.players.map(&:name) # => ["Крадущийся тигр", "Затаившийся дракон", "Толян", "Аркадий Петрович"] 

# играющие команды первого матча
Match.first.teams.map(&:name) # => ["хищники", "травоядные"] 

# количество матчей, в котором играл первый игрок
Player.first.matches.count # => 3 
# и последний
Player.last.matches.count # => 1

# Успехи третьего игрока - количество бросков, количество успешных бросков, дистанция, дата матча
Player.find(3).plays.map{|play| {total_pass: play.total_pass, success_pass: play.success_pass, distance: play.distance, match_date: play.match.created_at}} # => [{:total_pass=>5, :success_pass=>3, :distance=>7.0, :match_date=>Fri, 21 Jun 2019 20:30:11 UTC +00:00}, {:total_pass=>3, :success_pass=>0, :distance=>1.0, :match_date=>Fri, 21 Jun 2019 20:30:11 UTC +00:00}]
```

Посмотреть успехи какого-то конкретного игрока в матче:
```
m = Match.first
player = m.players.first
player.match_play(m.id) # =>  #<Play id: 1, player_id: 1, match_id: 1, distance: 14.0, total_pass: 17, success_pass: 4, created_at: "2019-06-21 21:27:27", updated_at: "2019-06-21 21:27:27">
# достиг ли игрок процента попаданий 70+?
player.match_play(m.id).rate_achieved? # => false
# или 20+?
player.match_play(m.id).rate_achieved?(0.2) # => true
# а побегал как?
player.match_play(m.id).distance_achieved? # => true 
player.match_play(m.id).distance_achieved?(20.1) # => false 
```

Топ-N игроков по команде:
```
Team.first.top_players_by_distance.map(&:name) # => ["Затаившийся дракон", "Крадущийся тигр"] 
Team.first.top_players_by_best_rate.map(&:name) # => ["Затаившийся дракон", "Крадущийся тигр"]
```

Топ-N игроков по всем командам:
```
Team.top_players_by_best_rate(3).map(&:name) # => ["Затаившийся дракон", "Аркадий Петрович", "Крадущийся тигр"]
Team.top_players_by_distance(4).map(&:name) # => ["Затаившийся дракон", "Крадущийся тигр", "Аркадий Петрович", "Фрилансер"]
```