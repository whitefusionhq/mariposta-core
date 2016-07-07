### DEPRICATED

class Mariposta::FrontMatter
  attr_accessor :front_matter

  def initialize(site=nil, filepath=nil)
    @front_matter = {}

    if site and filepath
      filedata = File.read(filepath, Jekyll::Utils.merged_file_read_opts(site, {}))

      front_matter_regexp = Jekyll::Document::YAML_FRONT_MATTER_REGEXP

      begin
        if filedata =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
          @front_matter = SafeYAML.load(Regexp.last_match(1))
        end
      rescue SyntaxError => e
        log_error "Error:", "YAML Exception reading #{path}: #{e.message}"
      end
    end
  end

  def merge_into_content(content)
    front_matter.to_yaml + "---\n\n" + content
  end

  def new_post_path(jekyll_site, ext="md")
    post_path_from_title = @front_matter['title'].sub("'","").parameterize
    post_date = Date.today.strftime('%Y-%m-%d')
    "#{jekyll_site.source}/_posts/#{post_date}-#{post_path_from_title}.#{ext}"
  end

  def log_error(error_type, error_string)
    Rails.logger.error "#{error_type} #{error_string}"
  end
end
