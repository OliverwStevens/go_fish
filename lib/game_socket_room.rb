require_relative 'game'
class GameSocketRoom
  attr_accessor :game

  def initialize(clients)
    @game = Game.new
    @rounds = 0

    game.deal_cards
  end
end
