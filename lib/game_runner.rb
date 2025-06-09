require_relative 'game'

game = Game.new
game.deal_cards
rounds = 0

puts 'The players in this game are'
game.players.each do |player|
  puts player.name
end

until game.game_end?
  # Loop here, this will be a turn
  current_player = game.players[rounds % game.players.count]
  rounds += 1

  # loop for turn here
  turn_over = false

  until turn_over
    unless current_player.has_cards?
      if game.deck.has_cards?
        puts game.draw_if_hand_empty(current_player)
      else
        turn_over = true
        puts 'The deck is out of cards, you are out of the game.'
      end
    end

    puts "#{current_player.name} your cards are"
    current_player.hand.each do |card|
      puts "#{card.rank} of #{card.suit}"
    end

    opponent, rank = []
    until game.validate_input?(opponent, rank)
      puts 'What player do you want to ask for a card?'
      opponent_input = gets.chomp
      opponent = game.return_opponent(current_player, opponent_input)

      opponent&.hand&.each do |card|
        puts "#{card.rank} of #{card.suit}"
      end
      puts 'What rank do you want?'
      rank_input = gets.chomp
      rank = game.return_rank(current_player, rank_input)

    end
    # Add turn continuing functionality
    message = game.round(current_player, opponent, rank)
    puts message

    turn_over = true unless message.match("rank #{rank}")

    # check for matches

    puts current_player.find_matches
  end
end
