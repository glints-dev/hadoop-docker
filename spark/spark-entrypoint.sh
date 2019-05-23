#!/bin/bash


for c in $(printenv | perl -sne 'print "$1 " if m/^SPARK_CONF_(.+?)=.*/'); do 
    name=$(echo "${c}" | perl -pe 's/___/-/g; s/__/_/g; s/_/./g')
    var="SPARK_CONF_${c}"
    value=${!var}
    echo "Setting SPARK property $name=$value"
    echo "$name" "$value" >> "$SPARK_HOME/conf/spark-defaults.conf"
done 

case $1 in
    master)
        shift
        # shellcheck disable=SC2068
        exec /entrypoint.sh /spark-master.sh $@
        ;;
    slave)
        shift
        # shellcheck disable=SC2068
        exec /entrypoint.sh /spark-slave.sh $@
        ;;
    historyserver)
        shift
        # shellcheck disable=SC2068
        exec /entrypoint.sh /spark-historyserver.sh $@
        ;;
    submit)
        shift
        # shellcheck disable=SC2068
        exec /entrypoint.sh spark-submit $@
        ;;
    *)
        
        if [ "$HADOOP_ON_CLASSPATH" = "1" ]; then
            CLASSPATH="$(hadoop classpath)${CLASSPATH:+:$CLASSPATH}"
            export CLASSPATH
        fi

        if [ "$SPARK_ON_CLASSPATH" = "1" ]; then
            CLASSPATH="${SPARK_HOME}/jars/*${CLASSPATH:+:$CLASSPATH}"
            export CLASSPATH
        fi

        # shellcheck disable=SC2068
        exec /entrypoint.sh $@
        ;;
esac
