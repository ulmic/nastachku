require 'test_helper'

class Web::UsersControllerTest < ActionController::TestCase
  setup do
    create :user
  end

  test "should get index" do
    get :index

    assert_response :success
  end

   test "should get index json" do
    get :index, format: :json

    assert_response :success
  end

end
