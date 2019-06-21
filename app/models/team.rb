class Team < ApplicationRecord
  has_many :players
  has_and_belongs_to_many :matches

  # выбрать Top-5 игроков по конкретному показателю в конкретной команде и по всем командам в целом

  # топ-N игроков по дистанции в команде
  def top_players_by_distance(count=5)
    self.class.top_players(count, :max_distance, players)
  end

  # топ-N игроков по дистанции в команде
  def top_players_by_best_rate(count=5)
    self.class.top_players(count, :best_rate, players)
  end

  # аналогичные методы выборки топ-N по показателю, но по всем командам
  class << self
    # если допустить, что у нас не может быть игроков без команды,
    # выборка топ-N игроков по всем командам может переехать в модель Player,
    # и тогда по каждым игрокам каждой команды не будет производиться отдельный запрос на plays

    def top_players_by_distance(count=5)
      top_players(count, :max_distance, Team.all.map(&:players).flatten)
    end

    def top_players_by_best_rate(count=5)
      top_players(count, :best_rate, Team.all.map(&:players).flatten)
    end

    # выбрать топ-N игроков по определённой характеристике
    # count - количество N
    # method - метрика из Player, конкретно сейчас - Player#max_distance и Player#best_rate
    # players_list - список игроков, на котором делаем выборку. по-умолчанию, берётся список игроков из команды
    def top_players(count, method, players_list)
      # замаппим все результаты в пары "результат, игрок", отсортируем по убыванию, возьмём count игроков из пар
      players_list.map {|p| [p.send(method), p]}.sort.reverse.map(&:last).first(count)
    end
  end
end
