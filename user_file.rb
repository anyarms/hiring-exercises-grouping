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

  def process_rows
    output_array = []
    next_user_id = 0

    file_content = File.open(filename).read
    file_content.each_line do |line|
      line.strip! # remove extra whitespace, parse csv
      if line.split(',')[0] == "FirstName" # for the header row, just add the new column
        output_array.push("UserId,#{line}")
        next
      end

      email = line.split(',')[3]
      email = email.strip.downcase unless email.nil?
      phone = line.split(',')[2]
      phone = phone.tr('^0123456789', '')[-10,9] unless phone.nil?

      if matching_type == "email"
        user_id = lookup_user_id(email)
        if user_id.nil?
          user_id = next_user_id
          users[email] = next_user_id unless email.nil?
          next_user_id += 1
        end
      elsif matching_type == "phone"
        user_id = lookup_user_id(phone)
        if user_id.nil?
          user_id = next_user_id
          users[phone] = next_user_id unless phone.nil?
          next_user_id += 1
        end
      elsif matching_type == "both"
        phone_user_id = lookup_user_id(phone)
        email_user_id = lookup_user_id(email)
        if phone_user_id && email_user_id
          raise NotImplementedError, "Double Match! Oh No!"
        elsif phone_user_id
          user_id = phone_user_id
          users[email] = user_id unless email.nil?
        elsif email_user_id
          user_id = email_user_id
          users[phone] = user_id unless phone.nil?
        else # phone_user_id.nil? && email_user_id.nil?
          user_id = next_user_id
          users[phone] = next_user_id unless phone.nil?
          users[email] = next_user_id unless email.nil?
          next_user_id += 1
        end

      else # shouldn't reach this
        raise NotImplementedError, "Specified matching type has not been implemented."
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
