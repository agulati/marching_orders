Slack.configure { |c| c.token = ENV["SLACKBOT_OAUTH_TOKEN"] }
$slack_client = Slack::Web::Client.new
