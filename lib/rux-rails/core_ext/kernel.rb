module RuxRails
  module LoadPatch
    def load(file, *args)
      # ActiveSupport::Dependencies adds an extra .rb to the end
      if file.end_with?('.rux.rb')
        file = file.chomp('.rb')
      end

      if file.end_with?('.rux')
        tmpl = Rux::File.new(file)
        tmpl.write if RuxRails.transpile_on_load?

        return super(tmpl.default_outfile, *args)
      end

      super(file, *args)
    end
  end

  module RequirePatch
    def require(file)
      begin
        # try to require the file as normal
        super(file)
      rescue LoadError => e
        # normal require failed, so check to see if there's a .rux file
        # somewhere on the load path
        path = nil
        rux_file = file.end_with?('.rux') ? file : "#{file}.rux"

        if File.absolute_path(rux_file) == rux_file && File.exist?(rux_file)
          path = rux_file
        elsif rux_file.start_with?(".#{File::SEPARATOR}")
          abs_path = File.expand_path(rux_file)
          path = abs_path if File.exist?(abs_path)
        else
          $LOAD_PATH.each do |lp|
            check_path = File.expand_path(File.join(lp, rux_file))

            if File.exist?(check_path)
              path = check_path
              break
            end
          end
        end

        raise unless path
        return false if $LOADED_FEATURES.include?(path)

        # Must call the Kernel.load class method here because that's the one
        # activesupport doesn't mess with, and in fact the one activesupport
        # itself uses to actually load files. In case you were curious,
        # activesupport redefines Object#load and Object#require i.e. the
        # instance versions that get inherited by all other objects. Yeah,
        # it's pretty awful stuff.
        Kernel.load(path)
        $LOADED_FEATURES << path

        return true
      end
    end
  end
end

module Kernel
  class << self
    prepend RuxRails::LoadPatch
  end
end

class Object
  prepend RuxRails::RequirePatch
end
