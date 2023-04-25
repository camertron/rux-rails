require 'zeitwerk'

module Kernel
  alias_method :rux_orig_require, :require
  alias_method :rux_orig_load, :load

  def load(file, *args)
    if File.extname(file) == '.rux'
      tmpl = Rux::File.new(file)
      tmpl.write if RuxRails.transpile_on_load?

      # I don't understand why, but it's necessary to delete the constant
      # in order to load the .ruxc file. Otherwise you get an error about
      # an uninitialized constant, and it's like... yeah, I _know_ it's
      # uninitialized, that's why I'm loading this file. Whatevs.
      loader = Zeitwerk::Registry.loader_for(file)
      parent, cname = loader.send(:autoloads)[file]
      parent.send(:remove_const, cname)

      return rux_orig_load(tmpl.default_outfile, *args)
    end

    rux_orig_load(file, *args)
  end

  def require(file)
    path = nil
    loader = Zeitwerk::Registry.loader_for(file)
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

    unless path
      # This will be either Ruby's original require or bootsnap's monkeypatched
      # require in setups that use bootsnap. Lord help us with all these layers
      # of patches.
      return rux_orig_require(file)
    end

    return false if $LOADED_FEATURES.include?(path)

    load path
    $LOADED_FEATURES << path

    loader.on_file_autoloaded(path) if loader

    return true
  end
end
