use warnings;
use strict;

use LWP::UserAgent;
use HTTP::Request::Common;
use JSON::Parse 'parse_json';

our $client_id = "CLIENT_ID";
our $client_secret = "CLIENT_SECRET";
our $refresh_token = "REFRESH_TOKEN";

sub get_access_token {
	my $ua = LWP::UserAgent -> new;
	my $post = HTTP::Request -> new(POST => 'https://www.googleapis.com/oauth2/v4/token');
	my $auth = encode_base64("$client_id:$client_secret");
	$post -> header('Content-type' => 'application/x-www-form-urlencoded');
	$post -> content("client_id=$client_id&client_secret=$client_secret&refresh_token=$refresh_token&grant_type=refresh_token");
	my $resp = $ua -> request($post);
	my $content = parse_json($resp->decoded_content);
	if ($resp->code ne '200') {
		print ('Error refreshing token');
		return 0;
	} else {
		return ($content->{'access_token'});
	}

}

sub unsuspend {
	my ($token, $user) = @_;
	my $ua = LWP::UserAgent -> new;
	my $put = HTTP::Request -> new(PUT => "https://www.googleapis.com/admin/directory/v1/users/$user");
	$put -> header('Authorization' => "Bearer $token", 'Accept' => 'application/json:charset=UTF-8');
	$put -> content('{"suspended" : false}');
	my $resp = $ua -> request($put);
	my $content = parse_json($resp->decoded_content);
	if ($resp->code ne '200') {
		print ('Error updating user');
		return 0;
	} else {
		return $content->{'suspended'};
	}
}

sub suspend {
	my ($token, $user) = @_;
	my $ua = LWP::UserAgent -> new;
	my $put = HTTP::Request -> new(PUT => "https://www.googleapis.com/admin/directory/v1/users/$user");
	$put -> header('Authorization' => "Bearer $token", 'Accept' => 'application/json:charset=UTF-8');
	$put -> content('{"suspended" : true}');
	my $resp = $ua -> request($put);
	my $content = parse_json($resp->decoded_content);
	if ($resp->code ne '200') {
		print ('Error updating user');
		return 0;
	} else {
		return $content->{'suspended'};
	}
}


