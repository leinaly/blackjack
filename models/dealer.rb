require_relative '../models/player'
class Dealer < User
  attr_accessor :player, :deck

  validate :player, :type, Player

  NAME = "Dealer"

  def initialize(player)
    super(NAME)
    @player = player
    @deck = Deck.new
    @hide = true
  end

  def start_game
    2.times{self.add_card(self.deal_card)}
    2.times{@player.add_card(self.deal_card)}
  end

  def deal_card
    @deck.deal_card
  end

  def open_cards
    @hide = false
  end

  def play
    add_card(deal_card) if @points < 17
  end

  def to_s
    #need to hide cards at the end
    super
  end
end
