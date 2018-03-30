class Mariposta::DeploymentsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :verify_authenticity_token

  def new
    render json: {status: 'Use POST instead, please!'}
  end
  def create
    # process the webhook!

    deployment = Mariposta::Deployment.new(params)
    Rails.cache.write(:deployment_status, deployment.display_status)
    Rails.cache.write(:deployment_status_updated, Time.now)

    render json: {status: 'ok'}
  end
end
