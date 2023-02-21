# MAAS2

Maas2 is a stateless api for MAAS. Its a simple reorganization of the data available officially by nasa [here](http://cab.inta-csic.es/rems//wp-content/plugins/marsweather-widget/api.php).

### URLs
https://api.maas2.apollorion.com/ - The official MAAS2 endpoint.

### Params
`/` - Gets the latest from the API.  
`/$sol` - Gets a specific sol.

#### Example

https://api.maas2.apollorion.com/ - Gets the latest sol.
https://api.maas2.apollorion.com/3322 - Gets sol 3322.

Some sol's have incomplete data, day 2 for example does not have data which will return a `404` http status.
`{"status": "sol not found"}`

*Ignore content type of all requests, this is now hosted in github pages which sets the content type incorrectly.*
You can safely assume all content type is `application/json`.

## Building
To build, just download the offical MAAS api json to this repo as `maas2.json` and run `main.py`.

1. `curl http://cab.inta-csic.es/rems//wp-content/plugins/marsweather-widget/api.php > maas2.json`
2. `python main.py`
