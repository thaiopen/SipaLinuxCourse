================
Install keystone
================

Install Process
===============
root password is $DB_PASS. please chech database (optional)
::
	
	echo $DB_PASS
 	b2d1a3116eb60718f3c4
	mysql -uroot -p

	Enter password: 
	Welcome to the MariaDB monitor.  Commands end with ; or \g.
	Your MariaDB connection id is 7
	Server version: 10.1.12-MariaDB MariaDB Server

	Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

	Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

	MariaDB [(none)]> FLUSH PRIVILEGES;
	MariaDB [(none)]> SELECT User, Host, Password FROM mysql.user;

Install package
***************
::

    source passwordlist
    yum install openstack-keystone httpd mod_wsgi -y
    openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
    openstack-config --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:$KEYSTONE_DBPASS@controller/keystone
    openstack-config --set /etc/keystone/keystone.conf token provider fernet
    su -s /bin/sh -c "keystone-manage db_sync" keystone

set environment variable
::

    export OS_TOKEN=$ADMIN_TOKEN
    export OS_URL=http://controller:35357/v3
    export OS_IDENTITY_API_VERSION=3

Create tables in keystone database
::

    su -s /bin/sh -c "keystone-manage db_sync" keystone

Initialize key
::

    keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

Confit apache
::

    vi /etc/httpd/conf/httpd.conf
    96 ServerName controller

vi /etc/httpd/conf.d/wsgi-keystone.conf
::

    Listen 0.0.0.0:5000
    Listen 0.0.0.0:35357

    <VirtualHost *:5000>
        WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
        WSGIProcessGroup keystone-public
        WSGIScriptAlias / /usr/bin/keystone-wsgi-public
        WSGIApplicationGroup %{GLOBAL}
        WSGIPassAuthorization On
        ErrorLogFormat "%{cu}t %M"
        ErrorLog /var/log/httpd/keystone-error.log
        CustomLog /var/log/httpd/keystone-access.log combined

        <Directory /usr/bin>
            Require all granted
        </Directory>
    </VirtualHost>

    <VirtualHost *:35357>
        WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
        WSGIProcessGroup keystone-admin
        WSGIScriptAlias / /usr/bin/keystone-wsgi-admin
        WSGIApplicationGroup %{GLOBAL}
        WSGIPassAuthorization On
        ErrorLogFormat "%{cu}t %M"
        ErrorLog /var/log/httpd/keystone-error.log
        CustomLog /var/log/httpd/keystone-access.log combined

        <Directory /usr/bin>
            Require all granted
        </Directory>
    </VirtualHost>

:: 

    systemctl enable httpd.service
    systemctl start httpd.service

set environment variable
::

    export OS_TOKEN=$ADMIN_TOKEN
    export OS_URL=http://controller:35357/v3
    export OS_IDENTITY_API_VERSION=3

Create service Entry
====================
::

openstack service create --name keystone --description "OpenStack Identity" identity
