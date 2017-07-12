
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
      update_birth_registration_type_statement = "UPDATE birth_registration_type SET name = '#{name}', updated_at = '#{updated_at}' WHERE birth_registration_type_id = '#{birth_registration_type_id}'"
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
      insert_person_type_statement = "INSERT INTO person_type (person_type_id, name, description) VALUES ('#{person_type_id}', '#{name}', '#{description}')"
      client.query(insert_person_type_statement)

    else
      update_person_type_statement = "UPDATE person_type SET name = '#{name}', description = '#{description}' WHERE person_type_id = '#{person_type_id}'"
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
      insert_person_relationship_type_statement = "INSERT INTO person_relationship_types (person_relationship_type_id, name, description) VALUES ('#{person_relationship_type_id}', '#{name}', '#{description}')"
      client.query(insert_person_relationship_type_statement)

    else
      update_person_relationship_type_statement = "UPDATE person_relationship_types SET name = '#{name}', description = '#{description}' WHERE person_relationship_type_id = '#{person_relationship_type_id}'"
      client.query(update_person_relationship_type_statement)
    end
  end

  #PersonAttributeTypesCouchdb Document Type
  document 'type' => "PersonAttributeTypesCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    person_attribute_type_id = doc.document["person_attribute_type_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_person_attribute_type_record = client.query("SELECT * FROM person_attribute_types WHERE person_attribute_type_id = '#{person_attribute_type_id}' LIMIT 1").each(:as => :hash)
    if mysql_person_attribute_type_record.blank?
      insert_person_attribute_type_statement = "INSERT INTO person_attribute_types (person_attribute_type_id, name, description, created_at, updated_at) VALUES ('#{person_attribute_type_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_person_attribute_type_statement)

    else
      update_person_attribute_type_statement = "UPDATE person_attribute_types SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE person_attribute_type_id = '#{person_attribute_type_id}'"
      client.query(update_person_attribute_type_statement)
    end
  end

  #ModeOfDeliveryCouchdb Document Type
  document 'type' => "ModeOfDeliveryCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    mode_of_delivery_id = doc.document["mode_of_delivery_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_mode_of_delivery_record = client.query("SELECT * FROM mode_of_delivery WHERE mode_of_delivery_id = '#{mode_of_delivery_id}' LIMIT 1").each(:as => :hash)
    if mysql_mode_of_delivery_record.blank?
      insert_mode_of_delivery_statement = "INSERT INTO mode_of_delivery (mode_of_delivery_id, name, description, created_at, updated_at) VALUES ('#{mode_of_delivery_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_mode_of_delivery_statement)

    else
      update_mode_of_delivery_statement = "UPDATE mode_of_delivery SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE mode_of_delivery_id = '#{mode_of_delivery_id}'"
      client.query(update_mode_of_delivery_statement)
    end
  end

  #LocationCouchdb Document Type
  document 'type' => "LocationCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    location_id = doc.document["location_id"]
    name = doc.document["name"]
    name = name.gsub(/\\/, '\&\&').gsub(/'/, "''") #Escaping special characters. Copied from https://stackoverflow.com/questions/11581773/how-to-escape-for-mysql-queries-from-ruby-on-rails
    description = doc.document["description"]
    postal_code = doc.document["postal_code"]
    country = doc.document["country"]
    latitude = doc.document["latitude"]
    longitude = doc.document["longitude"]
    county_district = doc.document["county_district"]
    parent_location = doc.document["parent_location"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]
    uuid = client.query("SELECT UUID() as uuid;").each(:as => :hash).last["uuid"]

    mysql_location_record = client.query("SELECT * FROM location WHERE location_id = '#{location_id}' LIMIT 1").each(:as => :hash)
    if mysql_location_record.blank?
      insert_location_statement = "INSERT INTO location (location_id, name, description, postal_code, country, latitude, longitude, county_district, parent_location, uuid, created_at)
VALUES ('#{location_id}', '#{name}', '#{description}', '#{postal_code}', '#{country}', '#{latitude}', '#{longitude}', '#{county_district}', '#{parent_location}', '#{uuid}', '#{created_at}')"
      client.query(insert_location_statement)

    else
      update_location_statement = "UPDATE location SET name = '#{name}', description = '#{description}', postal_code = '#{postal_code}', 
          country = '#{country}', latitude = '#{latitude}', longitude = '#{longitude}', county_district='#{county_district}',
          parent_location = '#{parent_location}', changed_at = '#{updated_at}' WHERE location_id = '#{location_id}'"
      client.query(update_location_statement)
    end  unless location_id.blank?
  end

  #LocationTagMapCouchdb Document Type
  document 'type' => "LocationTagMapCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    location_id = doc.document["location_id"]
    location_tag_id = doc.document["location_tag_id"]

    mysql_location_tag_map_record = client.query("SELECT * FROM location_tag_map WHERE location_id = '#{location_id}' AND location_tag_id = '#{location_tag_id}' LIMIT 1").each(:as => :hash)
    if mysql_location_tag_map_record.blank?
      insert_location_tag_map_statement = "INSERT INTO location_tag_map (location_id, location_tag_id) VALUES ('#{location_id}', '#{location_tag_id}')"
      client.query(insert_location_tag_map_statement)

    else
      update_location_tag_map_statement = "UPDATE location_tag_map SET location_id = '#{location_id}', location_tag_id = '#{location_tag_id}' WHERE location_id = '#{location_id}' AND location_tag_id = '#{location_tag_id}'"
      client.query(update_location_tag_map_statement)
    end
  end

  #LocationTagCouchdb Document Type
  document 'type' => "LocationTagCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    location_tag_id = doc.document["location_tag_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_location_tag_record = client.query("SELECT * FROM location_tag WHERE location_tag_id = '#{location_tag_id}' LIMIT 1").each(:as => :hash)
    if mysql_location_tag_record.blank?
      insert_location_tag_statement = "INSERT INTO location_tag (location_tag_id, name, description, created_at, updated_at) VALUES ('#{location_tag_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_location_tag_statement)

    else
      update_location_tag_statement = "UPDATE location_tag SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE location_tag_id = '#{location_tag_id}'"
      client.query(update_location_tag_statement)
    end
  end
  
  #LevelOfEducationCouchdb Document Type
  document 'type' => "LevelOfEducationCouchdb" do |doc|
    #doc_id = doc.document["_id"]
    level_of_education_id = doc.document["level_of_education_id"]
    name = doc.document["name"]
    description = doc.document["description"]
    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_level_of_education_record = client.query("SELECT * FROM level_of_education WHERE level_of_education_id = '#{level_of_education_id}' LIMIT 1").each(:as => :hash)
    if mysql_level_of_education_record.blank?
      insert_level_of_education_statement = "INSERT INTO level_of_education (level_of_education_id, name, description, created_at, updated_at) VALUES ('#{level_of_education_id}', '#{name}', '#{description}', '#{created_at}', '#{updated_at}')"
      client.query(insert_level_of_education_statement)

    else
      update_level_of_education_statement = "UPDATE level_of_education SET name = '#{name}', description = '#{description}', updated_at = '#{updated_at}' WHERE level_of_education_id = '#{level_of_education_id}'"
      client.query(update_level_of_education_statement)
    end
  end

  #PersonBirthDetailsCouchdb Document Type
  document 'type' => "PersonBirthDetailsCouchdb" do |doc|
    document_id = doc.document["_id"]
    person_birth_details_id = doc.document["person_birth_details_id"]
    first_name = doc.document["first_name"]
    middle_name = doc.document["middle_name"]
    last_name = doc.document["last_name"]
    gender = doc.document["gender"]
    birthdate = doc.document["gender"]
    birthdate_estimated = doc.document["birthdate_estimated"]
    place_of_birth = doc.document["place_of_birth"]
    birth_location_id = doc.document["birth_location_id"]
    other_birth_location = doc.document["other_birth_location"]
    birth_weight = doc.document["birth_weight"]
    type_of_birth = doc.document["type_of_birth"]
    parents_married_to_each_other = doc.document["parents_married_to_each_other"]
    date_of_marriage = doc.document["date_of_marriage"]
    gestation_at_birth = doc.document["gestation_at_birth"]
    number_of_prenatal_visits = doc.document["number_of_prenatal_visits"]
    month_prenatal_care_started = doc.document["month_prenatal_care_started"]
    mode_of_delivery_id = doc.document["mode_of_delivery_id"]
    number_of_children_born_alive_inclusive = doc.document["number_of_children_born_alive_inclusive"]
    number_of_children_born_still_alive = doc.document["number_of_children_born_still_alive"]
    level_of_education_id = doc.document["level_of_education_id"]
    district_id_number = doc.document["district_id_number"]
    national_serial_number = doc.document["national_serial_number"]
    court_order_attached = doc.document["court_order_attached"]
    acknowledgement_of_receipt_date = doc.document["acknowledgement_of_receipt_date"]
    facility_serial_number = doc.document["facility_serial_number"]
    adoption_court_order = doc.document["adoption_court_order"]
    birth_registration_type_id = doc.document["birth_registration_type_id"]
    
    location_created_at = doc.document["location_created_at"]
    old_district_id_number = doc.document["old_district_id_number"]
    old_national_serial_number = doc.document["old_national_serial_number"]
    nrb_national_id = doc.document["nrb_national_id"]
    patient_national_id = doc.document["patient_national_id"]
    person_home_village_id = doc.document["person_home_village_id"]
    person_current_village_id  = doc.document["person_current_village_id"]
    person_address_one = doc.document["person_address_one"]
    person_address_two = doc.document["person_address_two"]
    mother_first_name = doc.document["mother_first_name"]
    mother_middle_name = doc.document["mother_middle_name"]
    mother_last_name = doc.document["mother_last_name"]
    mother_home_village_id = doc.document["mother_home_village_id"]
    mother_current_village_id = doc.document["mother_current_village_id"]
    mother_address_one  = doc.document["mother_address_one"]
    mother_address_two = doc.document["mother_address_two"]
    father_first_name = doc.document["father_first_name"]
    father_middle_name = doc.document["father_middle_name"]
    father_last_name = doc.document["father_last_name"]
    father_home_village_id = doc.document["father_home_village_id"]
    father_current_village_id = doc.document["father_current_village_id"]
    father_address_one = doc.document["father_address_one"]
    father_address_two = doc.document["father_address_two"]
    informant_first_name = doc.document["informant_first_name"]
    informant_middle_name = doc.document["informant_middle_name"]
    informant_last_name  = doc.document["informant_last_name"]
    informant_relationship = doc.document["informant_relationship"]
    informant_phone_number = doc.document["informant_phone_number"]
    informant_address_one = doc.document["informant_address_one"]
    informant_address_two = doc.document["informant_address_two"]


    updated_at = doc.document["updated_at"].to_date rescue doc.document["updated_at"]
    created_at = doc.document["created_at"].to_date rescue doc.document["created_at"]

    mysql_core_person_record = client.query("SELECT * FROM core_person WHERE document_id = '#{document_id}' LIMIT 1").each(:as => :hash)
    unless mysql_core_person_record.blank?
      person_id = mysql_core_person_record.last["person_id"]

      update_person_birth_details_statement = "UPDATE person_birth_details SET place_of_birth = '#{place_of_birth}',
        birth_location_id = '#{birth_location_id}', other_birth_location = '#{other_birth_location}', birth_weight = '#{birth_weight}', type_of_birth = '#{type_of_birth}',
        parents_married_to_each_other = '#{parents_married_to_each_other}', date_of_marriage = '#{date_of_marriage}', gestation_at_birth = '#{gestation_at_birth}', number_of_prenatal_visits = '#{number_of_prenatal_visits}',
        month_prenatal_care_started = '#{month_prenatal_care_started}', mode_of_delivery_id = '#{mode_of_delivery_id}', number_of_children_born_alive_inclusive = '#{number_of_children_born_alive_inclusive}',
        number_of_children_born_still_alive = '#{number_of_children_born_still_alive}', level_of_education_id = '#{level_of_education_id}', district_id_number = '#{district_id_number}',
        national_serial_number = '#{national_serial_number}', court_order_attached = '#{court_order_attached}', parents_signed = '', acknowledgement_of_receipt_date = '#{acknowledgement_of_receipt_date}',
        facility_serial_number = '#{facility_serial_number}', adoption_court_order = '#{adoption_court_order}', birth_registration_type_id = '#{birth_registration_type_id}',
        location_created_at = '#{location_created_at}', updated_at = '#{updated_at}'
      WHERE person_id = '#{person_id}'"
      #parents_signed field is missing in person_birth_details table
      client.query(update_person_birth_details_statement)
    end
  end

end
