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

# Because protofiles are born unware of their folder structure we need
# to make sure the generated files are in the loadpath
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

    # Setup our own inflector for the proto files
    Rails.autoloaders.each do |autoloader|
      autoloader.inflector = ProtosInflector.new
      proto_dir_dir = Rails.root.join("app/contracts")
      autoloader.collapse(proto_dir_dir)
    end

    # Add the contracts dir to zeitwerk autoloading
    Rails.autoloaders.main do |autoloader|
      autoloader.push_dir(Rails.root.join('app/contracts'))
    end

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
