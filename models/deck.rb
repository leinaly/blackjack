# frozen_string_literal: true

class Deck
  attr_accessor :cards_and_suits

  СARDS_SUIT = { 'Diamonds' => "\u2666", 'Hearts' => "\u2665", 'Spades' => "\u2664", 'Clubs' => "\u2667" }
  CARDS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  def initialize
    @cards_and_suits = generate_deck
  end

  def deal_card
    card_index = rand(@cards_and_suits.count)
    card = @cards_and_suits[card_index]
    @cards_and_suits.delete_at(card_index)
    card
  end

  def self.diamonds
    СARDS_SUIT['Diamonds']
  end

  def self.hearts
    СARDS_SUIT['Hearts']
  end

  def self.spades
    СARDS_SUIT['Spades']
  end

  def self.clubs
    СARDS_SUIT['Clubs']
  end

  def self.ace?(card)
    card.first == CARDS.last
  end

  def self.not_ace?(card)
    !ace?(card)
  end

  private

  def generate_deck
    CARDS.product(СARDS_SUIT.values)
  end
end
