require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "required fields" do
    u = User.new
    refute u.valid?, "required fields have errors"
    assert_equal [:password, :email], u.errors.keys, "required fields have errors"
  end
  
  test "required fields - missing email" do
    u = User.new
    u.password = random_string 25
    refute u.valid?, "required fields have errors"
    assert_equal [:email], u.errors.keys, "required fields have errors"
  end

  test "required fields - missing password" do
    u = User.new
    u.email = "#{random_string 25}@example.com".downcase
    refute u.valid?, "required fields have errors"
    assert_equal [:password], u.errors.keys, "required fields have errors"
  end
  
  test "uniqueness of email" do
    u1 = make_user(true)
    u2 = make_user(true)
    u2.email = u1.email
    refute u2.valid?, "required fields have errors"
    assert_equal [:email], u2.errors.keys, "uniqueness"
  end
  
  test "valid user" do
    u = make_user(true)
    assert u.valid?
  end
  
end
