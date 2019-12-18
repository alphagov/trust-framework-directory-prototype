#!/bin/bash
set -e

bundle check || bundle install

yarn check || yarn install

DEV_DB=`pwd`/db/development.sqlite3
if [ -f "$DEV_DB" ]; then
    echo "$DEV_DB already exists"
else
    bin/rails db:setup
fi

bin/rails db:migrate
bin/rails s
