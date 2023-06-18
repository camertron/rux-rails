module RuxRails
  class RuxLoader
    def self.process(source)
      Rux.to_ruby(source)
    end
  end
end
