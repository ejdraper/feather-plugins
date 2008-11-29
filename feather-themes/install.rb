Feather::PluginSetting.write('theme', 'default')
Dir.mkdir(Merb.dir_for(:themes)) if not File.exists?(Merb.dir_for(:themes))