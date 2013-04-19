	require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase

  should belong_to(:user)
  should belong_to(:friend)

  test "creating a friendship works without raising an exception" do 
  	assert_nothing_raised do
  		UserFriendship.create user: users(:rajesh), friend: users(:peter)
  	end
  end

  test "that creating a friendship based on user id and friend id works" do
  	UserFriendship.create user_id: users(:rajesh).id, friend_id: users(:peter).id
  	assert users(:rajesh).pending_friends.include?(users(:peter))
  end	

  context "a new instance" do
  	setup do
  		@user_friendship = UserFriendship.new user: users(:rajesh), friend: users(:peter)
  	end
  	
  	should "have a pending state" do
  		assert_equal 'pending', @user_friendship.state
  	end	
  end	

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:rajesh), friend: users(:peter)

    end

    should "send an email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.send_request_email
      end  
    end 
  end 

  context "#mutual_friendship" do
    setup do
      UserFriendship.request users(:paadhyu), users(:rajesh)
      @friendship1 = users(:paadhyu).user_friendships.where(friend_id: users(:rajesh).id).first
      @friendship2 = users(:rajesh).user_friendships.where(friend_id: users(:paadhyu).id).first

    end   

    should "correctly find the mutual friendship" do
      
      assert_equal @friendship2, @friendship1.mutual_friendship
    end  
  end  

  context "#accept_mutual_friendship!" do
    setup do
      UserFriendship.request users(:paadhyu), users(:rajesh)
    end  

    should "accept mutual friendship" do
      friendship1 = users(:paadhyu).user_friendships.where(friend_id: users(:rajesh).id).first
      friendship2 = users(:rajesh).user_friendships.where(friend_id: users(:paadhyu).id).first

      friendship1.accept_mutual_friendship!
      friendship2.reload
      assert_equal 'accepted', friendship2.state

    end  
  end  

  context "#accept!" do
    setup do
      @user_friendship = UserFriendship.request users(:rajesh), users(:peter)
    end
    
    should "set the state to accepted" do
      @user_friendship.accept!
      assert_equal "accepted", @user_friendship.state
    end   

    should "send an acceptance email" do
        assert_difference 'ActionMailer::Base.deliveries.size', 1 do
          @user_friendship.accept!
        end
    end  

    should "inculde the friend in the list of friends" do
      @user_friendship.accept!
      users(:rajesh).friends.reload
      assert users(:rajesh).friends.include?(users(:peter))
    end 

    should "accept mutual friendship" do
      @user_friendship.accept!
      assert_equal 'accepted', @user_friendship.mutual_friendship.state
    end  
  end 

  context ".request" do
    should "create two user friendships" do
      assert_difference 'UserFriendship.count', 2 do
        UserFriendship.request(users(:rajesh), users(:peter))
      end  
    end  

   should "send a friend request email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        UserFriendship.request(users(:rajesh), users(:peter))
      end  
    end    
  end   

  context "#delete_mutual_friendship!" do
    setup do
      UserFriendship.request users(:paadhyu), users(:rajesh)
      @friendship1 = users(:paadhyu).user_friendships.where(friend_id: users(:rajesh).id).first
      @friendship2 = users(:rajesh).user_friendships.where(friend_id: users(:paadhyu).id).first
    
    end  
    should "delete the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship
      @friendship1.delete_mutual_friendship!
      assert !UserFriendship.exists?(@friendship2.id) 
    end
      
  end 

  context "on destroy" do
    setup do
      UserFriendship.request users(:paadhyu), users(:rajesh)
      @friendship1 = users(:paadhyu).user_friendships.where(friend_id: users(:rajesh).id).first
      @friendship2 = users(:rajesh).user_friendships.where(friend_id: users(:paadhyu).id).first
    
    end 

    should "delete the mutual friendship" do
      @friendship1.destroy
      assert !UserFriendship.exists?(@friendship2.id)
    end  
  end   
end
