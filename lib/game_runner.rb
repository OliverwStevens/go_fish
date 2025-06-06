require_relative 'game'

game = Game.new
game.deal_cards

rounds = 0

puts 'The players in this game are:'
game.players.each do |player|
  puts player.name
end

# Loop here, this will be a turn
current_player = game.players[rounds % game.players.count]

puts 'Your cards are'
current_player.hand.each do |card|
  puts "#{card.rank} of #{card.suit}"
end

opponent, rank = []
until game.validate_input?(opponent, rank)
  puts 'What player do you want to ask for a card?'
  opponent_input = gets.chomp
  opponent = game.return_opponent(current_player, opponent_input)

  puts 'What rank do you want?'
  rank_input = gets.chomp
  rank = game.return_rank(current_player, rank_input)

end

# game.round

rounds += 1
