module RuxRails
  module BootsnapAutoloadPatch
    def autoload(const, path)
      # Bootsnap monkeypatches Module.autoload in order to leverage its load
      # path cache, which effectively converts a relative path into an absolute
      # one without incurring the cost of searching the load path.
      # Unfortunately, if a .rux file has already been transpiled, the cache
      # seems to always return the corresponding .rb file. Bootsnap's autoload
      # patch passes the .rb file to Ruby's original autoload, effectively
      # wiping out the previous autoload that pointed to the .rux file. To
      # fix this we have to intercept the cache lookup and force autoloading
      # the .rux file if one exists.
      cached_path = Bootsnap::LoadPathCache.load_path_cache.find(path)
      cached_rux_path = "#{cached_path.chomp('.rb')}.rux"

      if File.file?(cached_rux_path)
        autoload_without_bootsnap(const, cached_rux_path)
      else
        super
      end
    end
  end
end

class Module
  prepend RuxRails::BootsnapAutoloadPatch
end
