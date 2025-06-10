require_relative 'game'
class GameSocketRoom
  attr_reader :clients
  attr_accessor :game, :rounds, :turn_over

  def initialize(clients, client_names)
    puts 'Created game'
    @game = Game.new(client_names)
    @rounds = 0
    @clients = clients
    @turn_over = false
  end

  def start_game
    game.deal_cards

    message_all_clients('The players in this game are')
    game.players.each do |player|
      message_all_clients(player.name)
    end
  end

  def run_game
    start_game
    until game.game_end?
      self.turn_over = false
      message_all_clients("#{current_player.name}'s turn")
      self.turn_over = true unless turn until turn_over

      self.rounds += 1
    end
  end

  def current_client
    clients[rounds % clients.count]
  end

  def current_player
    game.players[rounds % game.players.count]
  end

  def turn(opponent = nil, rank = nil)
    check_to_have_cards
    display_cards
    opponent ||= opponent = get_opponent until opponent
    rank ||= rank = get_rank until rank
    message_results(opponent, rank)
  end

  def check_to_have_cards
    return if current_player.has_cards?

    if game.deck.has_cards?
      draw_if_hand_empty

    else
      self.turn_over = true
      message_all_clients "The deck is out of cards, #{current_player.name} is out of the game."
    end
  end

  def display_cards
    current_client.puts "#{current_player.name} your cards are"
    current_player.hand.each do |card|
      current_client.puts "#{card.rank} of #{card.suit}"
    end
  end

  def message_all_clients(message)
    clients.each do |client|
      client.puts(message)
    end
  end

  def message_other_clients(message)
    other_clients = clients - [current_client]
    other_clients.each do |client|
      client.puts(message)
    end
  end

  def get_opponent
    current_client.puts 'What player do you want to ask for a card?'
    opponent_input = listen_for_client # gets.chomp
    game.return_opponent(current_player, opponent_input)
  end

  def get_rank
    current_client.puts 'What rank do you want?'
    rank_input = listen_for_client # gets.chomp
    rank = game.return_rank(current_player, rank_input)
  end

  def listen_for_client
    sleep(0.1)
    begin
      # current_client.read_nonblock(1000)
      current_client.gets.chomp
    rescue IO::WaitReadable
    end
  end

  def message_player_actions(message, opponent_name, rank, matches)
    message_other_clients "#{current_player.name} asks #{opponent_name} for a card of rank #{rank}"

    message_other_clients message_card_reception(message, rank)
    message_other_clients "#{current_player.name} ".concat(matches)
    return unless message.include? "rank #{rank}"

    message_other_clients "#{current_player.name} continues their turn."
  end

  private

  def message_results(opponent, rank)
    message = game.round(current_player, opponent, rank)

    current_client.puts(message)

    find_matches = current_player.find_matches
    current_client.puts('You '.concat(find_matches))

    message_player_actions(message, opponent.name, rank, find_matches)

    message.include? "rank #{rank}"
  end

  def message_card_reception(message, rank)
    return unless message.include? "rank #{rank}"

    if message.include? 'Go fish'
      "#{current_player.name} draws a card of rank #{rank} and lands their catch!"

    else
      "#{current_player.name} receives #{message[/\d+/]} cards of #{rank}"
    end
  end

  def draw_if_hand_empty
    current_client.puts game.draw_if_hand_empty(current_player)
    message_other_clients "#{current_player.name} draws a card because their hand is empty."
  end
end
