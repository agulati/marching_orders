module Slack
  class ActionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]

    def create
      render status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:no_content], json: nil
    end
  end
end
