module RuxRails
  class RuxLoader
    def self.call(source)
      Rux.to_ruby(source)
    end
  end
end
