	require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase

  should belong_to(:user)
  should belong_to(:friend)

  test "creating a friendship works" do 
  	assert_nothing_raised do
  		UserFriendship.create user: users(:paadhyu), friend: users(:peter)
  	end
  end
end
