require 'fileutils'

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
  
  def destroy
    remove_assets
    FileUtils.rm_rf(path)
  end
  
  def each_asset_path(&proc)
    [:stylesheet => "stylesheets", :image => "images", :javascript => "javascripts"].each_pair do |k, v|
      source = File.join(path, 'assets', v)
      target = File.join(Merb.dir_for(k), manifest['name'])
      proc.call(source, target)
    end
  end
  
  def install_assets
    each_asset_path do |source, target|
      FileUtils.mkdir_p(target)
      File.mv(Dir.glob(File.join(source, '*')), target)
    end
  end
  
  def remove_assets
    each_asset_path do |source, target|
      FileUtils.rm_rf(target)
    end
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
    
    def install(manifest_url)

      # Oh, that url seems to give us a manifest file
      # Let's get it
      manifest = YAML::load(Net::HTTP.get(URI.parse(manifest_url)))

      # This is the plugin installation path
      install_path = File.join(Merb.dir_for(:themes), manifest['name'])

      # Remove older versions of the plugin
      # FIXME: Uninstall/Upgrade
      FileUtils.rm_rf(install_path)
      Dir.mkdir(install_path)
      
      # The manifest file gives us the package location
      # If it's not a full url, use the manifest's URI
      package_url = begin 
        uri = URI.parse(manifest['package'])
        if uri.scheme.nil? and uri.host.nil?
          File.join(File.dirname(manifest_url), manifest['package'])
        else
          manifest['package']  
        end
      end

      # Download the package and untgz
      package = Net::HTTP.get(package_url)
      Archive::Tar::Minitar.unpack(Zlib::GzipReader.new(StringIO.new(package)), install_path)  
      
      # Grab metadata from manifest
      object = new(manifest['name'])
      object.install_assets
      object

    end
    
  end
  
end