require_relative '../lib/game'
describe Game do
  it 'deals the cards when there are 2 players' do
    game = Game.new(2)
    game.deal_cards
    expect(game.players.first.card_count).to eql(7)
    expect(game.players.count).to eql(2)
  end

  it 'deals the cards when there are 5 players' do
    game = Game.new(5)
    game.deal_cards
    expect(game.players.first.card_count).to eql(5)

    expect(game.players.count).to eql(5)
  end

  it 'returns an opponent' do
    game = Game.new(2)
    player = game.players.first
    player2 = game.players.last

    # allow(game).to receive(:gets).and_return('Player 2')

    expect(game.return_opponent(player, 'Player 2')).to eql(player2)
  end

  it 'returns a rank' do
    game = Game.new(2)

    player = game.players.first

    player.add_card(PlayingCard.new('♥', '2'))

    # allow(game).to receive(:gets).and_return('3')

    expect(game.return_rank(player, '2')).to eql('2')
  end

  it 'validates input' do
    game = Game.new(2)
    opponent = game.players.last
    expect(game.validate_input?(opponent, '2')).to eql(true)
  end
  it 'Ask for card and gets it from opponent' do
    game = Game.new(2)

    player_1 = game.players.first
    player_2 = game.players.last

    player_1.add_card(PlayingCard.new('♥', '2'))
    player_2.add_card(PlayingCard.new('♦', '2'))

    expect(game.round(player_1, player_2, '2')).to match(/received/i)
    expect(player_2.card_count).to eql(0)
  end

  it 'does not take the opponents other card' do
    game = Game.new(2)

    player_1 = game.players.first
    player_2 = game.players.last

    player_1.hand = [PlayingCard.new('♥', '2'), PlayingCard.new('♥', '3')]
    player_2.hand = [PlayingCard.new('♦', '2'), PlayingCard.new('♦', '3')]

    expect(game.round(player_1, player_2, '2')).to match(/received/i)
    expect(player_2.card_count).to eql(1)
  end
  it 'Gos Fish' do
    game = Game.new(2)

    player_1 = game.players.first
    player_2 = game.players.last

    player_1.add_card(PlayingCard.new('♥', '2'))
    player_2.add_card(PlayingCard.new('♦', '3'))

    game.round(player_1, player_2, '2')
    expect(player_1.card_count).to eql(2)

    expect(player_2.card_count).to eql(1)
  end

  it 'draws when the hand is empty' do
    game = Game.new(2)
    player_1 = game.players.first
    expect(game.draw_if_hand_empty(player_1)).to match(/You do not have any cards/i)
    expect(player_1.card_count).to eql(1)
  end
end
