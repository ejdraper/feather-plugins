require "test/unit"

require "mollom"

class TestContentResponse < Test::Unit::TestCase
  def test_spam
    cr = Mollom::ContentResponse.new('spam' => 3, 'session_id' => '1', 'quality' => '10')
    assert cr.spam?
    assert !cr.ham?
    assert_equal 'spam', cr.to_s
  end
  
  def test_ham
    cr = Mollom::ContentResponse.new('spam' => 1, 'session_id' => '1', 'quality' => '10')
    assert cr.ham?
    assert !cr.spam?
    assert_equal 'ham', cr.to_s
  end
  
  def test_unknown
    cr = Mollom::ContentResponse.new('spam' => 0, 'session_id' => '1', 'quality' => '10')
    assert cr.unknown?
    assert !cr.unsure?
    assert_equal 'unknown', cr.to_s
  end
  
  def test_unsure
    cr = Mollom::ContentResponse.new('spam' => 2, 'session_id' => '1', 'quality' => '10')
    assert cr.unsure?
    assert !cr.unknown?
    assert_equal 'unsure', cr.to_s
  end
end