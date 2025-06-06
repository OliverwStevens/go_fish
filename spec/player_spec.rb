require_relative '../lib/player'

describe Player do
  it 'adds a card' do
    player = Player.new
    player.add_card(PlayingCard.new('♥', '2'))
    expect(player.hand.count).to eql(1)
  end

  it 'checks to see if a player has a card of rank X' do
    player = Player.new
    player.add_card(PlayingCard.new('♥', '2'))
    expect(player.has_card_of_rank?('2')).to eql(true)
  end

  xit 'checks for a match' do
    player = Player.new
    player.hand = [PlayingCard.new('♥', '2'), PlayingCard.new('♦', '2'), PlayingCard.new('♠', '2'),
                   PlayingCard.new('♣', '2')]
    expect(player.find_matches).to eql(true)
  end
end
