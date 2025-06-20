require_relative 'game_socket_server'

server = GameSocketServer.new

server.start
loop do
  server.accept_new_client

  server.names_from_waiting
  game = server.create_game_if_possible

  server.run_game(game) if game
rescue # rubocop:disable Style/RescueStandardError
  server.stop
end
