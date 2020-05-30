# frozen_string_literal: true

class Card
  CARDS      = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  POINTS     = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]
  attr_reader :name, :suit, :points

  def initialize(name_arr, suit)
    @name, @points = name_arr
    @suit = suit
  end

  def ace?
    @name == CARDS.last
  end

  def not_ace?
    !ace?
  end

  def to_s
    "[#{name}, #{suit}]"
  end

  def self.cards_suit
    { 'Diamonds' => "\u2666", 'Hearts' => "\u2665", 'Spades' => "\u2664", 'Clubs' => "\u2667" }
  end

  def self.diamonds
    cards_suit['Diamonds']
  end

  def self.hearts
    cards_suit['Hearts']
  end

  def self.spades
    cards_suit['Spades']
  end

  def self.clubs
    cards_suit['Clubs']
  end
end
