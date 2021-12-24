# frozen_string_literal: true

require 'io/console'
require 'uffizzi'
require 'uffizzi/auth_helper'

module Uffizzi
  class CLI::Projects
    include ApiClient

    def run
      return unless Uffizzi::AuthHelper.signed_in?

      hostname = ConfigFile.read_option(:hostname)
      response = fetch_projects(hostname)

      if response[:code] == Net::HTTPOK
        projects = response[:body][:projects]
        if projects.empty?
          puts 'No projects related to this email'
          return
        end
        if projects.size == 1
          ConfigFile.write_option(:project, projects.first[:slug])
        end
        print_projects(projects)
      else
        ApiClient.print_errors(response[:body][:errors])
      end
    end

    private

    def print_projects(projects)
      projects.each do |project|
        puts (project[:slug]).to_s
      end
    end
  end
end
