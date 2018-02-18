class Game < ApplicationRecord
  HASHID_SALT   = "10a9485d-ca3f-45bd-9aae-4c98abff2414"
  HASHID_COUNT  = 12
  HASHID_CHARS  = "abcdefghijkABCDEFGHIJK12345"

  serialize :state, JSON

  validates :num_players, presence: true
  validates :channel,     presence: true
  validates :state,       presence: true

  def self.for_channel channel:
    Game.where(channel: channel, active: true).first
  end

  def state
    self[:state].with_indifferent_access
  end

  def has_user? user:
    state[:players].detect { |player| player[:user] == user }.present?
  end

  def end_game
    update_attributes!(active: false)
  end
end
