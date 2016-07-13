require 'rails_helper'

RSpec.describe Mariposta::SiteConfig, :type => :model do

  it "can load a Jekyll config file" do
    config_path = STATIC_SITE_FOLDER + "/_config.yml"

    config = Mariposta::SiteConfig.new(config_path)

    expect(config.data['title']).to eq('INTERSECT')
    expect(config.data['social'][1]['username']).to eq('whitefusionfoundry')
  end

end
