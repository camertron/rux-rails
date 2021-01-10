module RuxRails
  class DummyApplication < ::Rails::Application
    if config.respond_to?(:load_defaults)
      config.load_defaults(
        Gem.loaded_specs['rails'].version.to_s.split('.')[0..1].join('.')
      )
    end

    config.eager_load = false
  end
end
