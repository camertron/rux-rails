require 'rux'
require 'set'

namespace :rux do
  task transpile: :environment do
    ignore_file = if Rails.application.config.rux.ignore_path
      Onload::IgnoreFile.load(Rails.application.config.rux.ignore_path)
    end

    Dir.glob(Rails.root.join('**/*.rux')) do |file|
      rux_file = Rux::File.new(file)
      rux_file.write

      puts "Wrote #{rux_file.default_outfile}"

      ignore_file&.add(rux_file.default_outfile)
    end

    ignore_file&.persist!
  end
end
