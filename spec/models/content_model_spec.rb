require 'rails_helper'

RSpec.describe Mariposta::ContentModel, :type => :model do
  it "can generate output" do
    content_model = ContentModelTest.new(
      first_name: "First",
      last_name: "Last",
      content: "I am *awesome* Markdown _content_!"
    )
    expect(content_model.generate_file_output).to eq("---\nfirst_name: First\nlast_name: Last\n---\n\nI am *awesome* Markdown _content_!")

    content_model.occupation = "Jekyll Content"
    expect(content_model.generate_file_output).to eq("---\nfirst_name: First\nlast_name: Last\noccupation: Jekyll Content\n---\n\nI am *awesome* Markdown _content_!")
  end

  it "supports computed front matter" do
    content_model = ContentModelTest.new(
      first_name: "First",
      last_name: "Last"
    )
    content_model.compute_full_name = true
    expect(content_model.generate_file_output).to eq("---\nfirst_name: First\nlast_name: Last\nfull_name: First Last\n---\n\n")

    content_model.full_name = "Shouldn't have any effect"
    expect(content_model.generate_file_output).to eq("---\nfirst_name: First\nlast_name: Last\nfull_name: First Last\n---\n\n")
  end

  it "can save output" do
    save_path = File.expand_path("../../../test/tmp/file_output.md", __FILE__)
    File.delete(save_path) if File.exists?(save_path)

    content_model = ContentModelTest.new(file_path: save_path)
    content_model.first_name = "First Name"
    content_model.tags = ["tag 1", "tag 2"]
    random_number = SecureRandom.random_number(10000)
    content_model.content = "I am *awesome* Markdown _content_! #{random_number}"
    content_model.save

    saved_file_data = File.open(save_path).read
    expect(saved_file_data).to eq("---\nfirst_name: First Name\ntags:\n- tag 1\n- tag 2\n---\n\nI am *awesome* Markdown _content_! #{random_number}")
  end

  it "can load a markdown file with front matter" do
    file_path = STATIC_SITE_FOLDER + "/_posts/2016-07-02-test-post.md"
    content_model = ContentModelTest.find(file_path)

    expect(content_model.author).to eq("Jared White")
    expect(content_model.content).to eq("I am *awesome* Markdown _content_!\n")
    expect(content_model.tags[1]).to eq("tag 2")
    expect(content_model.draft).to eq(true)
  end

  it "can update an existing markdown file with front matter" do
    save_path = File.expand_path("../../../test/tmp/file_output2.md", __FILE__)
    File.delete(save_path) if File.exists?(save_path)

    content_model = PostModelTest.new(file_path: save_path)
    content_model.title = "Post Title"
    content_model.author = "Jared White"
    content_model.tags = ["tag 1", "tag 2"]
    content_model.content = "I am *awesome* Markdown _content_!\n"

    content_model.save

    content_model2 = PostModelTest.find(save_path)
    params = {title: "Updated Post Title", draft: true}
    content_model2.assign_attributes(params)
    content_model2.save

    content_model3 = PostModelTest.find(save_path)
    expect(content_model3.title).to eq("Updated Post Title")
    expect(content_model3.author).to eq("Jared White")
    expect(content_model3.content).to eq("I am *awesome* Markdown _content_!\n")
    expect(content_model3.tags[1]).to eq("tag 2")
    expect(content_model3.draft).to eq(true)
    expect(content_model3.file_name).to eq('file_output2.md')
  end
end
