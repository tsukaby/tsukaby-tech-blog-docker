### Packaging

```
./package_for_elastic_beanstalk.sh
```

### Deploy

#### Create

```
# Set values
APP_NAME=
ENV_NAME=

# List versions
aws elasticbeanstalk describe-application-versions --application-name ${APP_NAME} --query 'ApplicationVersions[].VersionLabel'

# Set
VERSION_LABEL=

# Run command
aws elasticbeanstalk create-environment --version-label ${VERSION_LABEL} --environment-name ${ENV_NAME} --cli-input-json file://eb/environments/prd.json
```

#### Update

```
# Set values
APP_NAME=
ENV_NAME=
VERSION_LABEL=

# Run command
aws elasticbeanstalk update-environment --application-name ${APP_NAME} --environment-name ${ENV_NAME} --version-label ${VERSION_LABEL}
```