require 'socket'

require_relative 'game_socket_room'

class GameSocketServer
  attr_accessor :server

  def initialize
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

    client.puts('Waiting for other players')

    clients.push(client)
    # 2
  rescue IO::WaitReadable, Errno::EINTR
  end

  def stop
    server&.close
  end

  def create_game_if_possible(num_of_players = 2, client_names = nil)
    return unless clients.count >= num_of_players

    room_members = clients_in_rooms.concat(clients)

    client_names ||= ask_for_names(client_names)

    room = GameSocketRoom.new(room_members, client_names)
    rooms.push(room)

    clients.clear
    room
  end

  def run_game(room)
    room.run_game
  end

  def listen_for_client(client)
    sleep(0.1)
    begin
      client.gets.chomp
    rescue IO::WaitReadable
    end
  end

  private

  def ask_for_name(client, client_name = nil)
    client.puts('What is your name?')

    client_name ||= listen_for_client(client)

    client.puts("Your name is #{client_name}.")

    client_name
  end

  def ask_for_names(client_names)
    client_names ||= []
    clients.each do |client|
      name = ask_for_name(client)
      client_names << name
    end
    client_names
  end
end
