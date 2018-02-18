class LoseIfDiscarded
  def self.perform player:, game:
    state = game.state
    state[:players][player][:out] = true
    game.update_attributes(state: state)
  end
end
