# frozen_string_literal: true

module Status
  def game_initialized_st
    @status = 'game_initialized'
  end

  def start_round_st
    @status = 'start_round'
  end

  def take_a_bet_st
    @status = 'take_a_bet'
  end

  def release_money_st
    @status = 'release_money'
  end

  def user_round_st
    @status = 'user_round'
  end

  def dealer_round_st
    @status = 'dealer_round'
  end

  def game_over_st
    @status = 'game_over'
  end

  def game_over?
    @status == 'game_over'
  end

  def round_over_st
    @status = 'round_over'
  end

  def open_cards_st
    @status = 'open_cards'
  end

  def new_round_st
    @status = 'new_round'
  end
end
