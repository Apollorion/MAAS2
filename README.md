# MAAS2

Maas2 is a stateless api for MAAS. Its a simple reorganization of the data available officially by nasa [here](http://cab.inta-csic.es/rems//wp-content/plugins/marsweather-widget/api.php).

### URLs
https://api.maas2.apollorion.com/ - The official MAAS2 endpoint.

### Params
`/` - Gets the latest from the API.  
`/$sol` - Gets a specific sol.


## Building
To build, just download the offical MAAS api json to this repo as `maas2.json` and run `main.py`.

1. `curl http://cab.inta-csic.es/rems//wp-content/plugins/marsweather-widget/api.php > maas2.json`
2. `python main.py`
