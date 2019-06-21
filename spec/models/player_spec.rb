require 'rails_helper'

RSpec.describe Player, type: :model do
  it "должен вернуть все матчи, в которых участвовал игрок" do
    t1 = Team.create!(name: "1")
    t2 = Team.create!(name: "2")
    p = Player.create!(team: t1, name: "1")
    # по заданию не требуется делать методов для удобного сохранения, только методы чтения,
    # поэтому для простоты забиваем выступления игрока через явное определение по командам, как здесь или в seeds.rb
    Match.create!(teams: [t1, t2], players: [t1.players + t2.players].flatten)
    Match.create!(teams: [t1, t2], players: [t1.players + t2.players].flatten)
    Match.create!(teams: [t1, t2], players: [t1.players + t2.players].flatten)
    expect(p.matches.count).to eq(3)
  end

  describe "#match_play" do
    before do
      t1 = Team.create!(name: "1")
      t2 = Team.create!(name: "2")
      t3 = Team.create!(name: "3")
      Player.create!(team: t1, name: "1")
      Player.create!(team: t3, name: "3")
      Match.create!(teams: [t1, t2], players: [t1.players + t2.players].flatten)
      Match.create!(teams: [t2, t3], players: [t2.players + t3.players].flatten)
    end
    let(:match1) { Team.find_by(name: "1").matches.first }
    let(:match2) { Team.find_by(name: "3").matches.first }

    it "должен возвращать запись участия игрока в матче по id матча" do
      # для простоты сверимся, что запись найдена и указывает на самого игрока
      expect(Player.first.match_play(match1.id).player).to eq(Player.first)
      expect(Player.last.match_play(match2.id).player).to eq(Player.last)
    end
    it "должен вернуть nil, если игрок не участвовал в этом матче" do
      expect(Player.last.match_play(match1.id)).to be_nil
      expect(Player.first.match_play(match2.id)).to be_nil
    end
  end

  context "проверка достижения целей" do
    before do
      t1 = Team.create!(name: "1")
      t2 = Team.create!(name: "2")
      t3 = Team.create!(name: "3")
      p = Player.create!(team: t2, name: "2")
      Match.create!(teams: [t1, t2], players: [t1.players + t2.players].flatten)
      Match.create!(teams: [t2, t3], players: [t2.players + t3.players].flatten)
      p.plays[0].update_attributes(distance: 11, total_pass: 15, success_pass: 5)
      p.plays[1].update_attributes(distance: 9, total_pass: 15, success_pass: 10)
    end
    let(:player) { Player.find_by(name: "2") }

    describe "#rate_achieved?" do
      it { expect(player.rate_achieved?).to be_falsey }
      it { expect(player.rate_achieved?(0)).to be_falsey }
      it { expect(player.rate_achieved?(5, rate: 0.9)).to be_falsey }
      it { expect(player.rate_achieved?(5, rate: 0.6)).to be_truthy }
    end

    describe "#distance_achieved?" do
      it { expect(player.distance_achieved?).to be_truthy }
      it { expect(player.distance_achieved?(0)).to be_falsey }
      it { expect(player.distance_achieved?(5, distance: 12)).to be_falsey }
      it { expect(player.distance_achieved?(5, distance: 2)).to be_truthy }
    end

    it { expect(player.best_rate).to eq(10.0/15) }
    it { expect(player.best_rate(1)).to eq(10.0/15) }
    it { expect(player.max_distance).to eq(11.0) }
    it { expect(player.max_distance(1)).to eq(9.0) }
  end
end
