require 'rux'
require 'set'

namespace :rux do
  task transpile: :environment do
    config = Rails.application.config
    paths = Set.new(config.autoload_paths + config.eager_load_paths)

    paths.each do |path|
      Dir.glob(File.join(path, '**/*.rux')).each do |file|
        Rux::Template.new(file).write
        puts "Transpiled #{file}"
      end
    end
  end
end
