class StartGameJob < ApplicationJob
  queue_as :default

  def perform(channel)
    GameEngine.start_game(channel: channel)
  end
end
