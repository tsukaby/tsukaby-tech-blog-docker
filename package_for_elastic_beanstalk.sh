#!/bin/sh

now=`date +"%Y%m%d_%H%M%S"`
file_name=${now}_tsukaby-tech-blog.zip

# Create zip
cd eb
zip -r ../${file_name} ./* .ebextensions
cd ..

# Upload
aws s3 mv ${file_name} s3://tsukaby-eb-binary/tsukaby-tech-blog/

# Create eb version
aws elasticbeanstalk create-application-version \
  --application-name tsukaby-tech-blog \
  --version-label ${now} \
  --source-bundle S3Bucket="tsukaby-eb-binary",S3Key=tsukaby-tech-blog/${file_name}