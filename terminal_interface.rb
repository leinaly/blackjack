# frozen_string_literal: true

require_relative 'game'

class TerminalInterface
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def self.ask_user_name
    puts 'Enter you name:'
    user_choice_str
    gets.chomp
  end

  # Цикл с игрой - опрос состояния и показ возможных действий
  def start_game
    until @game.game_over?
      case @game.status
      when 'game_initialized'
        game_start_msg
      when 'start_round'
        puts 'Round started!'
        show_stats
        menu_retry('Good choice!') do
          user_step_msg
        end
      when 'round_over'
        another_round_msg
      when 'user_round'
        menu_retry('Good choice!') do
          user_step_msg
        end
      when 'dealer_round'
        @game.dealer_play
      when 'open_cards'
        final_score_msg
        @game.round_over
      else
        self.class.unknown_action_str
      end
    end
  end

  def self.user_choice_str
    print 'User input: '
  end

  def self.unknown_action_str
    puts "Sorry, don't know this action!"
  end

  private

  def game_start_msg
    puts "Welcome to Blackjack game! #{@game.logo}"
    puts '1 - Start new game'
    puts '0 - Exit'

    self.class.user_choice_str
    user_input = gets.chomp.to_i

    case user_input
    when 1
      new_game_msg
    when 0
      @game.player_ended
      puts 'By, by!'
    else
      self.class.unknown_action_str
    end
  end

  def new_game_msg
    @game.start_round
    puts "Game bank: #{@game.game_bank}"
    show_stats
  end

  def user_step_msg
    puts "#{@game.player.name} your turn. Choose:"
    puts '1 - Skip'
    puts '2 - Add card'
    puts '3 - Open cards'

    self.class.user_choice_str
    user_input = gets.chomp.to_i

    case user_input
    when 1
      puts "#{@game.dealer.name} turn!"
      @game.player_skip
    when 2
      @game.player_add_card
    when 3
      puts 'Open cards!'
      @game.open_cards
    else
      self.class.unknown_action_str
    end
    show_stats
  end

  def another_round_msg
    puts 'Do you want to play again? 1 - yes, 0 - no'
    self.class.user_choice_str
    user_input = gets.chomp.to_i
    case user_input
    when 1
      @game.start_round
    when 0
      @game.player_ended
      puts 'By by!'
    else
      self.class.unknown_action_str
    end
  end

  def final_score_msg
    if @game.choose_winner
      puts "#{@game.winner.name} win the game!"
      @game.congrat_the_winner
      puts "Dealer : User -- #{@game.dealer.wins} : #{@game.player.wins}"
      show_stats
    else
      puts 'Dead heat'
    end
  end

  def show_stats
    puts @game.dealer
    puts @game.player
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
