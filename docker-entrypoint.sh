#!/bin/bash
set -e

if [ "$1" = 'parse-server' ]; then

    export PARSE_SERVER_DATABASE_URI="${PARSE_SERVER_DATABASE_URI:-mongodb://mongo:27017/parse}"

    if [ -z "${PARSE_SERVER_CLOUD_CODE_MAIN}" ] && [ -f "/cloud/main.js" ]; then
        export PARSE_SERVER_CLOUD_CODE_MAIN="/cloud/main.js"
    fi

fi

exec "$@"