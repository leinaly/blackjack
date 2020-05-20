require_relative 'models/user'
require_relative 'models/dealer'
require_relative 'models/deck'

class Main
  attr_accessor :user, :dealer

  def menu
    loop do

      puts "Welcome to Blackjack game! #{Deck.spades} #{Deck.hearts} #{Deck.clubs} #{Deck.diamonds}"
      puts "1 - Start new game"
      puts "0 - Exit"

      print 'Enter action number: '
      #user_input = gets.chomp.to_i
      user_input = 1

      case user_input
      when 1
        new_game
      when 0
        break
      else
        puts "Sorry, don't know this action!"
      end

    end

    puts "By, by!"
  end

  private

  def new_game
    menu_retry("Let's start!"){
      puts "Enter you name:"
      #user_input = gets.chomp
      user_input = "hanna"
      @user = User.new(user_input)
      @dealer = Dealer.new(@user)
      @dealer.start_game
      puts @dealer
      puts @user
    }
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

Main.new.menu
