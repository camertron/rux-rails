require 'zeitwerk'

module RuxRails
  module ZeitwerkLoaderPatch
    private

    def ruby?(path)
      super || path.end_with?('.rux')
    end

    def autoload_file(parent, cname, file)
      if file.end_with?('.rux')
        # Some older versions of Zeitwerk very naïvely try to remove only the
        # last 3 characters in an attempt to strip off the .rb file extension,
        # while newer ones only remove it if it's actually there. This line is
        # necessary to remove the trailing leftover period for older versions,
        # and remove the entire .rux extension for newer versions.
        cname = cname.to_s.chomp('.').chomp('.rux').to_sym
      else
        # if there is a corresponding .rux file, autoload it instead of the .rb
        # file
        rux_file = "#{file.chomp('.rb')}.rux"
        file = rux_file if File.exist?(rux_file)
      end

      super
    end
  end
end

module Zeitwerk
  class Loader
    prepend RuxRails::ZeitwerkLoaderPatch
  end
end
