require_relative '../modules/validation'

class User
  include Validation

  attr_accessor :name, :bank, :cards, :points, :hide

  validate :name, :presence
  MAX_POINTS = 21

  def initialize(name)
    @name   = name
    @bank   = 100
    @points = 0
    @cards  = []
    @hide   = false
  end

  def add_card(card)
    raise "User can't have more than 3 cards!" if @cards.count == 3
    @cards << card
    calculate_points(card)
  end

  def put_a_bet(amount = 10)
    raise 'Not enought money!' if (@bank - amount) < 0
    @bank -= amount
  end

  private

  def calculate_points(card)
    @points += card[0].to_i if card[0].to_i.between?(1,11)
    @points += 10           if card[0].to_i.zero? && Deck.not_ace?(card)
    @points += 1            if card[0].to_i.zero? && Deck.ace?(card) && MAX_POINTS-@points <= 11
    @points += 11           if card[0].to_i.zero? && Deck.ace?(card) && MAX_POINTS-@points > 11
  end

  def to_s
    showed, points = ''
    if hide
      @cards.count.times { showed += '[*]' }
      points = "*"
    else
      showed = @cards.to_s
      points = @points
    end

    "My name is #{@name} and I had #{@bank}$ and #{showed} and points: #{points}."
  end

end
