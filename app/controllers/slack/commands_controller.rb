module Slack
  class CommandsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]

    def create
      response = CommandHandler.handle_command(**formatted_params)
      render status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok], json: response
    end

    private

    def formatted_params
      {
        channel:  params[:channel_id],
        user:     params[:user_id],
        command:  params[:command],
      }
    end
  end
end
