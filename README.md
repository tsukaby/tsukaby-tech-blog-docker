# tsukaby-tech-blog-docker

## Development

### Build

```
docker-compose build
```

### Run

```
docker-compose up
```

open "http://$(docker-machine)"

Your database data is stored in the `.docker-compose/db-data` folder.
If you want to reset the database, you can delete `.docker-compose/db-data/*`.

## Deploy

### Create

```
# Set values
ENV_NAME=

# List versions
aws elasticbeanstalk describe-application-versions --application-name tsukaby-tech-blog --query 'ApplicationVersions[].VersionLabel'

# Set
VERSION_LABEL=

# Run command
aws elasticbeanstalk create-environment --version-label ${VERSION_LABEL} --environment-name ${ENV_NAME} --cli-input-json file://eb/environments/prd.json
```

### Update

```
# Set values
APP_NAME=
ENV_NAME=
VERSION_LABEL=

# Run command
aws elasticbeanstalk update-environment --application-name tsukaby-tech-blog --environment-name ${ENV_NAME} --version-label ${VERSION_LABEL}
```