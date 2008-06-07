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

    unless path = ENV['path']
      puts 'Usage: rake feather:package path=<plugin path> [target=<target path>]'
      return
    end

    # Load manifest
    puts "Load manifest..."
    pp manifest = YAML::load_file(File.join(path, 'manifest.yml'))
    
    # Target directory for package files
    target = ENV['target'] ? ENV['target'] : File.join(File.dirname(__FILE__), 'pkg')
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
end