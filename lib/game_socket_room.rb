require_relative 'game'
class GameSocketRoom
  attr_accessor :game

  def initialize(clients)
    puts 'Created game'
    @game = Game.new(clients.count)
    @rounds = 0

    game.deal_cards
  end
end
