class CommandHandler
  attr_reader :command, :user, :channel

  COMMANDS = {
    report: "/report"
  }

  def self.handle_command command:, user:, channel:
    new(command: command, user: user, channel: channel).process_command
  end

  def initialize command:, user:, channel:
    @command  = command
    @user     = user
    @channel  = channel
  end

  def process_command
    COMMANDS.each { |action, command| return send(action) }
    $slack_client.chat_postMessage(channel: channel, text: "What was that soldier?")
  end

  private

  def report
    {
      response_type: "in_channel",
      text: GameEngine.add_player(channel: channel, user: user),
    }
  end
end
