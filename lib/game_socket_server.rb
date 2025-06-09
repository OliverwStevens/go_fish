require 'socket'

require_relative 'game_socket_room'

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

  def clients_in_rooms
    @clients_in_rooms ||= []
  end

  def rooms
    @rooms ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client
    client = server.accept_nonblock
    puts 'Client accepted'

    client.puts('Welcome to Go Fish!')

    # sends message asking for player count and to start the game

    clients.push(client)
    2
  rescue IO::WaitReadable, Errno::EINTR
  end

  def stop
    server&.close
  end

  def create_game_if_possible(num_of_players = 2)
    return unless clients.count >= num_of_players

    room = GameSocketRoom.new(clients)
    rooms.push(room)
    clients_in_rooms.concat(clients)

    # clients.clear
  end
end
