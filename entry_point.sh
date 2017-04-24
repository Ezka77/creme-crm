#!/bin/sh

cd /webapps/creme_crm

SECRET_KEY=${SECRET_KEY:-$(python manage.py build_secret_key)}
export SECRET_KEY

## Do this only on first run
if [ ! -f "/init_done" ]; then
    ### Add a delay to wait postgres to be up & running
    sleep 15
    ### TODO: add check with curl or something else
    su -c "python manage.py migrate"        django
    su -c "python manage.py generatemedia"  django
    su -c "python manage.py creme_populate" django
    touch /init_done
fi

exec "$@"
