class Mariposta::Awesome
  attr_accessor :url

  def initialize(url)
    url_valid = url.starts_with?(ENV['published_site_url']) || url.starts_with?(ENV['preview_site_url'])

    unless url_valid
      raise Mariposta::BadRequest, "URL host mismatch"
    end

    self.url = url
  end

  def increment
    Rails.cache.increment("awesome/#{digest_url}")
  end

  def count
    Rails.cache.read("awesome/#{digest_url}", raw: true).to_i
  end

  def digest_url
    Digest::MD5.hexdigest(url)
  end

  # TODO: return awesome keys: r.scan(0, match: "cache:awesome/*")
end
