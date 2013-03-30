require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "a user should enter his first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end	


  test "a user should enter his last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end	

  test "a user must enter his profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end	

  test "a user must have unique profile name" do
  	user = User.new
  	user.profile_name = users(:peter).profile_name
	#puts user.errors.inspect
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  
  	user = User.new
  	user.profile_name = "Praveen Boddu"
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly")
  end
end
