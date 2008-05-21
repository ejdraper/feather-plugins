class Theme
  
  attr_accessor :name, :author, :version, :url, :about
  
  attr_reader :path

  def initialize(theme = nil)
    if theme
      @path = File.join(Merb.dir_for(:themes), theme)
      manifest = YAML::load_file(File.join(path, 'manifest.yml'))
      manifest.each_pair do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
  end

  def id
    name
  end
  
  def destroy!
    FileUtils.rm_rf(path)
  end
  
  class << self
    def all
      if File.exists?(Merb.dir_for(:themes))
        # Get every file in themes, remove ".", ".." and regular files and create a Theme object for everything else
        @themes = Dir.open(Merb.dir_for(:themes)).
          reject { |file| ['.', '..'].include?(file) }.
          select { |file| File.directory?(File.join(Merb.dir_for(:themes), file)) }.
          map { |file| Theme.new(file) }
      else
        @themes = []
      end
    end
    
    def get(theme)
      path = File.join(Merb.dir_for(:themes), theme)
      if File.exists?(path)
        return Theme.new(theme)
      else
        raise "Theme not found"
      end
    end
    
    def install(url)
      # Get manifest
      manifest = YAML::load(Net::HTTP.get(URI.parse(url + ".yml")))
      # Target
      path = File.join(Merb.dir_for(:themes), manifest['name'])
      # Clean up
      FileUtils.rm_rf(path)
      Dir.mkdir(path)
      # Download the package and untgz
      require 'zlib'
      require 'stringio'
      require 'archive/tar/minitar'
      package = Net::HTTP.get(URI.parse(url + ".tgz"))
      Archive::Tar::Minitar.unpack(Zlib::GzipReader.new(StringIO.new(package)), path)
      # Grab metadata from manifest
      new(manifest['name'])
    end
  end
  
end