# frozen_string_literal: true

require_relative '../modules/validation'

class User
  include Validation

  attr_accessor :name, :bank, :cards, :points, :hide, :wins

  validate :name, :presence
  MAX_POINTS = 21
  MAX_CARDS  = 3

  def initialize(name)
    @name   = name
    @bank   = 100
    @points = 0
    @cards  = []
    @hide   = false
    @wins   = 0
  end

  def add_card(card)
    raise "User can't have more than 3 cards!" if @cards.count == 3

    @cards << card
    calculate_points(card)
  end

  def clear_cards
    @cards = []
    @points = 0
  end

  def put_a_bet(amount = 10)
    raise 'Not enought money!' if (@bank - amount).negative?

    @bank -= amount
    amount
  end

  def take_money(amount = 0)
    @bank += amount
    amount
  end

  def add_win
    @wins += 1
  end

  private

  def calculate_points(card)
    @points += card.points
    @points -= 10 if @cards.count > 2 && @cards.any?(&:ace?) && @points > MAX_POINTS
  end

  def to_s
    showed, points = ''
    if hide
      @cards.each { |_el| showed += '[*]' }
      points = '*'
    else
      @cards.each { |el| showed += "[#{el.name}, #{el.suit}]" }
      points = @points
    end

    "My name is #{@name} and I had #{@bank}$ and #{@cards.count} cards: #{showed} and points: #{points}."
  end
end
