require 'thor'

Dir[File.dirname(__FILE__) + "/presenters/*.rb"].each { |f| require f }

module Terjira

  module Client
    %w[Base Project Issue RapidView Agile Sprint].each do |klass|
      autoload klass, "terjira/client/#{klass.gsub(/(.)([A-Z](?=[a-z]))/,'\1_\2').downcase}"
    end
  end

  class BaseCLI < Thor
    include CommonPresenter
    include IssuePresenter
    include ProjectPresenter
    include BoardPresenter
    include SprintPresenter

    def self.banner(command, namespace = nil, subcommand = false)
      "#{basename} #{subcommand_prefix} #{command.usage}"
    end

    def self.subcommand_prefix
      self.name.gsub(%r{.*::}, '').gsub("CLI", '').gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }
    end

    no_commands do
      def current_username
        Client::Base.username
      end
    end
  end
end