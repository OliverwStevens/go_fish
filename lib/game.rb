require_relative 'card_deck'
require_relative 'player'
class Game
  attr_reader :deck
  attr_accessor :players

  def initialize(num_of_players = 2)
    @deck = CardDeck.new
    @players = Array.new(num_of_players) { |index| Player.new("Player #{index + 1}") }
  end

  def deal_cards
    if players.count < 4
      7.times do
        players.each do |player|
          player.add_card(deck.deal)
        end
      end

    else
      5.times do
      end
    end
  end
end
