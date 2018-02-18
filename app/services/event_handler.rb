class EventHandler
  attr_reader :type, :channel, :text, :user, :event_id, :event_ts

  EVENTS = [
    MENTION = "app_mention"
  ]

  ACTIONS = {
    new_game: /^(.*) new (\d)$/,
    end_game: /^(.*) end$/,
  }

  def self.handle_event event:, event_id:
    new(event: event, event_id: event_id).process_event
  end

  def initialize event:, event_id:
    @type     = event[:type]
    @channel  = event[:channel]
    @text     = event[:text]
    @user     = event[:user]
    @event_ts = event[:event_ts]
    @event_id = event_id
  end

  def process_event
    return unless check_cache_event_id

    return send_unknown_event unless EVENTS.include?(type)

    ACTIONS.each do |command, matcher|
      command_match = matcher.match(text)

      if command_match
        args = command_match.to_a.drop(1)
        return send(command, args)
      end
    end

    send_unknown_event
  end

  private

  def check_cache_event_id
    key     = "#{channel}:#{event_id}"
    value   = Redis.current.get(key)
    new_id  = value.nil?

    Redis.current.set(key, event_ts) if new_id
    new_id
  end

  def new_game args
    existing_game = Game.for_channel(channel: channel)
    return send_game_exists if existing_game.present?

    players = args.last.to_i
    return send_wrong_players if players < 2 || players > 4

    GameEngine.new_game(num_players: players, channel: channel, user: user)
  end

  def end_game _
    GameEngine.end_game(channel: channel)
    $slack_client.chat_postMessage(channel: channel, text: "This channel no longer has any active games. Good bye.")
  end

  def send_unknown_event
    $slack_client.chat_postMessage(channel: channel, text: "What was that soldier?")
  end

  def send_game_exists
    $slack_client.chat_postMessage(channel: channel, text: "Sorry, there's already a game in this channel.")
  end

  def send_wrong_players
    $slack_client.chat_postMessage(channel: channel, text: "This game can only be played with 2-4 players.")
  end
end
