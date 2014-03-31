# Homepage des Akademischen Gesangverein München

Dies ist die Homepage des [AGV München](https://www.agv-muenchen.de).

Sie basiert auf [Middleman][] und kommt gänzlich ohne dynamischen Code aus.

[Middleman]: http://middlemanapp.com/

## Deployment

```bash
bundle exec rake deploy
```

## Development

Run server with

```bash
bundle exec middleman server
```

## Environment variables
* `GOOGLE_ANALYTICS_ID`
* `CRAZYEGG_ID`
* `HOPTOAD_API_KEY` API Key for [Errbit error cacher](https://github.com/errbit/errbit) at <http://errbit.baucloud.com>
* `ASSET_HOST_URL` to serve assets from a CDN like Amazon CloudFront
