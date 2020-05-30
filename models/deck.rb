# frozen_string_literal: true

require_relative '../models/card'

class Deck
  attr_accessor :cards_and_suits

  def initialize
    @cards_and_suits = generate_deck
  end

  def deal_card
    card_index = rand(@cards_and_suits.count)
    card = @cards_and_suits[card_index]
    @cards_and_suits.delete_at(card_index)
    card
  end

  def logo
    "#{Card.spades} #{Card.hearts} #{Card.clubs} #{Card.diamonds}"
  end

  private

  def generate_deck
    Card::CARDS.zip(Card::POINTS).product(Card.cards_suit.values).map { |n_arr, s| Card.new(n_arr, s) }
  end
end
