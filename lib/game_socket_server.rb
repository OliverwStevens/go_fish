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

  def players
    @players ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = 'Random Player')
    client = server.accept_nonblock
    puts 'Client accepted'
    client.puts('Welcome to Go Fish!')
    clients.push(client)
  rescue IO::WaitReadable, Errno::EINTR
  end

  def stop
    server&.close
  end
end
