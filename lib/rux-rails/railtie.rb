require 'rails/railtie'

module RuxRails
  class Railtie < Rails::Railtie
    initializer 'rux-rails.initialize' do
    end

    rake_tasks do
      load File.expand_path(File.join(*%w(. tasks compile.rake)), __dir__)
    end
  end
end
