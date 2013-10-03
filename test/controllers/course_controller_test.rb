require 'test_helper'

class CourseControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end

end
