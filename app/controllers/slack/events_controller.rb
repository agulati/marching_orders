module Slack
  class EventsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :accept_challenge, if: :challenge_requested?

    def create
      EventHandler.handle_event(event: params.require(:event), event_id: event_id)
      render status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:no_content], json: nil
    end

    private

    def challenge_requested?
      params[:challenge].present?
    end

    def accept_challenge
      render status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok], json: { challenge: params[:challenge] }
    end

    def event_id
      params.permit(:event_id)[:event_id]
    end
  end
end
