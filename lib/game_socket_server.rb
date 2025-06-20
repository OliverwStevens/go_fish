require 'socket'

require_relative 'game_socket_room'

class GameSocketServer
  attr_accessor :server, :clients, :client_names

  def initialize
    @clients = []
    @client_names = []
  end

  def port_number
    3336
  end

  def waiting_clients
    @waiting_clients ||= []
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

    client.puts('What is your name?')

    waiting_clients.push(client)
    # 2
  rescue IO::WaitReadable, Errno::EINTR
  end

  def stop
    server&.close
  end

  def create_game_if_possible(num_of_players = 2)
    return unless clients.count >= num_of_players

    room_members = clients_in_rooms.concat(clients)

    room = GameSocketRoom.new(room_members, client_names)
    rooms.push(room)

    clients.clear
    client_names.clear
    room
  end

  def run_game(room)
    room.run_game
  end

  def listen_for_client(client)
    sleep(0.1)
    begin
      client.read_nonblock(1000).chomp
      # client.gets.chomp
    rescue IO::WaitReadable
    end
  end

  def names_from_waiting
    waiting_clients.each do |client|
      name = listen_for_client(client)
      next unless name

      clients << waiting_clients.delete(client)
      client_names << name

      client.puts("Your name is #{name}.")
    end
  end
end
