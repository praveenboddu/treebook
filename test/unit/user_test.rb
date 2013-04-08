require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many(:user_friendships)
  should have_many(:friends)

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
  	user.profile_name = users(:paadhyu).profile_name
	#puts user.errors.inspect
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  
    user = User.new(first_name: 'Praveen', last_name: 'Boddu', email: 'paadhyu@gmail.com')
    user.password = user.password_confirmation = 'praveenkumar'
  	user.profile_name = "Praveen Boddu"
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly")
  end

  test "a user can have correctly formatted profile name" do
    user = User.new(first_name: 'Praveen', last_name: 'Boddu', email: 'pbell_1@gmail.com')
    user.password = user.password_confirmation = 'praveenkumar'
    user.profile_name = 'pbell_1'
    assert user.valid?
  end

  test "no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:paadhyu).friends
    end  
  end  

  test "creating friendships on a user works" do
    users(:paadhyu).friends << users(:peter)
    users(:paadhyu).friends.reload
    assert users(:paadhyu).friends.include?(users(:peter))
  end  

  test "creating friendships on a user_id and friend id works" do
    UserFriendship.create user_id: users(:paadhyu).id, friend_id: users(:peter).id
    assert users(:paadhyu).friends.include?(users(:peter))
  end   

  test "that calling to_param on a user returns the profile_name" do
    assert_equal "paadhyu", users(:paadhyu).to_param
  end  
end
