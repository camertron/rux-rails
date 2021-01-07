require 'active_support/dependencies'

module RuxRails
  module ActiveSupportDependenciesPatch
    # Allow activesupport to find .rux files.
    def search_for_file(path_suffix)
      path_suffix_with_ext = path_suffix.sub(/(\.rux)?$/, '.rux'.freeze)

      autoload_paths.each do |root|
        path = File.join(root, path_suffix_with_ext)
        return path if File.file?(path)
      end

      super
    end

    # For some reason, using autoload and a patched Kernel#load doesn't work
    # by itself for automatically loading .rux files. Due to what I can only
    # surmise is one of the side-effects of autoload, requiring any .rux file
    # that's been marked by autoload will result in a NameError, i.e. Ruby
    # reports the constant isn't defined. Pretty surprising considering we're
    # literally in the process of _defining_ that constant. The trick is to
    # essentially undo the autoload by removing the constant just before
    # loading the .rux file that defines it.
    def load_missing_constant(from_mod, const_name)
      if require_path = from_mod.autoload?(const_name)
        path = search_for_file(require_path)

        if path && path.end_with?('.rux')
          from_mod.send(:remove_const, const_name)
          require require_path
          return from_mod.const_get(const_name)
        end
      end

      super
    end
  end
end

module ActiveSupport
  module Dependencies
    class << self
      prepend RuxRails::ActiveSupportDependenciesPatch
    end
  end
end
