require 'zeitwerk'

module RuxRails
  module ZeitwerkLoaderPatch
    private

    def ruby?(path)
      super || path.end_with?('.rux')
    end

    def autoload_file(parent, cname, file)
      if file.end_with?('.rux')
        # Zeitwerk very naïvely tries to remove only the last 3 characters in
        # an attempt to strip off the .rb file extension, which it assumes all
        # autoloadable files will contain. This line is necessary to remove the
        # trailing leftover period.
        cname = cname.to_s.chomp('.').to_sym
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
