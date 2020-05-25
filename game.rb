# frozen_string_literal: true

require_relative 'models/user'
require_relative 'models/dealer'
require_relative 'models/deck'

class Game
  attr_accessor :user, :dealer, :game_bank

  MAX_CARDS = 3

  def initialize
    @game_bank = 0
  end

  def menu
    puts "Welcome to Blackjack game! #{Deck.spades} #{Deck.hearts} #{Deck.clubs} #{Deck.diamonds}"
    puts '1 - Start new game'
    puts '0 - Exit'

    print 'Enter action number: '
    user_input = gets.chomp.to_i

    case user_input
    when 1
      new_game
    when 0
      puts 'By, by!'
    else
      puts "Sorry, don't know this action!"
    end
  end

  private

  def new_game
    menu_retry("Let's start!") do
      puts 'Enter you name:'
      user_input = gets.chomp
      @user = Player.new(user_input)
      @dealer = Dealer.new(@user)

      while new_round?
        round
        final_score
      end
    end
  end

  def round
    @dealer.start_game
    take_a_bet(@dealer.put_a_bet)
    take_a_bet(@user.put_a_bet)

    puts "Game bank: #{@game_bank}"
    show_stats

    until game_over?
      user_step
      show_stats
    end
    @dealer.open_cards
    puts 'Game over !'
    show_stats
  end

  def user_step
    puts "#{@user.name} your turn. Choose:"
    puts '1 - Skip'
    puts '2 - Add card'
    puts '3 - Open cards'

    user_input = gets.chomp.to_i
    case user_input
    when 1
      puts "#{@dealer.name} turn!"
      @dealer.play
      puts "#{@user.name} turn!"
    when 2
      @user.add_card(@dealer.deal_card)
      puts "#{@dealer.name} turn!"
    when 3
      @dealer.open_cards
    else
      puts "Sorry, don't know this action!"
    end
  end

  def new_round?
    return true if first_round

    puts 'Do you want to play again? 1 - yes, 0 - no'
    user_input = gets.chomp.to_i
    case user_input
    when 1
      true
    when 0
      false
    else
      "Sorry I don't know this command!"
    end
  end

  def first_round
    (@user.wins + @dealer.wins).zero?
  end

  def final_score
    if (@dealer.points == @user.points) || (@user.points > User::MAX_POINTS && @dealer.points > User::MAX_POINTS)
      return 'Dead heat'
    end

    winner = @dealer if @user.points > User::MAX_POINTS && @dealer.points <= User::MAX_POINTS
    winner = @user   if @dealer.points > User::MAX_POINTS && @user.points <= User::MAX_POINTS
    if ((User::MAX_POINTS - @dealer.points) < (User::MAX_POINTS - @user.points)) && (User::MAX_POINTS - @dealer.points) >= 0
      winner = @dealer
    end
    if ((User::MAX_POINTS - @dealer.points) > (User::MAX_POINTS - @user.points)) && (User::MAX_POINTS - @user.points) >= 0
      winner = @user
    end
    puts "#{winner.name} win the game!"
    winner.wins += 1
    winner.take_money(release_money)
    puts "Dealer : User -- #{@dealer.wins} : #{@user.wins}"
  end

  def game_over?
    (@dealer.cards.count == MAX_CARDS && @user.cards.count == MAX_CARDS) || !@dealer.hide
  end

  def show_stats
    puts @dealer
    puts @user
  end

  def take_a_bet(amount = 10)
    @game_bank += amount
  end

  def release_money(amount = @game_bank)
    @game_bank -= amount
    amount
  end

  def menu_retry(success_msg)
    raise 'Need to pass block in method!' unless block_given?

    begin
      yield
    rescue RuntimeError => e
      puts e.message
      retry
    end
    puts success_msg
  end
end

Game.new.menu
