# frozen_string_literal: true

require_relative '../models/player'
class Dealer < User
  attr_accessor :player, :deck

  validate :player, :type, Player

  NAME = 'Dealer'
  MAX_WIN_POINTS = 17

  def initialize(player)
    super(NAME)
    @player = player
    @deck = Deck.new
    @hide = true
  end

  def start_game
    clear_cards
    @player.clear_cards

    2.times { add_card(deal_card) }
    2.times { @player.add_card(deal_card) }
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
    add_card(deal_card) if @points < MAX_WIN_POINTS
  end
end
