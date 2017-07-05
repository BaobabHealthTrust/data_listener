require 'couch_tap'
DIR = File.dirname(__FILE__).to_s + '/bin/couch-mysql.rb'
puts `couch_tap bin/couch-mysql.rb`