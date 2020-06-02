# frozen_string_literal: true

class Dealer < User
  attr_accessor :deck

  NAME = 'Dealer'
  MAX_WIN_POINTS = 17

  def initialize
    super(NAME)
    @deck = Deck.new
    @hide = true
  end

  def deal_card
    @deck.deal_card
  end

  def open_cards
    @hide = false
  end

  def clear_cards
    super
    @hide = true
  end

  def play
    add_card(deal_card) if @points < MAX_WIN_POINTS && @cards.count != 3
  end
end
