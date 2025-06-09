require 'socket'

require_relative 'game'

class GameSocketServer
  attr_accessor :server, :responses
end
