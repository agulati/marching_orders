class GameEngine
  attr_reader :game, :deck, :channel

  class << self
    def new_game num_players:, channel:, user:
      game = Game.create!(
        num_players: num_players,
        state: { players: [ { user: user, hand: [], out: false, discards: [] } ] },
        channel: channel,
        active: true
      )

      $slack_client.chat_postMessage(
        channel: channel,
        text: "Very good, <@#{user}>. Please have the remaining #{game.num_players - 1} recruits report in."
      )
    end

    def end_game channel:
      Game.where(channel: channel, active: true).each(&:end_game)
    end

    def add_player channel:, user:
      game = Game.for_channel(channel: channel)

      reply = if game.nil?
        "Sorry, there's no game here right now."
      elsif game.has_user?(user: user)
        "Who are you covering for, <@#{user}>? You know you're already checked in."
      else
        state = game.state
        state[:players] << { user: user, hand: [], out: false, discards: [] }
        game.update_attributes!(state: state)

        "Copy that. Welcome to the team, <@#{user}>."
      end

      StartGameJob.perform_later(channel) if game.state[:players].length == game.num_players

      reply
    end

    def start_game channel:
      game = Game.for_channel(channel: channel)

      $slack_client.chat_postMessage(
        channel: channel,
        text: "Atten-HUT!"
      )

      $slack_client.chat_postMessage(
        channel: channel,
        text: "New orders have arrived from HQ. They are definitely above your pay grade. Now let's get 'em where they gotta go."
      )

      new(game: game).start
    end
  end

  def initialize game:
    @game     = game
    @deck     = initial_deck
    @channel  = game.channel
  end

  def start
    deal
    set_starting_player
    TurnEngine.take_turn(game: game)
  end

  private

  def set_starting_player
    state = game[:state]
    player_index = rand(game.num_players)
    state[:current_player] = player_index
    game.update_attributes!(state: state)

    $slack_client.chat_postMessage(
      channel: channel,
      text: "Fall In! You've got point, <@#{state[:players][player_index][:user]}>. Forward MARCH!"
    )
  end

  def deal
    state   = game.state
    players = state[:players]

    players.each do |player|
      card  = card_from_deck
      player[:hand] << card


      args = {
        channel: channel,
        user: player[:user],
        text: "Your hand, <@#{player[:user]}>",
        attachments: [
          {
            title: card.titleize,
            image_url: "#{ENV["ASSET_PATH"]}#{card}.jpg",
            fields: [
              {
                title: "Points",
                value: characters[card],
                short: true
              }
            ]
          }
        ]
      }

      $slack_client.chat_postEphemeral(**args)
    end

    state[:deck] = deck
    game.update_attributes!(state: state)
  end

  def card_from_deck
    deck.delete_at(rand(deck.length))
  end

  def initial_deck
    [
      Character::Ranks::GENERAL,
      Character::Ranks::COLONEL,
      Character::Ranks::MAJOR,
      Character::Ranks::CAPTAIN,
      Character::Ranks::CAPTAIN,
      Character::Ranks::LIEUTENANT,
      Character::Ranks::LIEUTENANT,
      Character::Ranks::SERGEANT,
      Character::Ranks::SERGEANT,
      Character::Ranks::CORPORAL,
      Character::Ranks::CORPORAL,
      Character::Ranks::PRIVATE,
      Character::Ranks::PRIVATE,
      Character::Ranks::PRIVATE,
      Character::Ranks::PRIVATE,
      Character::Ranks::PRIVATE,
    ]
  end

  def characters
    @characters ||= Character.all.each_with_object({}) { |c, h| h[c.rank.to_sym] = c.value }.with_indifferent_access
  end
end
