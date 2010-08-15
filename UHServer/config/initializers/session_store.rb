# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_UHServer_session',
  :secret      => 'd9c8b93946780325832d041ef69004e96a5d408af14bf53fd2664d63d3b90c692eaf1e297eb43e889f73b246d77294e4ad738f48450a204ed2ee1d56632ed81a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
