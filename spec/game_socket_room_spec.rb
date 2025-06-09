require_relative 'spec_helper'
require_relative '../lib/game_socket_server'
require_relative '../lib/game_socket_room'
require_relative '../lib/mock_game_socket_client'

describe GameSocketRoom do
  let(:client1) { MockGameSocketClient.new(@server.port_number) }
  let(:client2) { MockGameSocketClient.new(@server.port_number) }
  # let(:room) { GameSocketRoom.new(clients) }

  before(:each) do
    @clients = []
    @server = GameSocketServer.new
    @server.start
    sleep 0.1

    add_client(client1)
    add_client(client2)

    @server.create_game_if_possible(2)

    @room = @server.rooms.first
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end
  it '#message_all_clients' do
    @room.message_all_clients('Hello')
    expect(client1.capture_output).to match(/hello/i)
    # expect(client2.capture_output).to match(/hello/i)
  end

  private

  def add_client(client)
    @clients.push(client)
    @server.accept_new_client
  end
end
