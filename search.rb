require 'json'

$user_hashes = JSON.parse(File.read('users.json'))
$ticket_hashes = JSON.parse(File.read('tickets.json'))
$organization_hashes = JSON.parse(File.read('organizations.json'))

def search_for_hash(hashes, key, value)
  hashes.select do |hash|
    # This prevents us from type checking for integers.
    hash[key].to_s == value
  end
end


def organization_name(id)
  return if id.empty?

  organization = search_for_hash($organization_hashes, '_id', id).first
  organization['name']
end

def get_user_tickets(submitter_id)
  tickets = search_for_hash($ticket_hashes, 'submitter_id', submitter_id)
end

def print_user_hashes(hashes)
  hashes.each do |hash|
    puts "\n"

    printf("%-20s %s\n", 'Field', 'Value')
    puts '--------------------------'

    hash.each do |key, val|
      printf("%-20s %s\n", key, val)
    end

    organization_id = hash['organization_id'].to_s
    printf("%-20s %s\n", 'organization_name', organization_name(organization_id))

    tickets = get_user_tickets(hash['_id'].to_s)

    tickets.each_with_index do |ticket, n|
      printf("%-20s %s\n", "ticket_#{n}", ticket['subject'])
    end
  end
end

def find_users
  display_fields($user_hashes)

  puts "Enter index of field to search by"
  key_index = gets.to_i

  puts "Enter value of field"
  value = gets.chomp


  keys = $user_hashes.first.keys
  key = keys[key_index]

  user_hashes = search_for_hash($user_hashes, key, value)

  if user_hashes.empty?
    puts "No results found for User with #{key}: #{value}"
  else
    print_user_hashes(user_hashes)
  end
end

def print_hashes(hashes)
  hashes.each do |hash|
    puts "\n"

    printf("%-20s %s\n", 'Field', 'Value')
    puts '--------------------------'

    hash.each do |key, val|
      printf("%-20s %s\n", key, val)
    end
  end
end

def find_other(hash)
  display_fields(hash)

  puts "Enter index of field to search by"
  key_index = gets.to_i

  puts "Enter value of field"
  value = gets.chomp

  keys = hash.first.keys
  key = keys[key_index]

  hashes = search_for_hash(hash, key, value)

  if hashes.empty?
    puts "No results found for #{key}: #{value}"
  else
    print_hashes(hashes)
  end
end

def display_fields(hashes)
  puts "Search Fields"
  puts "Index: Field"

  hashes.first.keys.each_with_index do |field, index|
    printf("%-6s %s\n", index, field)
  end

  puts "**********************"
end

def search
  puts "Enter 1 for Users, 2 for Tickets, 3 for Organizations"

  input = gets.chomp

  if input == '1'
    find_users
  elsif input == '2'
    find_other($ticket_hashes)
  elsif input == '3'
    find_other($organization_hashes)
  end
end

if __FILE__ == $0
  puts 'Welcome to Zendesk Search'

  input = nil

  while input != 'quit'
    puts "\n"
    puts "\tSelect search options:"
    puts "\t * Press 1 to search Zendesk"
    puts "\t * Type 'quit' to exit\n"

    input = gets.chomp

    search if input == '1'
  end

  puts "Quitting Search."
end
