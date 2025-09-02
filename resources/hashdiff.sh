#!/bin/bash

if diff <(md5sum $1 | cut -f1 -d " ") <(md5sum $2 | cut -f1 -d " ") > /dev/null
then echo "Hashes are different!"
else echo "Hashes are identical!"
fi
