class Player < ApplicationRecord
  # Потенциально игрок может выступать за несколько команд.
  # В таком случае аналогичным (как в связи матчей и команд) образом нужно создать промежуточную таблицу
  # для связи одного player ко многим team. Для простоты - опустим это и будем считать, что у нас игрок
  # может играть лишь за одну команду.
  belongs_to :team
  has_many :plays
  has_many :matches, through: :plays

  # возвращает запись участия игрока по конкретному id матча или nil, если игрок там не играл
  def match_play(id)
    @match_play ||= plays.find_by(match_id: id)
  end

  # эти методы можно генерировать динамически - отталкиваясь от некоторого паттерна имени методов проверки в модели Play

  # проверить выполнил ли игрок конкретный показатель по броскам хотя бы 1 раз за предыдущие 5 матчей команды
  # last_plays_count - последние N игр (по-умолчанию, 5)
  # опция rate - для переопределения стандартного значения в play
  def rate_achieved?(last_plays_count = 5, rate: 0.7)
    select_plays(last_plays_count).each {|play| return true if play.rate_achieved?(rate)}
    false
  end

  # проверить выполнил ли игрок конкретный показатель по дистанции хотя бы 1 раз за предыдущие 5 матчей команды
  # last_plays_count - последние N игр (по-умолчанию, 5)
  # опция rate - для переопределения стандартного значения в play
  def distance_achieved?(last_plays_count = 5, distance: 10.0)
    select_plays(last_plays_count).each {|play| return true if play.distance_achieved?(distance)}
    false
  end

  # лучший результат за последние last_plays_count матчей
  def best_rate(last_plays_count = 5)
    select_plays(last_plays_count).map(&:success_pass_rate).max
  end

  # максимальная дистанция за последние last_plays_count матчей
  def max_distance(last_plays_count = 5)
    select_plays(last_plays_count).map(&:distance).max
  end

  private

  def select_plays(last_plays_count)
    plays.sort_by(&:created_at).reverse.first(last_plays_count)
  end
end
