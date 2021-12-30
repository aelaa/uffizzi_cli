# frozen_string_literal: true

module ApiRoutes
  def session_uri(hostname)
    "#{hostname}/api/cli/v1/session"
  end

  def projects_uri(hostname)
    "#{hostname}/api/cli/v1/projects"
  end

  def compose_files_uri(hostname)
    "#{hostname}/api/cli/v1/compose_files"
  end
end
