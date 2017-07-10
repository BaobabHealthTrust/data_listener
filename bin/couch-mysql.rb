
require 'couch_tap'
require "yaml"
require 'mysql2'

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

client = Mysql2::Client.new(:host => mysql_host,
  :username => mysql_username,
  :password => mysql_password,
  :database => mysql_db
)

changes "http://#{couch_username}:#{couch_password}@#{couch_host}:#{couch_port}/#{couch_db}" do
  # Which database should we connect to?
  database "#{mysql_adapter}://#{mysql_username}:#{mysql_password}@#{mysql_host}:#{mysql_port}/#{mysql_db}"
  #StatusCouchdb Document Type
  document 'type' => "StatusCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    status_id = doc.document["status_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_status_record = client.query("SELECT * FROM statuses WHERE status_id = '#{status_id}' LIMIT 1").each(:as => :hash)
    if mysql_status_record.blank?
      insert_status_statement = "INSERT INTO statuses (status_id, name, description, created_at, updated_at) VALUES ('#{status_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_status_statement)
      
    else
      update_status_statement = "UPDATE statuses SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE status_id = '#{status_id}'"
      client.query(update_status_statement)
    end
  end

  #BirthRegistrationTypeCouchdb Document Type
  document 'type' => "BirthRegistrationTypeCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    birth_registration_type_id = doc.document["birth_registration_type_id"]
    name = doc.document["name"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_birth_registration_type_record = client.query("SELECT * FROM birth_registration_type WHERE birth_registration_type_id = '#{birth_registration_type_id}' LIMIT 1").each(:as => :hash)

    if mysql_birth_registration_type_record.blank?
      insert_birth_registration_type_statement = "INSERT INTO birth_registration_type (birth_registration_type_id, name, created_at, updated_at) VALUES ('#{birth_registration_type_id}', '#{name}', '#{created_at}', '#{updated_at}')"
      client.query(insert_birth_registration_type_statement)
    else
      update_birth_registration_type_statement = "UPDATE birth_registration_type SET name = '#{name}', updated_at = #{updated_at} WHERE birth_registration_type_id = '#{birth_registration_type_id}'"
      client.query(update_birth_registration_type_statement)
    end
  end

  #PersonTypeOfBirthsCouchdb Document Type
  document 'type' => "PersonTypeOfBirthsCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    person_type_of_birth_id = doc.document["person_type_of_birth_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_person_type_of_birth_record = client.query("SELECT * FROM person_type_of_births WHERE person_type_of_birth_id = '#{person_type_of_birth_id}' LIMIT 1").each(:as => :hash)
    if mysql_person_type_of_birth_record.blank?
      insert_person_type_of_birth_statement = "INSERT INTO person_type_of_births (person_type_of_birth_id, name, description, created_at, updated_at) VALUES ('#{person_type_of_birth_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_person_type_of_birth_statement)

    else
      update_person_type_of_birth_statement = "UPDATE person_type_of_births SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE person_type_of_birth_id = '#{person_type_of_birth_id}'"
      client.query(update_person_type_of_birth_statement)
    end
  end

  #PersonTypeCouchdb Document Type
  document 'type' => "PersonTypeCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    person_type_id = doc.document["person_type_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_person_type_record = client.query("SELECT * FROM person_type WHERE person_type_id = '#{person_type_id}' LIMIT 1").each(:as => :hash)
    if mysql_person_type_record.blank?
      insert_person_type_statement = "INSERT INTO person_type (person_type_id, name, description, created_at, updated_at) VALUES ('#{person_type_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_person_type_statement)

    else
      update_person_type_statement = "UPDATE person_type SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE person_type_id = '#{person_type_id}'"
      client.query(update_person_type_statement)
    end
  end

  #PersonRelationshipTypesCouchdb Document Type
  document 'type' => "PersonRelationshipTypesCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    person_relationship_type_id = doc.document["person_relationship_type_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_person_relationship_type_record = client.query("SELECT * FROM person_relationship_types WHERE person_relationship_type_id = '#{person_relationship_type_id}' LIMIT 1").each(:as => :hash)
    if mysql_person_relationship_type_record.blank?
      insert_person_relationship_type_statement = "INSERT INTO person_relationship_types (person_relationship_type_id, name, description, created_at, updated_at) VALUES ('#{person_relationship_type_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_person_relationship_type_statement)

    else
      update_person_relationship_type_statement = "UPDATE person_relationship_types SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE person_relationship_type_id = '#{person_relationship_type_id}'"
      client.query(update_person_relationship_type_statement)
    end
  end

end
