# frozen_string_literal: true

require_relative 'models/user'
require_relative 'models/dealer'
require_relative 'models/player'
require_relative 'models/deck'
require_relative 'modules/validation'
require_relative 'modules/status'

class Game
  include Validation
  include Status

  attr_reader :status
  attr_reader :player, :dealer, :game_bank, :winner

  validate :player, :type, Player
  validate :dealer, :type, Dealer

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @game_bank = 0
    @winner = nil
    game_initialized_st
  end

  # available_actions for this game status
  def actions
    %w[game_initialized start_round user_round dealer_round open_cards take_a_bet release_money game_over round_over]
  end

  def start_round
    @dealer.clear_cards
    @player.clear_cards

    2.times { @dealer.add_card(@dealer.deal_card) }
    2.times { @player.add_card(@dealer.deal_card) }

    take_a_bet(@dealer.put_a_bet)
    take_a_bet(@player.put_a_bet)

    start_round_st
  end

  def player_skip
    dealer_play
    dealer_round_st
  end

  def player_add_card
    @player.add_card(@dealer.deal_card)
    round_over? ? open_cards : dealer_round_st
  end

  def player_ended
    game_over_st
  end

  def open_cards
    @dealer.open_cards
    open_cards_st
  end

  def round_over
    round_over_st if round_over?
  end

  def player_cards
    @player.cards
  end

  def dealer_cards
    @dealer.cards
  end

  def dealer_play
    @dealer.play
    user_round_st
  end

  def choose_winner
    if (@dealer.points == @player.points) || (@player.points > User::MAX_POINTS && @dealer.points > User::MAX_POINTS)
      @winner = nil
    end
    @winner = @dealer if @player.points > User::MAX_POINTS && @dealer.points <= User::MAX_POINTS
    @winner = @player if @dealer.points > User::MAX_POINTS && @player.points <= User::MAX_POINTS
    if ((User::MAX_POINTS - @dealer.points) < (User::MAX_POINTS - @player.points)) && (User::MAX_POINTS - @dealer.points) >= 0
      @winner = @dealer
    end
    if ((User::MAX_POINTS - @dealer.points) > (User::MAX_POINTS - @player.points)) && (User::MAX_POINTS - @player.points) >= 0
      @winner = @player
    end
    @winner
  end

  def congrat_the_winner
    @winner.add_win
    @winner.take_money(release_money)
  end

  def round_over?
    (@dealer.cards.count == User::MAX_CARDS && @player.cards.count == User::MAX_CARDS) || !@dealer.hide
  end

  def take_a_bet(amount = 10)
    @game_bank += amount
    take_a_bet_st
  end

  def release_money(amount = @game_bank)
    @game_bank -= amount
    release_money_st
    amount
  end

  def logo
    @dealer.deck.logo
  end
end
