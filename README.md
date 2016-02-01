
### What is Parse Server?

> The open source Parse Server makes it possible to serve the Parse API from any infrastructure that can host Node.js applications. Parse Server provides a way for you to keep your application running without major changes in the client-side code, once you have your data in your own database. Our client SDKs now support changing the API server location to direct them to your own. This also lets you use the Parse client SDKs with entirely new applications that have no dependency on the Parse hosted services.

> &mdash; <cite>[Parse.com Blog](http://blog.parse.com/announcements/introducing-parse-server-and-the-database-migration-tool/)</cite>

### How to Use This Image

Parse Server depends on MongoDB, so first you need to launch a mongo instance:

    $ docker run --name some-mongo -d mongo:3.0 --setParameter failIndexKeyTooLong=false

Then you can launch the Parse Server container:

    $ docker run --link some-mongo:mongo -e PARSE_APP_ID=myAppId -e PARSE_MASTER_KEY=mySecretMasterKey -p 1337:1337 -d raulr/parse-server

#### Cloud Code

You can mount a directory containing [Cloud Code](https://parse.com/docs/cloudcode/guide) into `/app/cloud` to use it on your app:

    $ docker run --link some-mongo:mongo -v <cloud code dir>:/app/cloud -e PARSE_APP_ID=myAppId -e PARSE_MASTER_KEY=mySecretMasterKey -p 1337:1337 -d raulr/parse-server

Alternatively, you can create an image with your Cloud Code using a custom `Dockerfile`:

```dockerfile
FROM raulr/parse-server
COPY ./cloud-code-dir /app/cloud
```

#### Environment Variables

* `PARSE_DATABASE_URI:`: The connection string for your database (defaults to `mongodb://mongo:27017/parse`).
* `PARSE_APP_ID:`: The application id to host with this server instance (required).
* `PARSE_MASTER_KEY:`: The master key to use for overriding ACL security (required).
* `PARSE_FILE_KEY:`: For migrated apps, this is necessary to provide access to files already hosted on Parse (optional).
* `PARSE_JAVASCRIPT_KEY:`: The JavaScript key for your app (optional).
* `PARSE_REST_API_KEY:`: The REST API key for your app (optional).
* `PARSE_DOTNET_KEY:`: The .NET key for your app (optional).
* `PARSE_CLIENT_KEY:`: The client key for your app (optional).
* `PARSE_MOUNT:`: Path to serve the Parse API (defaults to `/parse`).

### ... via [`docker-compose`](https://github.com/docker/compose)

Example `docker-compose.yml`:

```yaml
parse:
  image: raulr/parse-server
  ports:
    - "1337:1337"
  environment:
      PARSE_APP_ID: myAppId
      PARSE_MASTER_KEY: mySecretMasterKey
  links:
    - mongo
mongo:
  image: mongo:3.0
  command: "--setParameter failIndexKeyTooLong=false"
```

Run `docker-compose up`, wait for it to initialize completely, and visit `http://localhost:1337/parse` to test if it is running.
