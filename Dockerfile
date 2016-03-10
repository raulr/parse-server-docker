FROM node:argon
MAINTAINER Raul Rodriguez <raul@raulr.net>

ENV PARSE_SERVER_VERSION 2.1.5

RUN npm install -g parse-server@${PARSE_SERVER_VERSION}

# Patch parse-server exacutable to add shebang
RUN grep -q '#!/usr/bin/env node' /usr/local/lib/node_modules/parse-server/bin/parse-server \
    || sed -i '1i#!/usr/bin/env node' /usr/local/lib/node_modules/parse-server/bin/parse-server

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 1337

ENTRYPOINT ["/entrypoint.sh"]
CMD ["parse-server"]