require_relative 'models/user'
require_relative 'models/dealer'
require_relative 'models/deck'

class Game
  attr_accessor :user, :dealer, :game_bank

  def initialize
    @game_bank = 0
  end

  def menu
    #loop do

      puts "Welcome to Blackjack game! #{Deck.spades} #{Deck.hearts} #{Deck.clubs} #{Deck.diamonds}"
      puts "1 - Start new game"
      puts "0 - Exit"

      print 'Enter action number: '
      user_input = gets.chomp.to_i
      #user_input = 1

      case user_input
      when 1
        new_game
      when 0
        #break
        puts "By, by!"
      else
        puts "Sorry, don't know this action!"
      end

      #end

      #puts "By, by!"
  end

  private

  def new_game
    menu_retry("Let's start!"){
      puts "Enter you name:"
      user_input = gets.chomp
      #user_input = "hanna"
      @user = Player.new(user_input)
      @dealer = Dealer.new(@user)
      @dealer.start_game
      show_stats

      @dealer.put_a_bet
      take_a_bet
      @user.put_a_bet
      take_a_bet

      puts "Game bank: #{@game_bank}"
      show_stats

      until game_over? do
        puts "#{@user.name} your turn. Choose:"
        puts "1 - Skip"
        puts "2 - Add card"
        puts "3 - Open cards"

        user_input = gets.chomp.to_i
        case user_input
        when 1
          #@user.skip
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
        show_stats
      end
      puts "Game over !"
      @dealer.open_cards
      show_stats
    }
  end

  def final_score
    winner = "Dead heat" if (@dealer.points == @user.points) || (@user.points > 21 && @dealer.points > 21)
    winner = @dealer if @user.points > 21 && @dealer.points <= 21
    winner = @user if @dealer.points > 21 && @user.points <= 21
    winner = @dealer if (User::MAX_POINTS - @dealer.points) < (User::MAX_POINTS - @user.points)
    winner = @user if (User::MAX_POINTS - @dealer.points) > (User::MAX_POINTS - @user.points)
  end

  def game_over?
    @dealer.cards.count == 3 && @user.cards.count == 3
  end

  def show_stats
    puts @dealer
    puts @user
  end

  def take_a_bet(amount = 10)
    @game_bank += amount
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
