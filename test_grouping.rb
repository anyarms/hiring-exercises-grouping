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
  def test_email_grouping_single_column
    userfile = UserFile.new("email", "input1.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 1 2 3 4 5 1 6), output.map { |e| e.split(',')[0] }
  end
  def test_email_grouping_double_column
    userfile = UserFile.new("email", "input2.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 0 1 1 1 2), output.map { |e| e.split(',')[0] }
  end
  def test_phone_grouping_single_column
    userfile = UserFile.new("phone", "input1.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 0 1 2 3 1 4 5), output.map { |e| e.split(',')[0] }
  end
  def test_phone_grouping_double_column
    userfile = UserFile.new("phone", "input2.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 0 0 0 1 2), output.map { |e| e.split(',')[0] }
  end
  def test_both_grouping_single_column
    userfile = UserFile.new("both", "input1.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 0 1 2 3 1 0 4), output.map { |e| e.split(',')[0] }
  end
  def test_both_grouping_with_double_match
    userfile = UserFile.new("both", "input2.csv")
    output = userfile.process_rows
    assert_equal %w(UserId 0 0 0 0 0 1), output.map { |e| e.split(',')[0] }
  end
  def test_both_grouping_with_ambiguous_match
    userfile = UserFile.new("both", "bad_input.csv")
    assert_raises(NotImplementedError) { userfile.process_rows }
  end
end
