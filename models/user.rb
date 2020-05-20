require_relative '../modules/validation'

class User
  include Validation

  attr_accessor :name, :bank, :cards, :points

  validate :name, :presence

  def initialize(name)
    @name = name
    @bank = 100
    @cards = []
    @points = 0
  end

  def add_card(card)
    @cards << card
    calculate_points(card)
  end

  # Сумма считается так: от 2 до 10 - по номиналу карты, все «картинки» - по 10,
  # туз - 1 или 11, в зависимости от того, какое значение будет ближе к 21 и что не ведет к проигрышу (сумме более 21).

  private

  def calculate_points(card)
    value, _ = card
    @points += value.to_i if value.to_i.between?(1,11)
    @points += 10 if value.to_i.zero? && Deck.not_ace?(card)
    @points += 1 if value.to_i.zero? && Deck.ace?(card) && 21-@points > 11
    @points += 11 if value.to_i.zero? && Deck.ace?(card) && 21-@points <= 11
  end

  def to_s
    "My name is #{@name} and I had #{@bank}$ and #{@cards} and points: #{@points}"
  end

end
