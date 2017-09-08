require 'git'

class Mariposta::Repository
  class << self
    attr_accessor :current
  end

  attr_accessor :repo_dir, :git

  def self.setup(repo_dir)
    self.current ||= new(repo_dir)
  end

  def initialize(repo_dir)
    @repo_dir = repo_dir
    @git = Git.open(@repo_dir)
  end

  def changes?
    git_diff = @git.lib.diff_index('HEAD').values
    if git_diff.present?
      return true unless git_diff.length == 1 && git_diff.first[:path] == "Procfile"
    end

    false

# THIS CODE IS TOO SLOW! keeping for future reference
#
#    changed_files = @git.status.changed

    # don't include small changes to _site only, such as feed.xml, etc.
#    changed = changed_files.length - changed_files.keys.select{|item| item.include?('_site/')}.length

#    added = @git.status.added.length
#    deleted = @git.status.deleted.length

#    (changed + added + deleted) > 0
  end

  def add(filepath)
    @git.add(filepath)
  end

  def pull
    @git.pull
  end

  def commit(message:)
    @git.commit(message)
  end

  def push(remote: nil)
    if remote
      @git.push @git.remote(remote)
    else
      @git.push
    end
  end

end
