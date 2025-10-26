require 'onload'

module RuxRails
  class Engine < ::Rails::Engine
    isolate_namespace RuxRails

    config.rux = ActiveSupport::OrderedOptions.new

    initializer 'rux-rails.initialize', before: 'onload.initialize' do |app|
      if config.rux.transpile.nil? && (Rails.env.development? || Rails.env.test?)
        config.rux.transpile = true
        Onload.enabled = true
      else
        Onload.enabled = config.rux.transpile
      end

      if config.rux.transpile
        Onload.register('.rux', RuxRails::RuxLoader)
      end

      ActionView::Template.register_template_handler(
        :ruxt, RuxRails::TemplateHandler
      )

      Rux.library_paths.each do |library_path|
        app.config.eager_load_paths << library_path
        app.config.autoload_paths << library_path
      end
    end

    config.after_initialize do
      ignore_path = config.rux.ignore_path || Onload.config.ignore_path

      if ignore_path.nil? && Rails.root.join(".gitignore").exist?
        ignore_path = Rails.root.join(".gitignore").to_s
      end

      Onload.config.ignore_path = ignore_path
      config.rux.ignore_path = ignore_path
    end

    rake_tasks do
      load File.expand_path(File.join(*%w(. tasks transpile.rake)), __dir__)
    end
  end
end
