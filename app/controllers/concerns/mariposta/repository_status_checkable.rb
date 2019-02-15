module Mariposta
  module RepositoryStatusCheckable
    extend ActiveSupport::Concern

    def check_repository_status
      if current_user
        Mariposta::Repository.setup(ENV['site_repo_path'])

        if Mariposta::Repository.current.changes?
          @alert_bar = render_to_string partial: 'mariposta/shared/repo_notice'
        end

        if current_user.last_activity_at < 10.minutes.ago && Mariposta::Repository.current.needs_pull?
          git_remote = ENV['git_publish_remote'] || 'origin'
          Mariposta::Repository.current.pull(remote: git_remote)
        end
      end
    end
  end
end
