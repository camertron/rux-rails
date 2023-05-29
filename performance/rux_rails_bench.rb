require 'rux'
require 'benchmark/ips'

puts "Booting Rails..."

require 'rails/all'
require 'slim'
require 'view_component'

# Configure Rails Environment
ENV["RAILS_ENV"] = "production"
require File.expand_path("../spec/dummy/config/application.rb", __dir__)

RuxRails::DummyApplication.initialize!

class BenchmarksController < ActionController::Base
end

BenchmarksController.view_paths = [File.expand_path("./views", __dir__)]
controller_view = BenchmarksController.new.view_context

puts "Transpiling rux components..."

# transpile component files
Dir.glob(File.expand_path('./components/*.rux', __dir__)) do |in_file|
  puts "Transpiling #{in_file}"
  rux_file = Rux::File.new(in_file)
  rux_file.write
end

module Performance
  require_relative 'components/name_component'
  require_relative 'components/nested_name_component'
  require_relative 'components/erb_name_component'
  require_relative 'components/erb_nested_name_component'
  require_relative 'components/slim_name_component'
  require_relative 'components/slim_nested_name_component'
end

Benchmark.ips do |x|
  x.time = 10
  x.warmup = 2

  x.report('rux') do
    controller_view.render(Performance::NameComponent.new(name: "Fox Mulder"))
  end

  x.report('erb') do
    controller_view.render(Performance::ErbNameComponent.new(name: 'Fox Mulder'))
  end

  x.report('slim') do
    controller_view.render(Performance::SlimNameComponent.new(name: 'Fox Mulder'))
  end

  x.report('partial') do
    controller_view.render('partial', name: 'Fox Mulder')
  end

  x.compare!
end
