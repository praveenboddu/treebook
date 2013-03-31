require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "testing /login url for login" do
  	get '/login' 
  	assert_response :success
  end

  test "testing /register url for register" do
  	get '/register' 
  	assert_response :success
  end

  test "testing /logout url for logout" do
  	get '/logout' 
  	assert_response :redirect
  	assert_redirected_to '/'
  end  

  # test "testing /edituser url for edituser" do
  # 	get '/edituser' 
  # 	assert_response :redirect
  # 	assert_redirected_to '/edituser'
  # end  
end
