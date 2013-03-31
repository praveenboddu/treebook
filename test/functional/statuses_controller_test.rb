require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should be routed to signin page if not signed in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render new page when signed in" do
    sign_in users(:paadhyu)
    get :new
    assert_response :success
  end
  
  test "should be logged in to post a status" do
      post :create, status: { content: "Hello" }
      assert_response :redirect
      assert_redirected_to new_user_session_path
  end    

  test "should create status when logged in" do
    sign_in users(:paadhyu)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create status for the current user when logged in" do
    sign_in users(:paadhyu)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:rajesh).id}
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:paadhyu).id
  end


  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should be logged in to edit a status" do
      get :edit, id: @status
      assert_response :redirect
      assert_redirected_to new_user_session_path
  end 

  test "should get edit when signed in" do
    sign_in users(:paadhyu)
    get :edit, id: @status
    assert_response :success
  end

  test "should be logged in to update a status" do
      put :update, id: @status, status: { content: "Hello World!"}
      assert_response :redirect
      assert_redirected_to new_user_session_path
  end 

  test "should update status when logged in" do
    sign_in users(:paadhyu)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update status only for the current user when logged in" do
    sign_in users(:paadhyu)
    put :update, id: @status, status: { content: @status.content, user_id: users(:rajesh).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:paadhyu).id
  end  

  test "should update status only when the status has changed" do
    sign_in users(:paadhyu)
    put :update, id: @status
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:paadhyu).id
  end    

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
