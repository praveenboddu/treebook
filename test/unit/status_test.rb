require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "status should not be empty" do
  	status = Status.new
  	assert !status.save
  	assert !status.errors[:content].empty?
  end	

  test "status should atleast two characters" do
  	status = Status.new
  	status.content = "B"
  	assert !status.save
  	assert !status.errors[:content].empty?
  end	

  test "status should have user associated" do
  	status = Status.new
  	status.content = "Hello"
  	assert !status.save
  	assert !status.errors[:user_id].empty?
  end	

end
