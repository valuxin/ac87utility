#!/bin/sh

## Checksums
daemon_file_checksum0=$(./data txhelper_crc)
cfe_clean_bin_checksum0=$(./data clean_crc)
nvsimple_file_checksum0=$(./data nvsimple_crc)
mtd_write_file_checksum0=$(./data mtd_write_crc)

## Paths
daemon_path="/jffs/tools"
utility_tmp_dir="/tmp/home/temp"
## Options
trap '' SIGINT SIGQUIT SIGTSTP
## Size
customwinsize=$(printf '\033[8;25;80t')
## Colors
CRESET='\033[0m'
WB='\033[0;30;107m'
RB='\033[0;30;101m'
GB='\033[0;30;102m'
YB='\033[0;30;103m'
## Apperence
theme() {
	clear
	echo -e $WB
	echo -e $customwinsize
	clear
}

header() {
	cat <<EOF
################################################################################
###                                                                          ###
###                          ac87utility v1.0 RC1                            ###
###                                                                          ###
################################################################################
EOF
}

bottom() {
	cat <<EOF | openssl aes-128-cbc -a -d -salt -k "valuxin@2018"
U2FsdGVkX1+qadzuCK9zG+E3CqgQqWkoulOyK7ABNOp6B3wSriqp/hBRM3spzSer
igXxrytJrzw+V3RASJ9UKNF/DfBkzIs1p5CHloddBQfP9onxT8+gdl+9SYuRMmez
OMNqY4WuXKOGZYB1CoipTzP1S4RnM0T1MJu+cQNzIGc3NqOJpHfBuL092D9AsHmR
3JDRo9wygZ7AiB2Qewm19YcP4qeyu/2kG6m4XchV555QlNnvEgdlrio8OO+a5z/h
FNStRC6o4x/Wv6UopCY0jelko3QY6DL7r+ZHxVbEfUQyd0KTb6XkyUDecwAhtNb5
TVLgexgkk18yo4QgKAN1hJ5bgB261HfRBKQ48MrV40tZNZncKO5/FGrVQBYkmGxD
92UunLc2l8YuuVl1S1k5vcVlwtWW2OW2ikxQ50vKF18Cj6xUtty4mjDbxZ7PbjzS
EM+hTd6NIgTWlDsjnMhgr2p44MBjtjdSKeNChmOJcK0h/6N3Qke6/2EOD9C1N1kA
oTGXXkNq6n9r6Z0GhUhOn4Hz/BRyw4m+GX1FsmCwSMlGpqfHDY6ZQDaoiOJ78hFZ
NpuYr6lz41uQwW+x9jl8pVTIFRomY9vH6Jc1ilrHahZv7Xt4lbaCsRsC19R+8Vif
UfTzD3b6JK/VABP0aSk+8kbR/IaHOHaphJAj5LdJ7tIpor0UuhM422U4oSzwiLJo
PggFCqfIAYOIQkVlSa0Gw5cBg84ywFjYjt4JhPZc+Ny1UBD/CQhgUdO43Tgg4qzs
jIHKOq3YnEZIxCcY3Ly2Vxv8yqaAW+khz+ukYXG+6nnb2SS24QhErcVjgRu84k47
nqpirA7Nf705E2fLWC+e8NsEckRTb32tIza2FO8+DF8agjKU79jjLspcsA0DVYo6
SklbEN4VxbECPWaFTcCMO7MJe+K3M1mcMLzAgnq65u/W9GYChUMVO+0sn+zpPZgo
+bhVATiecgsbOnrY2lxCgorKVrKxaWkXChCpXOF4jkLK9/AqE4NyLuY7sdgN9Wml
76l8j4UPtWjV7AmbkitBVWVpBUxrczJCJm4gbWvB6uuMUbOPSYOYOn+MV1URzhKI
qKmrRzR4M46nfODkdHemVMUA2WDXErw55N9JN1dNC0QTjL0bFs12SDtdiWBy/pZC
GKCockA1MQhjPQfBLSzGQo4xoEpOlDSPdEgO4zQmu/UrqVdq5Z5ZdFZhnWxSYXlq
EOF
}

info() {
	echo -e "   CFE bootloader: $cfe_status        CPU freq: $cpuclk_status"
	echo -e "   Daemon: $daemon_status               2G power: $power_2g_status"
	echo -e "   Manual 5G power: $manual_control_status            5G power: $power_5g_status"
	echo -e "################################################################################"
}

messagebox0() {
	get_info_header
	theme
	header
	info
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo -e "                                 ${message}"
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	sleep 3
}

info_box() {
	bottom_info=$(bottom)
	get_info_header
	theme
	header
	echo ""
	echo ""
	echo ""
	echo ""
	echo "                 Thank you for using this tool! I hope you enjoy ;)"
	echo ""
	echo ""
	echo ""
	echo -e "$bottom_info"
}

## Menu

menu0() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "                   1. CFE tools"
		echo "                   2. Daemon tools"
		echo "                   3. Manual 5G power control"
		echo ""
		echo "                   0. Exit"
		echo "                   9. Reboot"
		echo ""
		echo "                  ***Hit Enter to refresh***"
		echo ""
		local choice
		read -p "                   Enter choice:  " choice
		case $choice in
		1) menu1 ;;
		2) menu2 ;;
		3) check_manual_control ;;
		"") menu0 ;;
		0) info_box && sleep 7 && echo -e $CRESET && clear && exit 0 ;;
		9) info_box && sleep 7 && reboot && exit 0 ;;
		*) echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu0 ;;
		esac
	done
}

menu1() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "                   1. Dump current CFE"
		echo "                   2. Flash CFE mod"
		echo "                   3. Flash custom CFE file"
		echo ""
		echo "                   0. Back"
		echo ""
		echo ""
		echo ""
		echo ""
		local choice
		read -p "                   Enter choice:  " choice
		case $choice in
		1) menu11 ;;
		2) menu12 ;;
		3) menu13 ;;
		0) menu0 ;;
		*) echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu1 ;;
		esac
	done
}

menu11() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "              Hit ENTER to save it in current folder OR type 0 to go back"
		echo ""
		echo ""
		local choice
		read -p "                                  " choice
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		case $choice in
		"") dump_cfe ${runfrom_path}/ &>/dev/null && messagebox0 && menu1 ;;
		0) menu1 ;;
		*) echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu11 ;;
		esac
	done
}

menu12() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "                   1. WiFi tweaks only"
		echo "                   2. CPU & WiFi tweaks"
		echo ""
		echo "                   0. Back"
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		local choice
		read -p "                   Enter choice:  " choice
		case $choice in
		1) flash_cfe_mod ;;
		2) menu122 ;;
		0) menu1 ;;
		*) echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu12 ;;
		esac
	done
}

menu122() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "              Enter your desired CPU clock speed in Mhz (from 800 to 1400)"
		echo ""
		echo ""
		local choice
		read -p "                                  " choice
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		if [ "$choice" != "" ] && [ "$choice" -le "1400" ] && [ "$choice" -ge "800" ]; then
			flash_cfe_mod $choice
		else
			echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu12
		fi
	done
}

menu13() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "              Enter full path for your CFE file (ex. /mnt/sda1/cfe.bin)"
		echo ""
		echo ""
		local choice
		read -p "                                  " choice
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		cfe_check_true=$(strings $choice | grep bl_version)
		if [ -f "$choice" ] && [ "$cfe_check_true" != "" ]; then
			flash_cfe_cstm $choice
		else
			echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu1
		fi
	done
}

menu2() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "                   1. Install/Reinstall daemon"
		echo "                   2. Remove daemon"
		echo ""
		echo "                   0. Back"
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		local choice
		read -p "                   Enter choice:  " choice
		case $choice in
		1) daemon_install ;;
		2) remove_daemon ;;
		0) menu0 ;;
		*) echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu2 ;;
		esac
	done
}

menu3_0() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "                   1. Turn On manual control"
		echo ""
		echo "                   0. Back"
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		local choice
		read -p "                   Enter choice:  " choice
		case $choice in
		1) nvram set 5ghz_qtn_mod_pwr_tgl=1 && nvram commit && menu3_1 ;;
		0) menu0 ;;
		*) echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu3_0 ;;
		esac
	done
}

menu3_1() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "                   1. Turn Off manual control"
		echo "                   2. Set custom TX power for 5G module"
		echo ""
		echo "                   0. Back"
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		local choice
		read -p "                   Enter choice:  " choice
		case $choice in
		1) nvram set 5ghz_qtn_mod_pwr_tgl=0 && nvram commit && menu3_0 ;;
		2) menu3_12 ;;
		0) menu0 ;;
		*) echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu3_1 ;;
		esac
	done
}

menu3_12() {
	get_info_header
	theme
	header
	info
	while true; do
		echo ""
		echo ""
		echo ""
		echo "                   Hit ENTER to refresh or type 0 to go back"
		echo ""
		echo ""
		local choice
		read -p "               Enter custom power in dBm (from 1 to 30):  " choice
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		if [ "$choice" != "" ] && [ "$choice" -le "30" ] && [ "$choice" -ge "1" ]; then
			choice=$((choice - 1))
			nvram set 5ghz_qtn_mod_pwr=$choice
			nvram commit
			{
				qcsapi_sockrpc set_test_mode_tx_power calcmd $choice
			} &>/dev/null
			menu3_12
		elif [ "$choice" = "" ]; then
			menu3_12
		elif [ "$choice" = "0" ]; then
			menu3_1
		else
			echo -e "                                  ${RB}Error...${WB}" && sleep 2 && menu3_12
		fi
	done
}

## Functions
get_cfe_ver() {
	cfe_ver=$(strings /dev/mtd0 | grep bl_version | sed 's/bl_version=//g')

	if [ "$cfe_ver" = "2.0.3.2" ]; then
		cfe_status="${GB}Modified${WB}"
	else
		cfe_status="${GB}Original${WB}"
	fi
}

get_daemon() {
	if [ ! -f "${daemon_path}/txhelper" ]; then
		daemon_status="${YB}No${WB}       "
	else
		daemon_checksum1=$(openssl sha1 ${daemon_path}/txhelper | awk '{print $2}')
		if [ "$daemon_file_checksum0" = "$daemon_checksum1" ]; then
			daemon_status="${GB}Installed${WB}"
		else
			daemon_status="${RB}Corrupted${WB}"
		fi
	fi
}

get_manual_control() {
	NVTXPWRCSTMTGL=$(nvram get 5ghz_qtn_mod_pwr_tgl)
	if [ "$NVTXPWRCSTMTGL" == "" ]; then
		nvram set 5ghz_qtn_mod_pwr_tgl=0 && nvram commit
	else
		if [ "$NVTXPWRCSTMTGL" -eq "1" ]; then
			manual_control_status="${GB}ON${WB} "
		else
			manual_control_status="${YB}OFF${WB}"
		fi
	fi
}

get_cpu_clock() {
	cpuclk=$(nvram get clkfreq | sed 's/clkfreq=//g' | sed 's/,[0-9][0-9][0-9]//g')
	cpuclk_status="${cpuclk}Mhz"
}

get_power_2g() {
	channel2g=$(wl txpwr_target_max | awk '{print $5}' | sed "s/(chanspec://g" | sed "s/)://g")
	power2g=$(wl chanspec_txpwr_max | grep $channel2g | awk '{print $3}' | sed "s/(dbm)/dBm/g")
	power_2g_status="$power2g $power2g $power2g"
}

get_power_5g() {
	power_5g_status=$(qcsapi_sockrpc get_test_mode_tx_power calcmd | grep dBm)
}

get_info_header() {
	get_cfe_ver
	get_daemon
	get_manual_control
	get_cpu_clock
	get_power_2g
	get_power_5g
}

dump_cfe() {
	dump_cnt=1
	if [ ! -f "${1}cfe_dump.bin" ]; then
		dd if=/dev/mtd0 of=${1}cfe_dump.bin
		if [ -f "${1}cfe_dump.bin" ]; then
			message="${GB}DONE ${WB}"
		else
			message="${RB}FAILED... ${WB}"
		fi
	else
		until [ ! -f "${1}cfe_dump${dump_cnt}.bin" ]; do
			dump_cnt=$(($dump_cnt + 1))
		done
		dd if=/dev/mtd0 of=${1}cfe_dump${dump_cnt}.bin
		if [ -f "${1}cfe_dump${dump_cnt}.bin" ]; then
			message="${GB}DONE ${WB}"
		else
			message="${RB}FAILED... ${WB}"
		fi
	fi
}

flash_cfe_mod() {
	message="${YB}Flashing...${WB}"
	messagebox0
	sleep 1
	mkdir -p $utility_tmp_dir
	nvsimple_file
	cfe_clean_bin
	mtd_write_file
	chmod a+rx ${utility_tmp_dir}/*
	dump_cfe ${utility_tmp_dir}/ &>/dev/null
	nvsimple_file_checksum1=$(openssl sha1 ${utility_tmp_dir}/nvsimple | awk '{print $2}')
	mtd_write_file_checksum1=$(openssl sha1 ${utility_tmp_dir}/mtd-write | awk '{print $2}')
	cfe_clean_bin_checksum1=$(openssl sha1 ${utility_tmp_dir}/data.bin | awk '{print $2}')
	if [ "$nvsimple_file_checksum0" != "$nvsimple_file_checksum1" ] || [ "$cfe_clean_bin_checksum0" != "$cfe_clean_bin_checksum1" ] || [ "$mtd_write_file_checksum0" != "$mtd_write_file_checksum1" ]; then
		message="${RB}Something went wrong: 001 ${WB}"
		messagebox0
		menu12
	fi
	mac0_cfe=$(strings /dev/mtd0 | grep 0:macaddr | sed 's/0:macaddr=//g')
	mac1_cfe=$(strings /dev/mtd0 | grep 1:macaddr | sed 's/1:macaddr=//g')
	eth1_cfe=$(strings /dev/mtd0 | grep et1macaddr | sed 's/et1macaddr=//g')
	secd_cfe=$(strings /dev/mtd0 | grep secret_code | sed 's/secret_code=//g')
	{
		${utility_tmp_dir}/nvsimple -e ${utility_tmp_dir}/data.bin -v -o 1024 -l 4096 | sort >${utility_tmp_dir}/nvars
	} &>/dev/null
	sed -i "s|^\(0:macaddr\)=.*|\1=${mac0_cfe}|g" ${utility_tmp_dir}/nvars
	sed -i "s|^\(1:macaddr\)=.*|\1=${mac1_cfe}|g" ${utility_tmp_dir}/nvars
	sed -i "s|^\(et1macaddr\)=.*|\1=${eth1_cfe}|g" ${utility_tmp_dir}/nvars
	sed -i "s|^\(secret_code\)=.*|\1=${secd_cfe}|g" ${utility_tmp_dir}/nvars
	if [ "$1" != "" ] && [ "$1" -le "1400" ] && [ "$1" -ge "800" ]; then
		sed -i "s|^\(clkfreq\)=.*|\1=${1},800|g" ${utility_tmp_dir}/nvars
	fi
	{
		${utility_tmp_dir}/nvsimple -i ${utility_tmp_dir}/nvars ${utility_tmp_dir}/data.bin -v -o 1024 -l 4096
	} &>/dev/null
	{
		${utility_tmp_dir}/mtd-write ${utility_tmp_dir}/data.bin boot
	} &>/dev/null
	new_cfe_checksum0=$(openssl sha1 ${utility_tmp_dir}/data.bin | awk '{print $2}')
	new_cfe_checksum1=$(openssl sha1 /dev/mtd0 | awk '{print $2}')
	if [ "$new_cfe_checksum0" != "$new_cfe_checksum1" ]; then
		{
			${utility_tmp_dir}/mtd-write ${utility_tmp_dir}/cfe_dump.bin boot
		} &>/dev/null
		rm -r $utility_tmp_dir
		message="${RB}Something went wrong: 002 ${WB}"
		messagebox0
		menu1
	else
		rm -r $utility_tmp_dir
		message="${GB}Success!${WB}"
		messagebox0
		menu1
	fi
}

flash_cfe_cstm() {
	message="${YB}Flashing...${WB}"
	messagebox0
	sleep 1
	mkdir -p $utility_tmp_dir
	mtd_write_file
	chmod a+rx ${utility_tmp_dir}/*
	dump_cfe ${utility_tmp_dir}/ &>/dev/null
	mtd_write_file_checksum1=$(openssl sha1 ${utility_tmp_dir}/mtd-write | awk '{print $2}')
	if [ "$mtd_write_file_checksum0" != "$mtd_write_file_checksum1" ]; then
		message="${RB}Something went wrong: 001 ${WB}"
		messagebox0
		menu1
	fi
	{
		${utility_tmp_dir}/mtd-write $1 boot
	} &>/dev/null
	new_cfe_checksum0=$(openssl sha1 $1 | awk '{print $2}')
	new_cfe_checksum1=$(openssl sha1 /dev/mtd0 | awk '{print $2}')
	if [ "$new_cfe_checksum0" != "$new_cfe_checksum1" ]; then
		{
			${utility_tmp_dir}/mtd-write ${utility_tmp_dir}/cfe_dump.bin boot
		} &>/dev/null
		rm -r $utility_tmp_dir
		message="${RB}Something went wrong: 002 ${WB}"
		messagebox0
		menu1
	else
		rm -r $utility_tmp_dir
		message="${GB}Success!${WB}"
		messagebox0
		menu1
	fi
}

daemon_install() {
	message="${YB}Installing...${WB}"
	messagebox0
	sleep 1
	## Removing
	{
		rm -r $daemon_path/txhelper
		rm -r $daemon_path/deps
		remove_d_string=$(cat /jffs/scripts/post-mount | grep -v "/jffs/tools/txhelper &")
		printf "${remove_d_string}" >/jffs/scripts/post-mount
		remove_deps_string=$(cat /jffs/scripts/post-mount | grep -v "/jffs/tools/deps")
		printf "${remove_deps_string}" >/jffs/scripts/post-mount
	} &>/dev/null
	## Installing
	mkdir -p $daemon_path
	daemon_file
	chmod a+rx ${daemon_path}/*
	chmod 777 ${daemon_path}/*
	daemon_file_checksum1=$(openssl sha1 ${daemon_path}/txhelper | awk '{print $2}')
	if [ "$daemon_file_checksum0" != "$daemon_file_checksum1" ]; then
		message="${RB}Something went wrong: 001 ${WB}"
		messagebox0
		menu2
	fi
	nvram set jffs2_scripts=1
	nvram set jffs2_on=1
	nvram set jffs2_enable=1
	nvram set jffs2_format=0
	nvram commit
	if [ ! -f "/jffs/scripts/post-mount" ]; then
		cat <<EOF >/jffs/scripts/post-mount
#!/bin/sh

/jffs/tools/txhelper &
EOF
	else
		check_post_mount=$(cat /jffs/scripts/post-mount | grep "#!/bin/sh")
		check_post_mount2=$(cat /jffs/scripts/post-mount | grep "/jffs/tools/txhelper &")
		if [ "$check_post_mount" = "#!/bin/sh" ] && [ "$check_post_mount2" != "/jffs/tools/txhelper &" ]; then
			echo "" >>/jffs/scripts/post-mount
			echo '/jffs/tools/txhelper &' >>/jffs/scripts/post-mount
		elif [ "$check_post_mount" != "#!/bin/sh" ] && [ "$check_post_mount2" != "/jffs/tools/txhelper &" ]; then
			cat <<EOF >/jffs/scripts/post-mount
#!/bin/sh

/jffs/tools/txhelper &
EOF
		fi
	fi
	chmod a+rx /jffs/scripts/post-mount
	check_post_mount2=$(cat /jffs/scripts/post-mount | grep "/jffs/tools/txhelper &")
	if [ "$check_post_mount2" = "/jffs/tools/txhelper &" ] || [ "$check_post_mount2" = "/jffs/tools/txhelper & sleep 1; rm -r /tmp/opt" ]; then
		message="${GB}Success!${WB}"
		messagebox0
		menu0
	else
		message="${RB}Failed... ${WB}"
		messagebox0
		menu2
	fi
}

remove_daemon() {
	message="${YB}Removing...${WB}"
	messagebox0
	sleep 1
	{
		rm -r $daemon_path/txhelper
		rm -r $daemon_path/deps
		remove_d_string=$(cat /jffs/scripts/post-mount | grep -v "/jffs/tools/txhelper &")
		printf "${remove_d_string}" >/jffs/scripts/post-mount
		remove_deps_string=$(cat /jffs/scripts/post-mount | grep -v "/jffs/tools/deps")
		printf "${remove_deps_string}" >/jffs/scripts/post-mount
	} &>/dev/null
	message="${GB}Done!${WB}"
	messagebox0
	menu2
}

check_manual_control() {
	if [ "$daemon_status" = "${GB}Installed${WB}" ] && [ "$manual_control_status" = "${GB}ON${WB} " ]; then
		menu3_1
	elif [ "$daemon_status" = "${GB}Installed${WB}" ] && [ "$manual_control_status" = "${YB}OFF${WB}" ]; then
		menu3_0
	else
		message="${YB}Install/Reinstall daemon first!${WB}"
		messagebox0
		menu0
	fi
}

## Files

nvsimple_file() {
	./data nvsimple_file | openssl aes-128-cbc -a -d -salt -k "P&39i72sUyuIaPQi%Ub6Q&eT%deFD#7QWAgi7NavL9u$g29LFsIibpS*s^mVDbE4n4oXV5N8s2ZfaywfV4&Irp5rCan3i8am&G6a8IpsGs&PZM5yJuYxbvde$A%qH75o" | gunzip -c >${utility_tmp_dir}/nvsimple
	sleep 1
}

mtd_write_file() {
	./data mtd_write_file | openssl aes-128-cbc -a -d -salt -k "P&39i72sUyuIaPQi%Ub6Q&eT%deFD#7QWAgi7NavL9u$g29LFsIibpS*s^mVDbE4n4oXV5N8s2ZfaywfV4&Irp5rCan3i8am&G6a8IpsGs&PZM5yJuYxbvde$A%qH75o" | gunzip -c >${utility_tmp_dir}/mtd-write
	sleep 1
}

cfe_clean_bin() {
	./data cfe_clean_bin | openssl aes-128-cbc -a -d -salt -k "P&39i72sUyuIaPQi%Ub6Q&eT%deFD#7QWAgi7NavL9u$g29LFsIibpS*s^mVDbE4n4oXV5N8s2ZfaywfV4&Irp5rCan3i8am&G6a8IpsGs&PZM5yJuYxbvde$A%qH75o" | gunzip -c >${utility_tmp_dir}/data.bin
	sleep 1
}

daemon_file() {
	./data daemon_file | openssl aes-128-cbc -a -d -salt -k "P&39i72sUyuIaPQi%Ub6Q&eT%deFD#7QWAgi7NavL9u$g29LFsIibpS*s^mVDbE4n4oXV5N8s2ZfaywfV4&Irp5rCan3i8am&G6a8IpsGs&PZM5yJuYxbvde$A%qH75o" | gunzip -c >${daemon_path}/txhelper
	sleep 1
}

## Action

menu0