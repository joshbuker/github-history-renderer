require 'active_support'
require 'active_support/core_ext'

class Renderer
  class << self
    def run
      input = request_input

      if renderable?(input)
        config = request_config
        render(input: input, config: config)
      else
        puts 'The requested string cannot be rendered.'
      end
    end

    def request_input
      puts 'Please enter the text you would like to render:'
      gets.chomp
    end

    def request_config
      options = {}
      puts 'Repo directory path:'
      options[:repo_directory_path] = gets.chomp
      puts 'Start date for input (must be a sunday, e.g. 1970-01-04):'
      options[:start_date] = Date.parse(gets.chomp)
      puts 'Commit author name:'
      options[:author_name] = gets.chomp
      puts 'Commit author email:'
      options[:author_email] = gets.chomp
      puts 'Number of commits (for max intensity):'
      options[:number_of_commits] = gets.chomp.to_i

      Config.new(options: options)
    end

    def renderable?(input)
      return false unless input.is_a?(String) && input.present?
      return false if input.gsub(/[a-zA-Z., !]/, '').length.positive?

      true
    end

    def render(input:, config:)
      buffer = Buffer.new(input: input, config: config)
      buffer.render
    end
  end
end

class Config
  def initialize(options:)
    @repo_directory_path = options[:repo_directory_path]
    @start_date = options[:start_date]
    @author_name = options[:author_name]
    @author_email = options[:author_email]
    @number_of_commits = options[:number_of_commits]

    errors = []

    errors << 'Start date must be a sunday' if @start_date.wday != 0
    errors << 'Invalid author email' unless @author_email =~ URI::MailTo::EMAIL_REGEXP
    errors << 'Invalid number of commits' if @number_of_commits <= 0

    raise ArgumentError, "Config errors:\n#{errors.to_sentence}" if errors.any?
  end
end

class Buffer
  def initialize(input:, config:)
    @lines = []

    input.chars.each do |character|
      @lines << parse(character)
    end
  end

  def parse()
end