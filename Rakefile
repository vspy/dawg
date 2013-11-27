require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/extensiontask'

Rake::ExtensionTask.new(:dawg_ext)

RSpec::Core::RakeTask.new(:spec => [:compile])
task :default => :spec
