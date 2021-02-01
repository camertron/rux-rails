require 'rux'
require 'set'

namespace :rux do
  task transpile: :environment do
    config = Rails.application.config
    paths = Set.new(config.autoload_paths + config.eager_load_paths)

    paths.each do |path|
      # Skip library paths. Libraries should ship with all their rux files
      # pre-transpiled.
      next if Rux.library_paths.include?(path)

      Dir.glob(File.join(path, '**/*.rux')).each do |file|
        Rux::File.new(file).write
        puts "Wrote #{file}"
      end
    end
  end
end
