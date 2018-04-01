class Mariposta::AwesomeController < ApplicationController
  skip_before_action :authenticate_user!, raise: false # devise
  skip_before_action :require_login, raise: false # sorcery
  skip_before_action :verify_authenticity_token

  def token
    token = SecureRandom.base58(32)

    Rails.cache.write("token/#{token}", "valid", expires_in: 12.hours)

    render json: {token: token}
  end

  def create
    begin
      if Rails.cache.read("token/#{params[:token]}").nil?
        raise Mariposta::BadRequest, "Invalid token"
      end

      awesome_count = Mariposta::Awesome.new(params[:url]).increment

      render json: {
        status: 'ok',
        count: awesome_count
      }
    rescue Mariposta::BadRequest => e
      render json: {status: 'error', error: e.message}, status: 500
    end
  end

  def show
    begin
      if Rails.cache.read("token/#{params[:token]}").nil?
        raise Mariposta::BadRequest, "Invalid token"
      end

      awesome_count = Mariposta::Awesome.new(params[:url]).count

      render json: {
        status: 'ok',
        count: awesome_count
      }
    rescue Mariposta::BadRequest => e
      render json: {status: 'error', error: e.message}, status: 500
    end
  end
end
