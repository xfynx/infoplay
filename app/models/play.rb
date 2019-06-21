class Play < ApplicationRecord
  belongs_to :player
  belongs_to :match

  validates_numericality_of :success_pass, greater_than_or_equal_to: 0
  validates_numericality_of :total_pass, greater_than_or_equal_to: 0
  validates_numericality_of :distance, greater_than_or_equal_to: 0

  # показатель успешности передач
  def success_pass_rate
    # в идеале тут ещё нужно проверять, что success_pass и total_pass не изменился. но пока не суть важно
    @success_pass_rate ||= total_pass > 0 ? (success_pass.to_f / total_pass) : 0
  end

  # сделал ли определённый процент успешных передач. по-умолчанию, от 70% включительно
  def rate_achieved?(pass_rate=0.7)
    success_pass_rate >= pass_rate
  end

  # пробежал ли определённую дистанцию, по-умолчанию, от 10 (километров, например) включительно
  def distance_achieved?(distance=10)
    self.distance >= distance
  end
end
