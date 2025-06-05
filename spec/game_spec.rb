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

    allow(game).to receive(:gets).and_return('Player 2')

    expect(game.return_opponent(player)).to eql(player2)
  end

  it 'validates an opponent' do
    game = Game.new(2)
    player = game.players.first
    player2 = game.players.last

    allow(game).to receive(:gets).and_return('Not a valid player')

    allow(game).to receive(:gets).and_return('Player 2')

    expect(game.return_opponent(player)).to eql(player2)
  end

  it 'plays a roundt' do
    game = Game.new(2)
    allow(game).to receive(:gets).and_return('Player 2')
    game.round
    expect(game.rounds).to eql(1)
  end
end
