class TurnEngine
  attr_reader :game, :player

  def self.take_turn game:
    new(game: game).take_turn
  end

  def initialize game:
    @game   = game
    @player = game.state[:players][game.state[:current_player]]
  end

  def take_turn
    draw
    request_action
  end

  private

  def request_action
    state = game.state
    deck  = state[:deck]
    state[:players][player][:hand] << deck.delete_at(rand(deck.length))
    state[:deck] = deck
    # game.update_attributes!(state: state)

    args = {
      channel: game.channel,
      user: player[:user],
      text: "What would you like to do, <@#{player[:user]}>?",
      attachments: [
        {
          text: "Let's move, soldier.",
          callback_id: "turn",
          actions: player[:hand].map do |card|
            {
              name: "card",
              text: card.titleize,
              type: "button",
              value: card,
            }
          end
        }
      ]
    }

    $slack_client.chat_postEphemeral(**args)

  end

  def draw
    state = game.state
    deck  = state[:deck]
    player[:hand] << deck.delete_at(rand(deck.length))
    state[:deck] = deck
    game.update_attributes!(state: state)

    args = {
      channel: game.channel,
      user: player[:user],
      text: "Your hand, <@#{state[:players][player][:user]}>",
      attachments: player[:hand].map do |card|
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
      end
    }

    $slack_client.chat_postEphemeral(**args)
  end

  def characters
    @characters ||= Character.all.each_with_object({}) { |c, h| h[c.rank.to_sym] = c.value }.with_indifferent_access
  end
end
