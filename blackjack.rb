# frozen_string_literal: true

require_relative 'game'
require_relative 'terminal_interface'

class Blackjack
  def initialize
    # Создается "независимый" класс игры, который ничего не знает о том, кто/что и как будет им управлять
    game = Game.new(TerminalInterface.ask_user_name) # player и game также лучше спрятать внутрь Game

    # Класс интерфейса получает класс игры и теперь управляет ей:
    # 1) Получая состояние/статус игры (вывод информации)
    # 2) Возможные варианты действий - меню (ввод информации)
    int = TerminalInterface.new(game)
    int.start_game
  end
end

Blackjack.new
