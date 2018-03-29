class Mariposta::DeploymentsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def new
    render json: {status: 'Use POST instead, please!'}
  end
  def create
    # process the webhook!

    Rails.logger.info "** INCOMING: #{params.inspect}"

    render json: {status: 'ok'}
  end
end