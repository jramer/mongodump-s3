# mongodump-s3

> Docker Image with Alpine Linux, mongodump and awscli for backup mongo database to s3. Adapted to shards. Original from https://github.com/lgaticaq/mongodump-s3

## Use

### Periodic backup

Run every day at 2 am

```bash
docker run -d --name mongodump \
  -e "DB_NAME=meteor"
  -e "SUPERUSER=meteor"
  -e "SUPERUSER_PASSWORD=your_db_user_password"
  -e "REPLICA_SET_NAME=MyCluster0-shard-0"
  -e "C_SHARD_00=mycluster0-shard-00-00-abcde.mongodb.net"
  -e "C_SHARD_01=mycluster0-shard-00-01-abcde.mongodb.net"
  -e "C_SHARD_02=mycluster0-shard-00-02-abcde.mongodb.net"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  lgatica/mongodump-s3
```

Run every day at 2 am with full mongodb

```bash
docker run -d --name mongodump \
  -e "DB_NAME=meteor"
  -e "SUPERUSER=meteor"
  -e "SUPERUSER_PASSWORD=your_db_user_password"
  -e "REPLICA_SET_NAME=MyCluster0-shard-0"
  -e "C_SHARD_00=mycluster0-shard-00-00-abcde.mongodb.net"
  -e "C_SHARD_01=mycluster0-shard-00-01-abcde.mongodb.net"
  -e "C_SHARD_02=mycluster0-shard-00-02-abcde.mongodb.net"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *"
  -e "MONGO_COMPLETE=true"
  lgatica/mongodump-s3
```

Run every day at 2 am with full mongodb and keep last 5 backups

```bash
docker run -d --name mongodump \
  -v /tmp/backup:/backup
  -e "DB_NAME=meteor"
  -e "SUPERUSER=meteor"
  -e "SUPERUSER_PASSWORD=your_db_user_password"
  -e "REPLICA_SET_NAME=MyCluster0-shard-0"
  -e "C_SHARD_00=mycluster0-shard-00-00-abcde.mongodb.net"
  -e "C_SHARD_01=mycluster0-shard-00-01-abcde.mongodb.net"
  -e "C_SHARD_02=mycluster0-shard-00-02-abcde.mongodb.net"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *"
  -e "MONGO_COMPLETE=true"
  -e "MAX_BACKUPS=5"
  lgatica/mongodump-s3
```

### Inmediatic backup

```bash
docker run -d --name mongodump \
  -e "DB_NAME=meteor"
  -e "SUPERUSER=meteor"
  -e "SUPERUSER_PASSWORD=your_db_user_password"
  -e "REPLICA_SET_NAME=MyCluster0-shard-0"
  -e "C_SHARD_00=mycluster0-shard-00-00-abcde.mongodb.net"
  -e "C_SHARD_01=mycluster0-shard-00-01-abcde.mongodb.net"
  -e "C_SHARD_02=mycluster0-shard-00-02-abcde.mongodb.net"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  lgatica/mongodump-s3
```

## IAM Policity

You need to add a user with the following policies. Be sure to change `your_bucket` to the correct name.

```xml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1412062044000",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket/*"
            ]
        },
        {
            "Sid": "Stmt1412062128000",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket"
            ]
        }
    ]
}
```

## Extra environmnet

- `S3_PATH` - Default value is `backup`. Example `s3://your_bucket/backup`
- `AUTH_DB` - Default value is `admin`.
- `DB_PORT` - Default value is `27017`.
- `MONGO_COMPLETE` - Default not set. If set doing backup full mongodb
- `MAX_BACKUPS` - Default not set. If set doing it keeps the last n backups in /backup

## License

[MIT](https://tldrlegal.com/license/mit-license)
