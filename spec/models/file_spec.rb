require 'rails_helper'

RSpec.describe Mariposta::File, :type => :model do

  it "can generate output" do
    f = Mariposta::File.new(using_fmm: FmmTest)
    f.front_matter.first_name = "First Name"
    f.content = "I am *awesome* Markdown _content_!"

    expect(f.generate_output).to eq("---\nfirst_name: First Name\nlast_name: \ntags: \n---\n\nI am *awesome* Markdown _content_!")
  end

  it "can save output" do
    f = Mariposta::File.new(using_fmm: FmmTest)
    f.front_matter.first_name = "First Name"
    f.front_matter.tags = ["tag 1", "tag 2"]
    f.content = "I am *awesome* Markdown _content_!"

    save_path = File.expand_path("../../../test/tmp/file_output.md", __FILE__)

    f.save(save_path)

    saved_file_data = File.open(save_path).read

    expect(saved_file_data).to eq("---\nfirst_name: First Name\nlast_name: \ntags:\n- tag 1\n- tag 2\n---\n\nI am *awesome* Markdown _content_!")
  end

  it "can load a markdown file with front matter" do
    file_path = STATIC_SITE_FOLDER + "/_posts/2016-07-02-test-post.md"
    f = Mariposta::File.read(file_path, using_fmm: PostTest)

    expect(f.front_matter.author).to eq("Jared White")
    expect(f.content).to eq("I am *awesome* Markdown _content_!\n")
    expect(f.front_matter.tags[1]).to eq("tag 2")
    expect(f.front_matter.draft).to eq(true)
  end

end
