#!/bin/bash
# Info: Updates service status web-page
# Usage: ./check_service.sh

set -o nounset


localfile="/home/monitor1/StickyBitsProject/Monitor/index.html"
host="dev_env@10.1.1.2"

# Apache variables
apache_row_status=57
apache_row_time=58
apache_already_running=false
apache_up_since="time"
apache_down_since="time"
apache_current_time=$(sed "${apache_row_time}q;d" $localfile | awk '{print $2}')

# MySQL variables
mysql_row_status=62
mysql_row_time=63
mysql_already_running=false
mysql_up_since="time"
mysql_down_since="time"
mysql_current_time=$(sed "${mysql_row_time}q;d" $localfile | awk '{print $2}')

# Python variables
python_row_status=67
python_row_time=68
python_already_running=false
python_up_since="time"
python_down_since="time"
python_current_time=$(sed "${python_row_time}q;d" $localfile | awk '{print $2}')

# Java variables
java_row_status=72
java_row_time=73
java_already_running=false
java_up_since="time"
java_down_since="time"
java_current_time=$(sed "${java_row_time}q;d" $localfile | awk '{print $2}')

# Docker variables
docker_row_status=77
docker_row_time=78
docker_already_running=false
docker_up_since="time"
docker_down_since="time"
docker_current_time=$(sed "${docker_row_time}q;d" $localfile | awk '{print $2}')

# Server variables
server_row_status=82
server_row_time=83
server_already_running=false
server_up_since="time"
server_down_since="time"
server_current_time=$(sed "${server_row_time}q;d" $localfile | awk '{print $2}')


update_html() {
	
	row_number=$1
	old_line=$2
	new_line=$3
	

	sed -i "${row_number}s/"$old_line"/"$new_line"/" $localfile
	sleep 1
}


service_update() {

        # Update HTML-file 
        update_html $1 $2 $3
        update_html $1 $4 $5
        update_html $6 $7 $8

}

check_apache() {
	
        if [[ `systemctl --host $host is-active Apache_status.service` == 'active' ]] && [[ $apache_already_running == 'false' ]]; then
		apache_up_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $apache_row_status "OFFLINE" "ONLINE" "rdot" "gdot" $apache_row_time $apache_current_time $apache_up_since
                apache_current_time=$apache_up_since
                apache_already_running=true

        elif [[ `systemctl --host $host is-active Apache_status` != 'active' ]] && [[ $apache_already_running == 'true' ]]; then
		apache_down_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $apache_row_status "ONLINE" "OFFLINE" "gdot" "rdot" $apache_row_time $apache_current_time $apache_down_since
                apache_current_time=$apache_down_since
                apache_already_running=false
        fi
	sleep 1
}

check_mysql() {
	
	if [[ `systemctl --host $host is-active Mysql_status` == "active" ]] && [[ $mysql_already_running == 'false' ]]; then
		mysql_up_since="$(date +%Y-%m-%d_%H-%M-%S)"
		service_update $mysql_row_status "OFFLINE" "ONLINE" "rdot" "gdot" $mysql_row_time $mysql_current_time $mysql_up_since
        	mysql_current_time=$mysql_up_since
		mysql_already_running=true	

	elif [[ `systemctl --host $host is-active Mysql_status` != "active" ]] && [[ $mysql_already_running == 'true' ]]; then
        	mysql_down_since="$(date +%Y-%m-%d_%H-%M-%S)"
		service_update $mysql_row_status "ONLINE" "OFFLINE" "gdot" "rdot" $mysql_row_time $mysql_current_time $mysql_down_since
		mysql_current_time=$mysql_down_since
		mysql_already_running=false
	fi
	sleep 1
}

check_python() {

        if [[ `systemctl --host $host is-active Python_status` == "active" ]] && [[ $python_already_running == 'false' ]]; then
                python_up_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $python_row_status "OFFLINE" "ONLINE" "rdot" "gdot" $python_row_time $python_current_time $python_up_since
                python_current_time=$python_up_since
                python_already_running=true

        elif [[ `systemctl --host $host is-active Python_status` != "active" ]] && [[ $python_already_running == 'true' ]]; then
                python_down_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $python_row_status "ONLINE" "OFFLINE" "gdot" "rdot" $python_row_time $python_current_time $python_down_since
                python_current_time=$python_down_since
                python_already_running=false
        fi
	sleep 1
}

check_java() {

        if [[ `systemctl --host $host is-active Java_status` == "active" ]] && [[ $java_already_running == 'false' ]]; then
                java_up_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $java_row_status "OFFLINE" "ONLINE" "rdot" "gdot" $java_row_time $java_current_time $java_up_since
                java_current_time=$java_up_since
                java_already_running=true

        elif [[ `systemctl --host $host is-active Java_status` != "active" ]] && [[ $java_already_running == 'true' ]]; then
                java_down_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $java_row_status "ONLINE" "OFFLINE" "gdot" "rdot" $java_row_time $java_current_time $java_down_since
                java_current_time=$java_down_since
                java_already_running=false
        fi
	sleep 1
}

check_docker() {

        if [[ `systemctl --host $host is-active docker` == "active" ]] && [[ $docker_already_running == 'false' ]]; then
		docker_up_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $docker_row_status "OFFLINE" "ONLINE" "rdot" "gdot" $docker_row_time $docker_current_time $docker_up_since
		docker_current_time=$docker_up_since
		docker_already_running=true

        elif [[ `systemctl --host $host is-active docker` != "active" ]] && [[ $docker_already_running == 'true' ]]; then
		docker_down_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $docker_row_status "ONLINE" "OFFLINE" "gdot" "rdot" $docker_row_time $docker_current_time $docker_down_since
		docker_current_time=$docker_down_since
		docker_already_running=false
        fi
	sleep 1
}


check_server() {
	
	if `ping -c 1 10.1.1.2 &> /dev/null` && [[ $server_already_running == 'false' ]]; then
		server_up_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $server_row_status "OFFLINE" "ONLINE" "rdot" "gdot" $server_row_time $server_current_time $server_up_since
                server_current_time=$server_up_since
                server_already_running=true
	elif ! `ping -c 1 10.1.1.2 &> /dev/null` && [[ $server_already_running == 'true' ]]; then
		server_down_since="$(date +%Y-%m-%d_%H-%M-%S)"
                service_update $server_row_status "ONLINE" "OFFLINE" "gdot" "rdot" $server_row_time $server_current_time $server_down_since
                server_current_time=$server_down_since
                server_already_running=false
	fi
}


# Start with re-setting 

file1="/home/monitor1/StickyBitsProject/Monitor/index.html.old"
file2="/home/monitor1/StickyBitsProject/Monitor/index.html"
/bin/cp -rf $file1 $file2

while [ true ]; do


	check_apache
	check_mysql
	check_python
	check_java
	check_docker
	check_server
	
done
