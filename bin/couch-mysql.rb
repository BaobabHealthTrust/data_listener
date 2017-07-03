require 'couch_tap'
require "yaml"
DIR = File.dirname(__FILE__)

#DIR = File.dirname(__FILE__)
#require DIR + '/../config/environment' for loading rails environment

couch_mysql_path = DIR.to_s + "/config/couch_mysql.yml"
db_settings = YAML.load_file(couch_mysql_path)
couch_db_settings = db_settings["couchdb"]
couch_username = couch_db_settings["username"]
couch_password = couch_db_settings["password"]
couch_host = couch_db_settings["host"]
couch_db = couch_db_settings["database"]
couch_port = couch_db_settings["port"]

mysql_db_settings = db_settings["mysql"]
mysql_username = mysql_db_settings["username"]
mysql_password = mysql_db_settings["password"]
mysql_host = mysql_db_settings["host"]
mysql_db = mysql_db_settings["database"]
mysql_port = mysql_db_settings["port"]
mysql_adapter = mysql_db_settings["adapter"]

#reading db_mapping
db_map_path = DIR.to_s + "/config/db_mapping.yml"
db_maps = YAML.load_file(db_map_path)

changes "http://#{couch_username}:#{couch_password}@#{couch_host}:#{couch_port}/#{couch_db}" do
  # Which database should we connect to?
  database "#{mysql_adapter}://#{mysql_username}:#{mysql_password}@#{mysql_host}:#{mysql_port}/#{mysql_db}"

  	 map_keys = db_maps.keys

  	 map_keys.each do |map|

  	 	  map_parts = map.split("|")
  	 	  document_type = map_parts [0]
  	 	  db_table = map_parts[1]

  	 	  couch_db_fields = db_maps[map].keys

		  document 'type' => document_type do

			    eval("table :#{db_table}") do
			    	
			    	couch_db_fields.each do |field|
			    		eval("column :#{field},#{db_maps[map][field]}")
			    	end
			    end
		  end
	 end

end
