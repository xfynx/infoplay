require 'rails_helper'

RSpec.describe Play, type: :model do
  let(:play1) { Play.create(distance: 10.2, success_pass: 0, total_pass: 0) }
  let(:play2) { Play.create(success_pass: 5, total_pass: 7) }

  describe "#success_pass_rate" do
    it { expect(play1.success_pass_rate).to eq(0) }
    it { expect(play2.success_pass_rate).to eq(0.7142857142857143) }
  end

  describe "#rate_achieved?" do
    it { expect(play1.rate_achieved?).to be_falsey }
    it { expect(play2.rate_achieved?).to be_truthy }
    it { expect(play2.rate_achieved?(0.9)).to be_falsey }
  end

  describe "#distance_achieved?" do
    it { expect(play1.distance_achieved?).to be_truthy }
    it { expect(play2.distance_achieved?).to be_falsey }
    it { expect(play1.distance_achieved?(11)).to be_falsey }
  end
end
