class UserFile
  attr_accessor :matching_type, :filename, :users

  def initialize(matching_type, filename)
    unless %w(email phone both).include? matching_type
      raise ArgumentError, "Matching_type was #{matching_type}, must be one of: email, phone, both"
    end
    unless filename.split('.').last == "csv" # validate that filename ends in .csv
      raise ArgumentError, "Filename must end in .csv"
    end
    @matching_type = matching_type
    @filename = filename
    @users = {}
  end

  def process_rows
    output_array = []
    next_user_id = 0

    # until they're implemented...
    if %w(phone both).include? matching_type
      raise NotImplementedError, 'Specified matching type is still in progress'
    end

    file_content = File.open(filename).read
    file_content.each_line do |line|
      line.strip!  # remove extra EOL characters
      email = line.split(',')[3]

      # This conditional could use fewer lines, but I find this more readable
      if email == 'Email' # for the header row, just add the new column
        user_id = 'UserId'
      elsif email.nil? # assume each nil email is a different person
        user_id = next_user_id
        next_user_id += 1
      elsif users.key?(email)  # if the person is known
        user_id = users[email] # specify the existing user_id
      else # an unknown person with a non-nil email!
        user_id = users[email.strip.downcase] = next_user_id
        next_user_id += 1
      end
      output_array.push("#{user_id}," + line) # prepend the user_id to the line
    end
    output_array
  end

  def write_output_to_file
    output_filename ="#{filename.split('.')[0]}_#{matching_type}_output.csv"
    IO.write(output_filename, '') # since I'm overwriting files, let's clear them out
    IO.write(output_filename, process_rows.join('\n'))
    output_filename
  end

end
