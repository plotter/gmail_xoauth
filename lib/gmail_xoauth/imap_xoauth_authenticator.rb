require 'net/imap'
require 'oauth'

module GmailXoauth
  class ImapXoauthAuthenticator
    
    def process(data)
      build_sasl_client_request(@request_url, @oauth_string)
    end
    
  private
    
    # +user+ is an email address: roger@gmail.com
    # +password+ is a hash of oauth parameters, see +build_oauth_string+
    def initialize(user, password)
			if password[:two_legged]
				@request_url = "https://mail.google.com/mail/b/#{user}/imap/?xoauth_requestor_id=#{CGI.escape(user)}";
				password[:xoauth_requestor_id] = user
				@oauth_string = build_2_legged_oauth_string(@request_url, password)
			else
				@request_url = "https://mail.google.com/mail/b/#{user}/imap/";
				@oauth_string = build_oauth_string(@request_url, password)
			end
    end
    
    include OauthString
    
  end
end

Net::IMAP.add_authenticator('XOAUTH', GmailXoauth::ImapXoauthAuthenticator)
