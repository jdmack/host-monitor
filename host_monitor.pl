#!/usr/bin/perl

use strict;
use warnings;

use IO::Socket;

my ($socket, $status);

# [ SERVICE NAME, IP ADDRESS, PORT ]
my @services = (
    ['canis-lupus', 'canis-lupus.wolfbro.com', '22']
);

for my $i (0 .. $#services) {
    $status .= $services[$i][0] . " is ";
    $socket = IO::Socket::INET->new(PeerAddr => $services[$i][1],
                                    PeerPort => $services[$i][2],
                                    Proto    => 'tcp',
                                    Type     => SOCK_STREAM);

    if($socket) {
        $status .= "UP";
        close($socket);
    }
    else {
        $status .= "DOWN";
    }
}

print $status;

