module RuxRails
  class << self
    attr_accessor :zeitwerk_mode

    alias_method :zeitwerk_mode?, :zeitwerk_mode
  end
end

begin
  require 'zeitwerk'
rescue LoadError
  require 'rux-rails/core_ext/kernel'
  require 'rux-rails/ext/activesupport/dependencies'

  RuxRails.zeitwerk_mode = false
else
  require 'rux-rails/core_ext/kernel_zeitwerk'
  require 'rux-rails/ext/zeitwerk/loader'

  RuxRails.zeitwerk_mode = true
end

require 'rux-rails/railtie'
