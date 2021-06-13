require 'rails/railtie'

module RuxRails
  class Railtie < Rails::Railtie
    config.rux = ActiveSupport::OrderedOptions.new

    initializer 'rux-rails.initialize', before: :set_autoload_paths do |app|
      if !app.config.respond_to?(:autoloader) || app.config.autoloader == :classic
        require 'rux-rails/core_ext/kernel'
        require 'rux-rails/ext/activesupport/dependencies'

        RuxRails.zeitwerk_mode = false
      else
        require 'rux-rails/core_ext/kernel_zeitwerk'
        require 'rux-rails/ext/zeitwerk/loader'

        RuxRails.zeitwerk_mode = true
      end

      begin
        require 'bootsnap'
      rescue LoadError
      else
        require 'rux-rails/ext/bootsnap/autoload'
      end

      ActionView::Template.register_template_handler(
        :ruxt, RuxRails::TemplateHandler
      )

      if config.rux.transpile.nil? && (Rails.env.development? || Rails.env.test?)
        config.rux.transpile = true
      end

      RuxRails.transpile_on_load = -> () { config.rux.transpile }

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
