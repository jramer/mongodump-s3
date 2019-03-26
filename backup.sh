#!/usr/bin/env sh

BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"

# Run backup
mongodump -d $DB_NAME -u $SUPERUSER -p "$SUPERUSER_PASSWORD" -o /backup/dump --authenticationDatabase $AUTH_DB --ssl --port $DB_PORT -h "$REPLICA_SET_NAME/$C_SHARD_00,$C_SHARD_01,$C_SHARD_02"

# Compress backup
cd /backup/ && tar -cvzf "${BACKUP_NAME}" dump
# Upload backup
aws s3 cp "/backup/${BACKUP_NAME}" "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"
# Delete temp files
rm -rf /backup/dump

# Delete backup files
if [ -n "${MAX_BACKUPS}" ]; then
  while [ $(ls /backup -w 1 | wc -l) -gt ${MAX_BACKUPS} ];
  do
    BACKUP_TO_BE_DELETED=$(ls /backup -w 1 | sort | head -n 1)
    rm -rf /backup/${BACKUP_TO_BE_DELETED}
  done
else
  rm -rf /backup/*
fi
