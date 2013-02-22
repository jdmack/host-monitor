#!/usr/bin/perl

use strict;
use warnings;

use IO::Socket;
use Sys::Hostname;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);

my ($socket, $status);

# [ SERVICE NAME, IP ADDRESS, PORT ]
my @services = (
    ['canis-lupus', 'canis-lupus.wolfbro.com', '22']
);

my $send_email = 0;

for my $i (0 .. $#services) {
    $status .= $services[$i][0] . " is ";
    $socket = IO::Socket::INET->new(PeerAddr => $services[$i][1],
                                    PeerPort => $services[$i][2],
                                    Proto    => 'tcp',
                                    Type     => SOCK_STREAM);

    if($socket) {
        $status .= "UP";
        $send_email = 1;
        close($socket);
    }
    else {
        $status .= "DOWN";
    }
}

print "$status\n";

my $localhost = hostname;
my $user = $ENV{LOGNAME};
my $dest_address = "wolfbro\@gmail.com";

if($send_email) {
    my $message = Email::MIME->create(
        header_str => [
            From    => $user . '@' . $localhost,
            To      => $dest_address,
            Subject => 'Host Status'
        ],
        attributes => {
            encoding => 'quoted-printable',
            charset => 'ISO-8859-1'
        },
        body_str => "$status\n"
    );

    if(sendmail($message)) {
        print "email sent\n";
    }
}
