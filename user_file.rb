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

  def lookup_user_id(matching_value)
    if users.key?(matching_value)  # if the person is known
      return users[matching_value] # specify the existing user_id
    else # an unknown person
      return nil
    end
  end

  def beautify(matching_value)
    return nil if matching_value.nil?
    matching_value = matching_value.downcase.strip
    if !matching_value.include? '@' # no @? assume it's a phone number
      matching_value = matching_value.tr('^0123456789', '')[-10,9]
    end
    matching_value
  end

  def process_rows
    output_array = []
    next_user_id = 0
    matching_columns = []

    file_content = File.open(filename).read
    file_content.each_line do |unparsed_line|
      line = unparsed_line.strip.split(',') # remove extra whitespace, parse csv
      if line[0] == "FirstName" # header row
        # figure out which columns are relevant to our matching
        if %w(email both).include? matching_type
          matching_columns += line.each_index
                                  .select{|i| line[i].include? "Email"}
        end
        if %w(phone both).include? matching_type
          matching_columns += line.each_index
                                  .select{|i| line[i].include? "Phone"}
        end
        output_array.push("UserId,#{unparsed_line}") # for the header row, just add the new column
        next
      end

      # From interesting matching_columns, assemble interesting values
      matching_values = matching_columns.map { |i| beautify(line[i]) }
      user_matches = matching_values.map { |v| lookup_user_id(v) }
                                    .reject(&:nil?)
                                    .uniq

      raise NotImplementedError, "Multiple Match!" if user_matches.length > 1
      if user_matches.length == 1  # unambiguous user match
        user_id = user_matches[0]
      else                         # unknown user
        user_id = next_user_id
        next_user_id += 1
      end
      matching_values.each { |v| users[v] = user_id unless v.nil? }
      output_array.push("#{user_id}," + unparsed_line) # prepend the user_id to the line
    end
    output_array
  end

  def write_output_to_file
    output_filename ="#{filename.split('.')[0]}_#{matching_type}_output.csv"
    IO.write(output_filename, '') # since I'm overwriting files, let's clear them out
    IO.write(output_filename, process_rows.join('')) # this works on my windows machine, but might need .join('\n') for other EOL formats
    output_filename
  end

end
