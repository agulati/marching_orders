class Character < ApplicationRecord
  belongs_to :action

  validates :rank, uniqueness: true, presence: true
  validates :action, presence: true
  validates :display, presence: true

  module Ranks
    GENERAL     = "general"
    COLONEL     = "colonel"
    MAJOR       = "major"
    CAPTAIN     = "captain"
    LIEUTENANT  = "lieutenant"
    SERGEANT    = "sergeant"
    CORPORAL    = "corporal"
    PRIVATE     = "private"
  end

  def take_action player:, game:
    action.behavior.constantize.perform(player: player, game: game)
  end
end
