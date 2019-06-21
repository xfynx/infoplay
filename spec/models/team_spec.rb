require 'rails_helper'

RSpec.describe Team, type: :model do
  before do
    t1 = Team.create(name: '1')
    t2 = Team.create(name: '2')
    m = Match.create!(teams: [t1, t2])

    p = Player.create!(name: 'first', team: t1)
    Play.create!(player: p, match: m, total_pass: 10, success_pass: 8, distance: 6)
    p = Player.create!(name: 'second', team: t1)
    Play.create!(player: p, match: m, total_pass: 10, success_pass: 9, distance: 5)
    p = Player.create!(name: 'third', team: t1)
    Play.create!(player: p, match: m, total_pass: 10, success_pass: 10, distance: 10)

    p = Player.create!(name: 'first_team2', team: t2)
    Play.create!(player: p, match: m, total_pass: 10, success_pass: 4, distance: 11)
    p = Player.create!(name: 'second_team2', team: t2)
    Play.create!(player: p, match: m, total_pass: 10, success_pass: 5, distance: 10)
  end

  context "лучшие игроки в команде" do
    it { expect(Team.first.top_players_by_best_rate.map(&:name)).to eq(['third', 'second', 'first']) }
    it { expect(Team.first.top_players_by_best_rate(2).map(&:name)).to eq(['third', 'second']) }
    it { expect(Team.first.top_players_by_distance.map(&:name)).to eq(['third', 'first', 'second']) }
    it { expect(Team.first.top_players_by_distance(2).map(&:name)).to eq(['third', 'first']) }
  end
  context "лучшие игроки по всем командам" do
    it { expect(Team.top_players_by_best_rate.map(&:name)).to eq(["third", "second", "first", "second_team2", "first_team2"]) }
    it { expect(Team.top_players_by_best_rate(2).map(&:name)).to eq(['third', 'second']) }
    it { expect(Team.top_players_by_distance.map(&:name)).to eq(["first_team2", "second_team2", "third", "first", "second"]) }
    it { expect(Team.top_players_by_distance(2).map(&:name)).to eq(["first_team2", "second_team2"]) }
  end
end
