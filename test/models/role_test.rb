require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  
  test "required fields" do
    r = Role.new
    refute r.valid?, "required fields have errors"
    assert_equal [:role], r.errors.keys, "required fields have errors"
  end
  
  test "uniqueness of role" do
    r1 = make_role(true)
    r2 = make_role(true)
    r2.role = r1.role
    refute r2.valid?, "required fields have errors"
    assert_equal [:role], r2.errors.keys, "uniqueness"
  end
  
  test "valid role" do
    r = make_role(true)
    assert r.valid?
  end
  
end
