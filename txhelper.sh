#!/bin/sh

NVTXPWR=$(nvram get wl1_txpower)
txcheck=$(nvram get wl1_txpower)
NVTXPWRCSTM=$(nvram get 5ghz_qtn_mod_pwr)
NVTXPWRCSTMTGL=$(nvram get 5ghz_qtn_mod_pwr_tgl)

txvars() {
	if [ "$NVTXPWRCSTMTGL" -eq "1" ] && [ "$NVTXPWRCSTM" -le "30" ] && [ "$NVTXPWRCSTM" -ge "1" ]; then
		CSTMTXPWR="$NVTXPWRCSTM"
	else
		if [ "$NVTXPWR" -lt "25" ]; then
			CSTMTXPWR="24"
		elif [ "$NVTXPWR" -lt "50" ]; then
			CSTMTXPWR="26"
		elif [ "$NVTXPWR" -lt "88" ]; then
			CSTMTXPWR="27"
		elif [ "$NVTXPWR" -lt "100" ]; then
			CSTMTXPWR="28"
		elif [ "$NVTXPWR" -eq "100" ]; then
			CSTMTXPWR="29"
		fi
	fi
}

module() {
	cnt=0
	until [ $cnt = "400" ]; do
		qcsapi_sockrpc apply_regulatory_cap wifi0 0
		qcsapi_sockrpc set_test_mode_tx_power calcmd $CSTMTXPWR
		cnt=$((cnt + 1))
	done
	while [ "1" -eq "1" ]; do
		if [ $NVTXPWR -eq $txcheck ]; then
			txcheck=$(nvram get wl1_txpower)
			NVTXPWRCSTM=$(nvram get 5ghz_qtn_mod_pwr)
			NVTXPWRCSTMTGL=$(nvram get 5ghz_qtn_mod_pwr_tgl)
			txvars
			qcsapi_sockrpc set_test_mode_tx_power calcmd $CSTMTXPWR
			sleep 5
		else
			NVTXPWR=$(nvram get wl1_txpower)
			txcheck=$(nvram get wl1_txpower)
			txvars
			sleep 80
			until [ $cnt = "15" ]; do
				qcsapi_sockrpc apply_regulatory_cap wifi0 0
				qcsapi_sockrpc set_test_mode_tx_power calcmd $CSTMTXPWR
				cnt=$((cnt + 1))
				sleep 1
			done
		fi
	done
}
info() {
	cat <<EOF
################################################
txhelper v1.0 RC1 (part of the ac87utility)
This binary helps to adjust TX power of Quantenna
wireless chip and is needed for ac87utility to be 
functional.
################################################
Created by valuxin
2018
################################################
PayPal: valuxin@list.ru
Yandex.Money: 41001613334816
################################################
Daemon started!
################################################
EOF
}
info
module &>/dev/null