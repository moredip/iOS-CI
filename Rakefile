require 'rubygems'
require 'xcodebuild'
require 'cucumber/rake/task'

HERE = File.expand_path( '..',__FILE__ )
ENV['APP_BUNDLE_PATH'] = File.join( HERE, 'ci_artifacts/Frankified.app' )

namespace :xcode do
  XcodeBuild::Tasks::BuildTask.new :debug_simulator do |t|
    t.invoke_from_within = './app'
    t.configuration = "Debug"
    t.sdk = "iphonesimulator"
    t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
  end
end

task :default => ["xcode:debug_simulator:cleanbuild"]

namespace :ci do
  def move_into_artifacts( src )
    FileUtils.mkdir_p( 'ci_artifacts' )
    FileUtils.mv( src, "ci_artifacts/" )
  end

  task :clear_artifacts do
    FileUtils.rm_rf( 'ci_artifacts' )
  end

  task :build => ["xcode:debug_simulator:cleanbuild"] do
    move_into_artifacts( Dir.glob("app/build/Debug-iphonesimulator/*.app") )
  end

  task :frank_build do
    sh '(cd app && frank build)'
    move_into_artifacts( "app/Frank/frankified_build/Frankified.app" )
  end

  Cucumber::Rake::Task.new(:frank_test, 'Run Frank acceptance tests, generating HTML report as a CI artifact') do |t|
    t.cucumber_opts = "app/Frank/features --format pretty --format html --out ci_artifacts/frank_results.html"
  end

  task :travis => ['ci:clear_artifacts','ci:build','ci:frank_build','ci:frank_test']
end

task :ci => ["ci:clear_artifacts","ci:build","ci:frank_build","ci:frank_test"]
