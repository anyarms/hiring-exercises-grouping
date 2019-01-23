require "./user_file.rb"
# Expected input format: > ruby group_records.rb "email" "input1.csv"


# Parse user input, enter control flow
if ARGV.length > 2
  puts "You specified more than two arguments, only first two will be used."
end

userfile = UserFile.new(ARGV[0], ARGV[1]) # Create new UserFile
puts "Running..."
outfile = userfile.write_output_to_file
puts "Output written to #{outfile}"
