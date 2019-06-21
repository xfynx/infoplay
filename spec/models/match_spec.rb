require 'rails_helper'

RSpec.describe Match, type: :model do
  describe "#create" do
    it "должен выдавать ошибку валидации, если пытаемся сохранить больше или меньше двух команд" do
      (t1, t2, t3) = Team.create!(name: "1"), Team.create!(name: "2"), Team.create!(name: "3")
      expect{Match.create!}.to raise_exception(ActiveRecord::RecordInvalid)
      expect(Match.create!(teams: [t1, t2])).not_to be_nil
      expect{Match.create!(teams: [t1])}.to raise_exception(ActiveRecord::RecordInvalid)
      expect{Match.create!(teams: [t1, t2, t3])}.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end

  it "должен вернуть всех игроков из играющих команд в матче" do
    t1 = Team.create!(name: "1")
    t2 = Team.create!(name: "2")
    p1 = Player.create!(name: "1", team: t1)
    p2 = Player.create!(name: "2", team: t1)
    p3 = Player.create!(name: "3", team: t2)
    Player.create!(name: 4, team: Team.create!(name: "noname"))

    m = Match.create!(teams: [t1, t2])
    expect(m.teams.map(&:players).flatten.map(&:name)).to eq([p1.name, p2.name, p3.name])
  end
end
