require 'couch_tap'

changes "http://mangochiman:mangochiman@localhost:5984/ebrs_hq" do
  # Which database should we connect to?
  database "mysql2://root:ernest@localhost:3306/bart2_new"
	  document 'type' => 'User' do
	    table :user
	  end

end
