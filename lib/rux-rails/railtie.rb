require 'rails/railtie'

module RuxRails
  class Railtie < Rails::Railtie
    config.rux = ActiveSupport::OrderedOptions.new

    initializer 'rux-rails.initialize', before: :set_autoload_paths do |app|
      if config.rux.compile.nil? && Rails.env.development?
        config.rux.compile = true
      end

      Rux.compile_on_load = -> () { config.rux.compile }

      Rux.library_paths.each do |library_path|
        app.config.eager_load_paths << library_path
        app.config.autoload_paths << library_path
      end

      if config.rux.compile && app.config.file_watcher
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
      load File.expand_path(File.join(*%w(. tasks compile.rake)), __dir__)
    end
  end
end
