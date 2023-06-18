#! /usr/bin/env ruby

require "yaml"

$installed_ruby_versions_by_minor = `asdf list ruby`
  .split("\n")
  .map { |v| v.sub("*", "").strip }
  .select { |v| v =~ /\A\d\.\d\.\d\z/ }
  .group_by { |v| v.split(".")[0...2].join(".") }
  .each_with_object({}) do |(minor, versions), memo|
    memo[minor] = versions.sort.last
  end

actions_config = YAML.load_file(".github/workflows/unit_tests.yml")
matrix_config = actions_config.dig('jobs', 'build', 'strategy', 'matrix')
ruby_versions = matrix_config['ruby-version']
rails_versions = matrix_config['rails-version']
excludes = matrix_config['exclude']

exclude_tuples = excludes.map { |e| [e['ruby-version'], e['rails-version']] }

matrix = ruby_versions.flat_map do |ruby_version|
  rails_versions.filter_map do |rails_version|
    tuple = [ruby_version, rails_version]
    exclude_tuples.include?(tuple) ? nil : tuple
  end
end

def run(ruby_version, cmd, env = {}, prefix: '')
  asdf_ruby_version = $installed_ruby_versions_by_minor[ruby_version]
  env["ASDF_RUBY_VERSION"] = asdf_ruby_version
  env_str = env.map { |k, v| "#{k}=#{v}" }.join(" ")
  puts "#{prefix}#{env_str} #{cmd}"
  system(env, cmd)
end

def appraisal(ruby_version, rails_version, cmd, prefix: '')
  run(ruby_version, "bundle exec appraisal rails-#{rails_version} #{cmd}", prefix: prefix)
end

task_count = matrix.size * 2
puts "Running #{task_count} tasks"

results = matrix.map.with_index do |(ruby_version, rails_version), idx|
  run(
    ruby_version,
    "bundle check || bundle install",
    { "BUNDLE_GEMFILE" => "gemfiles/rails_#{rails_version}.gemfile" },
    prefix: "(#{(idx * 2) + 1}/#{task_count}) "
  )

  appraisal(
    ruby_version,
    rails_version,
    "rspec",
    prefix: "(#{(idx * 2) + 2}/#{task_count}) "
  )

  if $?.exitstatus == 0
    "ruby-version=#{ruby_version} rails-version=#{rails_version}: SUCCEEDED"
  else
    "ruby-version=#{ruby_version} rails-version=#{rails_version}: FAILED"
  end
end

puts results.join("\n")
