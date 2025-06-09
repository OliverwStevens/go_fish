require_relative 'game'
class GameSocketRoom
  attr_reader :clients
  attr_accessor :game

  def initialize(clients)
    puts 'Created game'
    @game = Game.new(clients.count)
    @rounds = 0
    @clients = clients

    game.deal_cards

    message_all_clients('The players in this game are')
    game.players.each do |player|
      message_all_clients(player.name)
    end
  end

  def message_all_clients(message)
    # binding.irb
    clients.each do |client|
      client.puts(message)
    end
  end
end
