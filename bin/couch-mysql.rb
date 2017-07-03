require 'couch_tap'

changes "http://user:pass@host:port/database" do
  # Which database should we connect to?
  database "adapter://user:pass@host:port/test_database"
	  document 'type' => 'User' do
	    table :user
	  end

end