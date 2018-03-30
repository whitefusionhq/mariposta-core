class Mariposta::ImagesController < ApplicationController
  def index
    json_images = Cloudinary::Api.resources_by_tag('adminupload', max_results: 200)['resources']

    @images = json_images.map do |image|
      {
        path: "v#{image['version']}/#{image['public_id']}",
        id: image['public_id'],
        format: image['format']
      }
    end

    if params[:modal]
      @modal = true
      render layout: false
    end
  end
end
