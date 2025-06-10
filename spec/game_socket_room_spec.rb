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

  it 'makes a room with 2 players' do
    expect(@room.game.players.count).to eql(2)
  end
  it '#message_all_clients' do
    @room.message_all_clients('Hello')
    expect(client1.capture_output).to match(/hello/i)
    expect(client2.capture_output).to match(/hello/i)
  end

  it '#messages_other_clients' do
    @room.message_other_clients('Hello')
    expect(client1.capture_output).to_not match(/hello/i)
    expect(client2.capture_output).to match(/hello/i)
  end

  it '#start_game' do
    @room.start_game
    expect(client1.capture_output).to match(/the players/i)
  end

  it '#current_player' do
    expect(@room.current_player).to eql(get_player(0))
  end

  it '#check_to_have_cards' do
    expect(@room.check_to_have_cards).to be_nil
  end

  it '#display_cards' do
    @room.start_game
    @room.display_cards
    expect(client1.capture_output).to match(/of/i)
  end

  it '#get_opponent' do
    client1.provide_input('Player 2')
    # binding.irb
    expect(@room.get_opponent).to eql(get_player(1))
  end

  it '#get_rank' do
    get_player(0).hand = [PlayingCard.new('♥', '2')]
    client1.provide_input('2')
    expect(@room.get_rank).to eql('2')
  end
  it '#turn' do
    get_player(0).hand = [PlayingCard.new('♥', '2')]
    get_player(1).hand = [PlayingCard.new('♦', '2')]
    expect(@room.turn(get_player(1), '2')).to eql(true)
  end

  private

  def add_client(client)
    @clients.push(client)
    @server.accept_new_client
  end

  def get_player(index)
    @room.game.players[index]
  end
end
