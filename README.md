# README

Follow the instructions below on how to setup the application.

* Ruby version 2.2.3

* git clone https://github.com/BaobabHealthTrust/data_listener.git

* navigate into the application folder

* git checkout ebrs

* bundle install

* cp config/couch_mysql.yml.example config/couch_mysql.yml

* Open config/couch_mysql.yml and edit the file to match your couch and MySQL settings

* cp config/db_mapping.yml.example config/db_mapping.yml

* Run the API by running **couch_tap bin/couch-mysql.rb** while in the root directory of the application

