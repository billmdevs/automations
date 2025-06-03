#!/bin/sh
#

#!/bin/bash

# exit if no sessions with my username are found
if ! who | grep -q 'my_username'; then
    exit
fi

sleep 17

coffee_machine_ip='10.10.42.42'
password='1234'

(
    sleep 1
    echo "$password"
    sleep 1
    echo "sys brew"
    sleep 24
    echo "sys pour"
) | telnet $coffee_machine_ip

