#!/bin/sh

# shellcheck disable=SC2068
spark-class org.apache.spark.deploy.worker.Worker $@
