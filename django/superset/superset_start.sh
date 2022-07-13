#!/bin/bash

export SUPERSET_CONFIG_PATH=/home/projects/superset/superset_config.py

if [ ! -e "/home/projects/superset/superset_config.py" ]; then

    echo "============== superset initialize =============="
    # prepare dir
    mkdir -p /home/projects/superset
    cp /home/superset_config.py.org /home/projects/superset/superset_config.py
    #sudo chown -R `whoami`:`whoami` /home/projects
    #cd /home/projects/

    # Initialize the database
    superset db upgrade

    # Create an admin user 
    export FLASK_APP=superset:app \
    && flask fab create-admin \
       --username admin \
       --firstname administrator \
       --lastname '' \
       --email admin@fab.org \
       --password admin

    # Load some data to play with
    #superset load_examples

    # Create default roles and permissions
    superset init

fi

echo "#### superset execute ####"
superset run -h 0.0.0.0 -p 8080 --with-threads --reload --debugger