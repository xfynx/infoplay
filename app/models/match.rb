class Match < ApplicationRecord
  has_many :plays
  has_many :players, through: :plays
  has_and_belongs_to_many :teams

  # Можно сделать валидацию через conditional index в БД, но это менее удобно, поскольку:
  # 1. более явная валидация в моделях, наверное, всё-таки правильней
  # 2. может добавиться другая модель, использующая эту же таблицу, например, для другого типа игры со своими особенностями,
  # и тогда мы не сможем добавить большее число команд для игр, где такое доступно.
  validates :teams, length: {maximum: 2, minimum: 2}
end
