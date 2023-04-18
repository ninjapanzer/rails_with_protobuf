require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"
require "zeitwerk"

$LOAD_PATH.unshift("app/contracts/protos")

class ProtosInflector < ::Zeitwerk::Inflector
  def camelize(basename, abspath)
    if basename =~ /\A(.*)_pb/
      super($1, abspath)
    else
      super
    end
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JurassicPark
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    Rails.autoloaders.each do |autoloader|
      autoloader.inflector = ProtosInflector.new
      # autoloader.inflector.inflect("_pb.rb" => "")
      # autoloader.inflector.inflect(:class_name => Proc.new { |class_name|
      #   class_name.gsub(/Pb\z/, '').underscore
      # })
      proto_dir_dir = Rails.root.join("app/contracts")
      autoloader.collapse(proto_dir_dir)
    end

    Rails.autoloaders.main do |autoloader|
      # autoloader.ignore(Rails.root.join('app/contracts')) # Ignores files that might not fall into standard
      autoloader.push_dir(Rails.root.join('app/contracts'))

      # proto_messages_dir = Rails.root.join("app/contracts/protos")
      # autoloader.collapse(Rails.root.join('app/contracts'))
    end

    # proto_autoloader = Zeitwerk::Loader.new
    # proto_autoloader.tap do |autoloader|
    #   autoloader.ignore(Rails.root.join('app/contracts')) # Ignores files that might not fall into standard
    #   autoloader.push_dir(Rails.root.join('app/contracts'))
    #   autoloader.inflector = ProtosInflector.new
    #   autoloader.setup
    # end

    # try https://blog.arkency.com/zeitwerk-based-autoload-and-workarounds-for-single-file-many-classes/

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
