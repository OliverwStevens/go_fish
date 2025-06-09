require_relative '../lib/game_socket_server'
require_relative '../lib/mock_game_socket_client'
require_relative 'spec_helper'

describe GameSocketServer do
  let(:client1) { MockGameSocketClient.new(@server.port_number) }
  let(:client2) { MockGameSocketClient.new(@server.port_number) }

  before(:each) do
    @clients = []
    @server = GameSocketServer.new
    @server.start
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { MockGameSocketClient.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts new clients' do
    add_client(client1)
    expect(@server.clients.count).to eql(1)
  end

  it 'trys to create a game if possible' do
    add_client(client1)
    add_client(client2)

    @server.create_game_if_possible
    expect(@server.rooms.count).to eql(1)
  end
end

private

def add_client(client)
  @clients.push(client)
  @server.accept_new_client
end
