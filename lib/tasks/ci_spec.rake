# require 'rspec/core/rake_task'
#
# task :ci_spec do
#   RSpec::Core::RakeTask.new(:spec) do |t|
#     t.exclude_pattern = 'spec/**/*ci_spec.rb'
#   end
#   Rake::Task["spec"].execute
# end