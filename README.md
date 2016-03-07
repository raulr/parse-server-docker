
### What is Parse Server?

> The open source Parse Server makes it possible to serve the Parse API from any infrastructure that can host Node.js applications. Parse Server provides a way for you to keep your application running without major changes in the client-side code, once you have your data in your own database. Our client SDKs now support changing the API server location to direct them to your own. This also lets you use the Parse client SDKs with entirely new applications that have no dependency on the Parse hosted services.

> &mdash; <cite>[Parse.com Blog](http://blog.parse.com/announcements/introducing-parse-server-and-the-database-migration-tool/)</cite>

### How to Use This Image

Parse Server depends on MongoDB, so first you need to launch a mongo instance:

    $ docker run --name some-mongo -d mongo:3.0 --setParameter failIndexKeyTooLong=false

Then you can launch the Parse Server container:

    $ docker run --link some-mongo:mongo -e PARSE_SERVER_APPLICATION_ID=myAppId -e PARSE_SERVER_MASTER_KEY=mySecretMasterKey -p 1337:1337 -d raulr/parse-server

#### Cloud Code

You can mount a directory containing [Cloud Code](https://parse.com/docs/cloudcode/guide) into `/cloud` to use it on your app:

    $ docker run --link some-mongo:mongo -v <cloud code dir>:/cloud -e PARSE_SERVER_APPLICATION_ID=myAppId -e PARSE_SERVER_MASTER_KEY=mySecretMasterKey -p 1337:1337 -d raulr/parse-server

Alternatively, you can create an image with your Cloud Code using a custom `Dockerfile`:

```dockerfile
FROM raulr/parse-server
COPY ./cloud-code-dir /cloud
```

#### Environment Variables

* `PARSE_SERVER_APPLICATION_ID`: The application id to host with this server instance (required).
* `PARSE_SERVER_MASTER_KEY`: The master key to use for overriding ACL security (required).
* `PARSE_SERVER_MOUNT_PATH`: Mount path for the server (defaults to `/parse`).
* `PARSE_SERVER_URL`: URL to your parse server with `http://` or `https://` (defaults to `http://localhost:1337/parse`).
* `PARSE_SERVER_DATABASE_URI`: The full URI to your mongodb database (defaults to `mongodb://mongo:27017/parse`).
* `PARSE_SERVER_FILE_KEY`: Key for your files. For migrated apps, this is necessary to provide access to files already hosted on Parse (optional).
* `PARSE_SERVER_JAVASCRIPT_KEY`: Key for the Javascript SDK (optional).
* `PARSE_SERVER_REST_API_KEY`: Key for REST calls (optional).
* `PARSE_SERVER_DOT_NET_KEY`: Key for Unity and .Net SDK (optional).
* `PARSE_SERVER_CLIENT_KEY`: Key for iOS, MacOS, tvOS clients (optional).
* `PARSE_SERVER_FACEBOOK_APP_IDS`: Comma separated list for your facebook app Ids (optional).
* `PARSE_SERVER_ENABLE_ANON_USERS`: Enable (or disable) anon (defaults to `true`).
* `PARSE_SERVER_ALLOW_CLIENT_CLASS_CREATION`: Enable (or disable) client class creation (defaults to `true`).
* `PARSE_SERVER_MAX_UPLOAD_SIZE`: Max file size for uploads (defaults to `20mb`).
* `PARSE_SERVER_PUSH`: Configuration for [push](https://github.com/ParsePlatform/parse-server/wiki/Push), as stringified JSON (optional).
* `PARSE_SERVER_OAUTH_PROVIDERS`: Configuration for your [oAuth providers](https://github.com/ParsePlatform/parse-server/wiki/Parse-Server-Guide#oauth), as stringified JSON (optional).

### ... via [`docker-compose`](https://github.com/docker/compose)

Example `docker-compose.yml`:

```yaml
parse:
  image: raulr/parse-server
  ports:
    - "1337:1337"
  environment:
      PARSE_SERVER_APPLICATION_ID: myAppId
      PARSE_SERVER_MASTER_KEY: mySecretMasterKey
  links:
    - mongo
mongo:
  image: mongo:3.0
  command: "--setParameter failIndexKeyTooLong=false"
```

Run `docker-compose up`, wait for it to initialize completely, and visit `http://localhost:1337/parse` to test if it is running.
