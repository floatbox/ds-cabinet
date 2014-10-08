#!/usr/bin/env ruby

# The problem: responds bodies for some requests are serialized
# as BINARY strings and that is the reason why they appear cryptic
# in a cassette file.
#
# That script loads a cassette file and sets responds bodies encoding
# to 'UTF-8' which makes them readable.

require 'yaml'

# load a cassette file
file = ARGV[1] || 'features/vcr_cassettes/7441111111-306770000348481.yml'
hash = YAML.load_file file

# process it
arr  = hash['http_interactions']
arr.each do |h|
  r = h['response']
  r['body']['string'].force_encoding 'UTF-8'
end

# save back
File.open(file, 'w') do |f|
  f.write hash.to_yaml
end
