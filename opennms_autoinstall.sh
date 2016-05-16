#! /bin/bash




	echo "Set Postgres Admin Password, you also need to input then when asked"	"
	read passwor

	rm /etc/apt/sources.list.d/opennms.list
	touch /etc/apt/sources.list.d/opennms.list
	echo deb http://debian.opennms.org opennms-18 main >> /etc/apt/sources.list.d/opennms.list 
	echo deb-src http://debian.opennms.org opennms-18 main >> /etc/apt/sources.list.d/opennms.list
	wget -O - http://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -

#

	apt-get update
	apt-get install -y sudo opennms
	
#

	service postgresql start

#
	echo 'Set the next password as opnenms'
	su - postgres -c 'createuser -P opennms'
	su - postgres -c 'createdb -O opennms opennms -T template0 --encoding utf-8'
	
#	
	
	#sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '"$passwor"';"
	
	su - postgres -c "psql -U postgres -d postgres -c \"alter user postgres with password '"$passwor"';\""
	
#	
	
	/usr/sbin/install_iplike.sh
	
#	
#This sets your selected password into the datasources file
	sed -i 's/password=""/password="'$passwor'"/g' /usr/share/opennms/etc/opennms-datasources.xml
	
#
	
	/usr/share/opennms/bin/runjava -s
	/usr/share/opennms/bin/install -dis
	
#
	
	service opennms start