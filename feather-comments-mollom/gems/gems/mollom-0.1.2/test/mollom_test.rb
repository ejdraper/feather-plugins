require 'test/unit'
require 'rubygems'
require 'mocha'

require 'mollom'

class Mollom
  # Unprivate all methods
  public :authentication_hash
  public :server_list
  public :send_command
end

class TestMollom < Test::Unit::TestCase
  def setup
    @mollom = Mollom.new(:private_key => 'xxxxxxxxx', :public_key => 'yyyyyyyyy')
  end
  
  def test_initialize
    assert_equal 'xxxxxxxxx', @mollom.private_key
    assert_equal 'yyyyyyyyy', @mollom.public_key
  end
  
  def test_authentication_hash
    time = mock
    time.expects(:strftime).with('%Y-%m-%dT%H:%M:%S.000+0000').returns('2008-04-01T13:54:26.000+0000')
    Time.stubs(:now).returns(stub(:gmtime => time))
    Kernel.expects(:rand).with(2**31).returns(42)
    hash = @mollom.authentication_hash
    assert_equal("oWN15TqrbLVdTAgcuDmofskaNyM=", hash[:hash])
    assert_equal('yyyyyyyyy', hash[:public_key])
    assert_equal('2008-04-01T13:54:26.000+0000', hash[:time])
    assert_equal(42, hash[:nonce])
  end
  
  def test_server_list
    xml_rpc = mock
    xml_rpc.expects(:call).with('mollom.getServerList', is_a(Hash)).returns(['http://172.16.0.1', 'http://172.16.0.2', 'https://172.16.0.2'])
    XMLRPC::Client.stubs(:new).with('xmlrpc.mollom.com', '/1.0').returns(xml_rpc)
    
    assert_equal [{:ip => '172.16.0.1', :proto => 'http'}, {:ip => '172.16.0.2', :proto => 'http'}, {:ip => '172.16.0.2', :proto => 'https'}], @mollom.server_list
  end
  
  def test_server_list_force_reload
    xml_rpc = mock
    xml_rpc.expects(:call).times(2).with('mollom.getServerList', is_a(Hash)).returns(['http://172.16.0.1', 'http://172.16.0.2', 'https://172.16.0.2'])
    XMLRPC::Client.stubs(:new).with('xmlrpc.mollom.com', '/1.0').returns(xml_rpc)
    
    @mollom.server_list
    @mollom.server_list
    @mollom.server_list(true)
  end
  
  def test_send_command_with_good_server
    Mollom.any_instance.stubs(:server_list).returns([{:ip => '172.16.0.1', :proto => 'http'}])
    xml_rpc = mock
    xml_rpc.expects(:call).with('mollom.testMessage', has_entry(:options => 'foo'))
    XMLRPC::Client.stubs(:new).with('172.16.0.1', '/1.0').returns(xml_rpc)
    
    @mollom.send_command('mollom.testMessage', {:options => 'foo'})
  end
  
  
  def test_send_command_with_bad_server
    Mollom.any_instance.stubs(:server_list).returns([{:ip => '172.16.0.1', :proto => 'http'}, {:ip => '172.16.0.2', :proto => 'http'}])
    xml_rpc = mock
    xml_rpc.expects(:call).with('mollom.testMessage', has_entry(:options => 'foo')).raises(XMLRPC::FaultException.new(1200, "Redirect"))
    xml_rpc2 = mock
    xml_rpc2.expects(:call).with('mollom.testMessage', has_entry(:options => 'foo'))
    
    XMLRPC::Client.stubs(:new).with('172.16.0.1', '/1.0').returns(xml_rpc)
    XMLRPC::Client.stubs(:new).with('172.16.0.2', '/1.0').returns(xml_rpc2)
    @mollom.send_command('mollom.testMessage', {:options => 'foo'})
  end
  
  def test_send_command_with_reload_exception
    # TODO: Test this
    # @mollom.send_command('mollom.testMessage', {:options => 'foo'})
  end
  
  def test_send_command_with_bad_command
    Mollom.any_instance.stubs(:server_list).returns([{:ip => '172.16.0.1', :proto => 'http'}])
    xml_rpc = mock
    xml_rpc.expects(:call).with('mollom.testMessage', has_entry(:options => 'foo')).raises(XMLRPC::FaultException.new(1000, "Fault String"))
    XMLRPC::Client.stubs(:new).with('172.16.0.1', '/1.0').returns(xml_rpc)
    
    assert_raise(Mollom::Error) { @mollom.send_command('mollom.testMessage', {:options => 'foo'}) }
  end
  
  def test_send_command_with_bad_server_and_no_more_available
    Mollom.any_instance.stubs(:server_list).returns([{:ip => '172.16.0.1', :proto => 'http'}])
    xml_rpc = mock
    xml_rpc.expects(:call).with('mollom.testMessage', has_entry(:options => 'foo')).raises(XMLRPC::FaultException.new(1200, "Redirect"))
    
    XMLRPC::Client.stubs(:new).with('172.16.0.1', '/1.0').returns(xml_rpc)
    
    assert_raise(Mollom::NoAvailableServers) { @mollom.send_command('mollom.testMessage', {:options => 'foo'}) }
  end
  
  def test_check_content
    Mollom.any_instance.expects(:send_command).with('mollom.checkContent', :author_ip => '172.16.0.1', :post_body => 'Lorem Ipsum').returns("spam" => 1, "quality" => 0.40, "session_id" => 1)
    cr = @mollom.check_content(:author_ip => '172.16.0.1', :post_body => 'Lorem Ipsum')
    assert cr.ham?
    assert_equal 1, cr.session_id
    assert_equal 0.40, cr.quality
  end
  
  def test_image_captcha
    Mollom.any_instance.expects(:send_command).with('mollom.getImageCaptcha', :author_ip => '172.16.0.1').returns('url' => 'http://xmlrpc1.mollom.com:80/a9616e6b4cd6a81ecdd509fa624d895d.png', 'session_id' => 'a9616e6b4cd6a81ecdd509fa624d895d')
    @mollom.image_captcha(:author_ip => '172.16.0.1')
  end
  
  def test_audio_captcha
    Mollom.any_instance.expects(:send_command).with('mollom.getAudioCaptcha', :author_ip => '172.16.0.1').returns('url' => 'http://xmlrpc1.mollom.com:80/a9616e6b4cd6a81ecdd509fa624d895d.mp3', 'session_id' => 'a9616e6b4cd6a81ecdd509fa624d895d')
    @mollom.audio_captcha(:author_ip => '172.16.0.1')
  end
  
  def test_valid_captcha
    Mollom.any_instance.expects(:send_command).with('mollom.checkCaptcha', :session_id => 'a9616e6b4cd6a81ecdd509fa624d895d', :solution => 'foo').returns(true)
    @mollom.valid_captcha?(:session_id => 'a9616e6b4cd6a81ecdd509fa624d895d', :solution => 'foo')
  end

  def test_key_ok
    Mollom.any_instance.expects(:send_command).with('mollom.verifyKey').returns(true)
    @mollom.key_ok?
  end
  
  def test_statistics
    Mollom.any_instance.expects(:send_command).with('mollom.getStatistics', :type => 'total_accepted').returns(123)
    @mollom.statistics(:type => 'total_accepted')
  end
  
  def test_send_feedback
    Mollom.any_instance.expects(:send_command).with('mollom.sendFeedback', :session_id => 1, :feedback => 'profanity')
    @mollom.send_feedback :session_id => 1, :feedback => 'profanity'
  end
    
end