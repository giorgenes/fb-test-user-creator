#!/usr/bin/env ruby

require 'json'

if ARGV.size < 2
	puts "$0 <app_id> <access_token>"
	exit 1
end

APPID = ARGV[0]
TOKEN = ARGV[1]


def create_user
	u = %x(curl -F permissions=read_stream -F method=post -F access_token='#{TOKEN}' https://graph.facebook.com/#{APPID}/accounts/test-users)
	JSON::parse(u)
end

def friends_request(u1, u2)
	%x(curl -F access_token='#{u1['access_token']}' -F method=post https://graph.facebook.com/#{u1['id']}/friends/#{u2['id']})
end

def connect_friends(u1, u2)
	friends_request(u1, u2)
	friends_request(u2, u1)
end

log = File.new("fbusers.log", "w")

mainuser = create_user

1.upto(499) do
	u = create_user
	log << u.to_json
	connect_friends(mainuser, u)
end

