require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: users(:paadhyu).profile_name
    assert_response :success
    assert_template 'profiles/show'
  end

  test "should render 404 if no user exists" do
    get :show, id: "doesnt exist"
    assert_response :not_found
  end 

  test "make sure variables are assigned on successful profile viewing" do
  	get :show, id: users(:paadhyu).profile_name
  	assert assigns(:user)
  	assert_not_empty assigns(:statuses)
  end	

  test "show only the user status" do
  	get :show, id: users(:paadhyu).profile_name
  	assigns(:statuses).each do |status|
  		assert_equal users(:paadhyu), status.user
  	end	
  end
  	

end
