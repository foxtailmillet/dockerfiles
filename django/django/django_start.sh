#!/bin/bash

MYSITE_DIR_NAME="mysite"
APP_DIR_NAME="app"

if [ ! -e "/home/projects/${MYSITE_DIR_NAME}/manage.py" ]; then
    echo "============== django project [${MYSITE_DIR_NAME}] create =============="
    # prepare dir
    sudo chown -R `whoami`:`whoami` /home/projects
    cd /home/projects/

    # create project
    django-admin startproject ${MYSITE_DIR_NAME}

    # create application module
    echo "============== django app [${APP_DIR_NAME}] create =============="
    cd mysite
    python manage.py startapp ${APP_DIR_NAME}
fi

echo "#### runserver execute ####"
cd /home/projects/${MYSITE_DIR_NAME}
python manage.py runserver "0.0.0.0:8000"