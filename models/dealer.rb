require_relative '../modules/validation'

class Dealer
  include Validation

  attr_accessor :bank, :name, :player, :cards, :deck, :points

  validate :player, :type, User

  def initialize(player)
    @bank = 100
    @name = "Dealer"
    @player = player
    @deck = Deck.new
    @cards = []
    @points = 0
  end

  def start_game
    2.times{self.add_card(self.deal_card)}
    2.times{@player.add_card(self.deal_card)}
  end

  def deal_card
    @deck.deal_card
  end

  def add_card(card)
    @cards << card
    calculate_points(card)
  end

  private

  def calculate_points(card)
    value, _ = card
    @points += value.to_i if value.to_i.between?(2,10)
    @points += 10 if value.to_i.zero? && Deck.not_ace?(card)
    @points += 1 if value.to_i.zero? && Deck.ace?(card) && 21-@points > 11
    @points += 11 if value.to_i.zero? && Deck.ace?(card) && 21-@points <= 11
  end

  def to_s
    "My name is #{@name} and I had #{@bank}$ and #{@cards} and points: #{@points}"
  end

end
