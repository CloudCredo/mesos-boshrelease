#!/bin/bash

JOB_DIR=/var/vcap/jobs/jenkins_master
RUN_DIR=/var/vcap/sys/run/jenkins_master
LOG_DIR=/var/vcap/sys/log/jenkins_master
PIDFILE=$RUN_DIR/install_dependencies.pid

# needed for rabbitmq to function properly
export HOME=/root

# function to test for a lock
# expects the lock file as the first argument
function f_lock_test {

lock_pid_file=$1
# error checking
if [[ ${lock_pid_file} == "" ]]
  then
    echo "no lock file argument provided"
    return 1
fi

if [ -e ${lock_pid_file} ]
  then
    existing_pid=`cat ${lock_pid_file}`
    if kill -0 ${existing_pid} > /dev/null
      then
        echo "Process already running"
        return 1
    else
      rm ${lock_pid_file}
    fi
fi
echo $$  > ${lock_pid_file}
}

# PID/lock - we only want one instance running.
f_lock_test ${PIDFILE}

mkdir -p ${LOG_DIR}

while true
  do

    if test -e /etc/apt/sources.list.d/rabbitmq.list
      then true
      else
        echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
    fi

    if apt-key list | grep -q 056E8E56
      then true
      else
        curl http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -
    fi

    if  dpkg -s rabbitmq-server > /dev/null
      then true
      else
        aptitude update
        aptitude install -y rabbitmq-server
    fi

    if rabbitmq-plugins list | egrep -q "^\[E\] rabbitmq_management "
      then true
      else
        echo "enabling rabbitmq management plugin"
        rabbitmq-plugins  enable rabbitmq_management
        service rabbitmq-server restart
    fi

    sleep 60
  done
