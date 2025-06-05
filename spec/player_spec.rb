require_relative '../lib/player'

describe Player do
  it 'adds a card' do
    player = Player.new
    player.add_card(PlayingCard.new('♥', '2'))
    expect(player.hand.count).to eql(1)
  end
end
