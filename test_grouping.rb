# Run these tests with > ruby test_input_parsing.rb

require "minitest/autorun"
require "./user_file.rb"

class TestUserFile < Minitest::Test
  def test_initialization
    assert_raises(ArgumentError) { UserFile.new() }
    assert_raises(ArgumentError) { UserFile.new("email") }
    assert_raises(ArgumentError) { UserFile.new("one", "input1.csv") }
    assert_raises(ArgumentError) { UserFile.new("email", "input1") }
    userfile = UserFile.new("email", "input1.csv")
    assert_equal "email", userfile.matching_type
    assert_equal "input1.csv", userfile.filename
  end
  def test_email_grouping
    userfile = UserFile.new("email", "input1.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 1 2 3 4 5 1 6), output.map { |e| e.split(',')[0] }
  end
  def test_phone_grouping
    skip "not yet implemented"
    userfile = UserFile.new("phone", "input1.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 1 2 3 4 2 5 6), output.map { |e| e.split(',')[0] }
  end
  def test_both_grouping
    skip "not yet implemented"
    userfile = UserFile.new("both", "input1.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 1 2 3 4 2 1 5), output.map { |e| e.split(',')[0] }
  end
end
