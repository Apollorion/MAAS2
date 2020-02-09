# MAAS2

Maas2 is a RESTFUL API written in NodeJS for AWS Lambda for caching/pulling mars weather data from NASA.

### URLs
https://api.maas2.apollorion.com/ - The official MAAS2 endpoint.  
https://maas2.apollorion.com/ - The official MAAS2 SwaggerUI documentation.

### Params
`/` - Gets the latest from the API.  
`/$sol` - Gets a specific sol.


## Building

Basically, you need to build the lambda payloads with `lambda_payload_generator.yml` (requires docker) and then apply the terraform in the `terraform` directory.
  
`seed_db.sql` will create the database scheme / some initial inserts for you.

```shell script
ansible-playbook lambda_payload_generator.yml && cd terraform && terraform apply
```