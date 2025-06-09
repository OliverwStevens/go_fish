require 'socket'

require_relative 'game'

class GameSocketServer
  attr_accessor :server, :responses

  def initialize
    @responses = []
  end

  def port_number
    3336
  end

  def clients
    @clients ||= []
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client
    client = server.accept_nonblock
    puts 'Client accepted'

    # sends message asking to start the game

    client.puts('Welcome to Go Fish!')
    clients.push(client)
  rescue IO::WaitReadable, Errno::EINTR
  end

  def stop
    server&.close
  end

  def create_game_if_possible
    return unless clients.count >= 2

    game = Game.new(clients.count)
    games.push(game)
  end
end
