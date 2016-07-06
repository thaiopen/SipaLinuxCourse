#!/bin/bash
file="passwordlist"
if [ -f passwordlist ]; then
  echo "Sorry, file exist"
else
  echo "Generate file: passwordlist"
  echo DB_PASS=$(openssl rand -hex 10) >> passwordlist
  echo ADMIN_PASS=$(openssl rand -hex 10) >> passwordlist
  echo CEILOMETER_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo CEILOMETER_PASS=$(openssl rand -hex 10) >> passwordlist
  echo CINDER_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo CINDER_PASS=$(openssl rand -hex 10) >> passwordlist
  echo DASH_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo DEMO_PASS=$(openssl rand -hex 10) >> passwordlist
  echo GLANCE_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo GLANCE_PASS=$(openssl rand -hex 10) >> passwordlist
  echo HEAT_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo HEAT_DOMAIN_PASS=$(openssl rand -hex 10) >> passwordlist
  echo HEAT_PASS=$(openssl rand -hex 10) >> passwordlist
  echo KEYSTONE_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo NEUTRON_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo NEUTRON_PASS=$(openssl rand -hex 10) >> passwordlist
  echo NOVA_DBPASS=$(openssl rand -hex 10) >> passwordlist
  echo NOVA_PASS=$(openssl rand -hex 10) >> passwordlist
  echo RABBIT_PASS=$(openssl rand -hex 10) >> passwordlist
  echo SWIFT_PASS=$(openssl rand -hex 10) >> passwordlist
fi
