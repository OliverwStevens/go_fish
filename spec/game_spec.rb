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

  it 'receives an opponent' do
    game = Game.new(2)
    allow(game).to receive(:gets).and_return('Player 2')
    game.round
  end
end
