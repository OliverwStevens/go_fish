require_relative 'game_socket_server'

server = GameSocketServer.new

server.start
loop do
  num_of_players = server.accept_new_client
  game = server.create_game_if_possible(num_of_players)
  # server.run_game(game) if game
rescue # rubocop:disable Style/RescueStandardError
  server.stop
end
