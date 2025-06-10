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

    @server.ask_for_names(%w[Player Player])
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

  context '#check_to_have_cards' do
    it 'puts to clients when hand is empty' do
      @room.check_to_have_cards
      expect(client1.capture_output).to match(/You do not have any cards, so you draw the card/i)

      expect(client2.capture_output).to match(/draws a card because their hand is empty/i)
    end
    it 'puts to clients when hand and deck are empty' do
      @room.game.deck.cards.clear
      @room.check_to_have_cards
      expect(client1.capture_output).to match(/The deck is out of cards, Player 1 is out of the game./i)

      expect(client2.capture_output).to match(/The deck is out of cards, Player 1 is out of the game./i)
    end
  end

  it '#display_cards' do
    @room.start_game
    @room.display_cards
    expect(client1.capture_output).to match(/of/i)
  end

  context '#get_opponent' do
    it 'gets an opponent' do
      client1.provide_input('Player 2')
      # binding.irb
      expect(@room.get_opponent).to eql(get_player(1))
    end

    it 'it does not get the opponent if it is invalid' do
      client1.provide_input('aieiheiw')
      # binding.irb
      expect(@room.get_opponent).to eql(nil)
    end
  end

  context '#get_rank' do
    it 'gets the rank' do
      get_player(0).hand = [PlayingCard.new('♥', '2')]
      client1.provide_input('2')
      expect(@room.get_rank).to eql('2')
    end

    it 'does not get the rank when it is invalid' do
      get_player(0).hand = [PlayingCard.new('♥', '2')]
      client1.provide_input('irhoif')
      expect(@room.get_rank).to eql(nil)
      client1.provide_input('2')
      expect(@room.get_rank).to eql('2')
    end
  end

  context '#message_player_actions' do
    it 'messages the other players when go fish leads to a catch' do
      message = 'Go fish! You got a card of rank 2'
      @room.message_player_actions(message, get_player(1).name, '2', 'made no matches')

      expect(client2.capture_output).to match(/draws a card of rank 2/i)
    end
    it 'messages the other players when go fish does not lead to a catch' do
      message = 'Go fish! You got a card of rank 3'
      @room.message_player_actions(message, get_player(1).name, '2', 'made no matches')

      expect(client2.capture_output).to_not match(/draws a card of rank 3/i)
    end

    it 'messages other players when the player takes a card from another player' do
      message = 'You got a 2 cards of rank 3'
      @room.message_player_actions(message, get_player(1).name, '3', 'made no matches')

      expect(client2.capture_output).to match(/receives 2 cards of 3/i)
    end
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
