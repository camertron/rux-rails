require 'rails/railtie'

require 'active_support'
require 'active_support/isolated_execution_state' if ActiveSupport::VERSION::MAJOR > 6

module RuxRails
  class Railtie < Rails::Railtie
    config.rux = ActiveSupport::OrderedOptions.new

    initializer 'rux-rails.initialize', before: :set_autoload_paths do |app|
      ViewComponent::Base.send(:include, RuxRails::Components)

      if config.rux.transpile.nil? && (Rails.env.development? || Rails.env.test?)
        config.rux.transpile = true
      end

      if config.rux.transpile
        require 'onload'

        Onload.register('.rux', RuxRails::RuxLoader)
        Onload.enable!
      end

      ActionView::Template.register_template_handler(
        :ruxt, RuxRails::TemplateHandler
      )

      Rux.library_paths.each do |library_path|
        app.config.eager_load_paths << library_path
        app.config.autoload_paths << library_path
      end

      if config.rux.transpile && app.config.file_watcher
        paths = Set.new(app.config.eager_load_paths + app.config.autoload_paths)

        dirs = paths.each_with_object({}) do |path, ret|
          ret[path] = %w(rux)
        end

        app.reloaders << app.config.file_watcher.new([], dirs) do
          # empty block, watcher seems to need it?
        end
      end
    end

    rake_tasks do
      load File.expand_path(File.join(*%w(. tasks transpile.rake)), __dir__)
    end
  end
end
