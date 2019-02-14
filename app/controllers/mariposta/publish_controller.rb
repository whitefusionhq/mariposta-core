class Mariposta::PublishController < ApplicationController

  def review

  end

  def now
    git_remote = ENV['git_publish_remote'] || 'origin'
    site_url = ENV['published_site_url']

    Mariposta::Repository.current.commit(message: params[:commit_message])
    Mariposta::Repository.current.push(remote: git_remote)

    render json: {status: 'ok', published_site_url: site_url}
  end

end
