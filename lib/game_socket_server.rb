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

  def ask_for_names(names = nil)
    if names

      self.clients += waiting_clients
      waiting_clients.clear
      self.client_names += names

    else

      names_from_waiting
    end
  end

  private

  def names_from_waiting
    waiting_clients.each do |client|
      name = ask_for_name(client)
      clients << waiting_clients.delete(client)
      client_names << name
    end
  end

  def ask_for_name(client, client_name = nil)
    client.puts('What is your name?')

    client_name ||= listen_for_client(client) until client_name
    p client_name

    client.puts("Your name is #{client_name}.")

    client_name
  end
end
