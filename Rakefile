require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'
require 'yaml'
require 'pp'

namespace :feather do
  desc "Make plugin package"
  task :package do
    # Grab the path specified, or use all feather-* plugins found
    paths = ENV['path'].nil? ? Dir.glob("feather-*") : [ENV['path']]
    if paths.empty?
      # Show usage if no plugins are found and none is specified
      puts 'Usage: rake feather:package path=<plugin path> [target=<target path>]'
      return
    end
    # Setup default target if none specified, otherwise use that
    target = ENV['target'] ? ENV['target'] : File.join(File.dirname(__FILE__), 'pkg')
    # Loop through paths, packaging each one
    paths.each do |path|
      puts "Packaging... (#{path})"
      package(path, target)
    end
  end
end

##
# This packages the set path, with the specified target path
def package(path, target)
  # Load manifest
  puts "Load manifest..."
  manifest = YAML::load_file(File.join(path, 'manifest.yml'))
  
  # Target directory for package files
  puts "Target is: #{target}"
  Dir.mkdir(target) if not File.exists?(target)
    
  # Package name
  package = "#{manifest['name']}-#{manifest['version']}"
  puts "Package: #{package}"
    
  # Tgz
  manifest['package'] = "#{package}.tgz"
  command = "tar -czf #{package}.tgz --exclude pkg -C #{path} ."
  puts "Packing: #{command}"
  system command
  
  # Move
  puts "Finishing.."
  FileUtils.mv("#{package}.tgz", target)
  File.open(File.join(target, "#{package}.yml"), 'w') do |f|
    f.puts(manifest.to_yaml)
    f.close
  end
    
  puts "Done."
end