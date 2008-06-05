require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "..", "..", "feather-comments", "models", "comment")
require File.join(File.dirname(__FILE__), "..", "..", "models", "comment")


describe "Comment" do
  it "should know if content is spam" do
    @mollom = Mollom.new(:private_key => 'xxxxxxxxx', :public_key => 'yyyyyyyyy')
    @mollom.should_receive(:send_command).with('mollom.checkContent', {:author_name=>"This is a comment", :post_body=>"I am spam"}).and_return("spam" => 3, "quality" => 0.40, "session_id" => 1)
    Comment.mollom = @mollom
    
    comment = Comment.new
    comment.name = "This is a comment"
    comment.comment = "I am spam"
    comment.spam?.should be_true
  end
  
  it "should not be spam if the comment is empty or nil" do    
    comment = Comment.new
    comment.name = "This is a comment"
    comment.spam?.should be_false
  
    comment.comment = ""
    comment.spam?.should be_false
  end
  
end
