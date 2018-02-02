!/bin/sh
set -e

if [ ! -e "$VCL_FILE" ]
then
   mkdir -p "$(dirname "$VCL_FILE")"
   if [ -n "$BACKENDS" ]
   then
      echo "vcl 4.0;" >> "$VCL_FILE"
      echo >> "$VCL_FILE"
      IFS=";"
      for import in $IMPORTS
      do
         echo "import $import;" >> "$VCL_FILE"
      done
      echo >> "$VCL_FILE"
      for backend in $BACKENDS
      do
         echo "backend $backend {" >> "$VCL_FILE"
         eval "backend_config=\$$backend"
         for row in $backend_config
         do
            echo "   $row;" >> "$VCL_FILE"
         done
         echo "}" >> "$VCL_FILE"
         echo >> "$VCL_FILE"
      done
      echo >> "$VCL_FILE"
      for acl in $ACLS
      do
         echo "acl $acl {" >> "$VCL_FILE"
         eval "acl_config=\$$acl"
         for row in $acl_config
         do
            echo "   $row;" >> "$VCL_FILE"
         done
         echo "}" >> "$VCL_FILE"
         echo >> "$VCL_FILE"
      done
      subs="VCL_INIT; VCL_RECV; VCL_PIPE; VCL_PASS; VCL_HASH; VCL_HIT; VCL_MISS; VCL_BACKEND_RESPONSE; VCL_DELIVER; VCL_PURGE; VCL_SYNTH; VCL_FINI"
      for sub in $subs
      do
         sub_lc=`tr "[:upper:]" "[:lower:]" $sub`
         echo "sub $sub_lc {" >> "$VCL_FILE"
         eval "sub_rows=\$$sub"
         for row in $sub_rows
         do
            echo "   $row;" >> "$VCL_FILE"
         done
         echo "}" >> "$VCL_FILE"
         echo >> "$VCL_FILE"
      done
   else
      
fi
         
         





      subs="
      echo "sub vcl_recv {" >> "$VCL_FILE"
      IFS=";"
      for row in $VCL_RECV
      do
         echo "   $row;" >> "$VCL_FILE"
      done
      echo "}" >> "$VCL_FILE"
      echo >> "$VCL_FILE"
      echo "sub vcl_hash {" >> "$VCL_FILE"
      IFS=";"
      for row in $VCL_RECV
      do
         echo "   $row;" >> "$VCL_FILE"
      done
      echo "}" >> "$VCL_FILE"
      echo >> "$VCL_FILE"
      
   echo >> "$CONFIG_FILE"
   echo "[pgbouncer]" >> "$CONFIG_FILE"
   echo "listen_addr=$LISTEN_ADDR" >> "$CONFIG_FILE"
   echo "auth_file=$AUTH_FILE" >> "$CONFIG_FILE"
   if [ -n "$AUTH_TYPE" ]
   then
      echo "auth_type=$AUTH_TYPE" >> "$CONFIG_FILE"
      if [ ! `echo $AUTH_TYPE | grep -iq "hba"` ]
      then
         echo "auth_hba_file=$AUTH_HBA_FILE" >> "$CONFIG_FILE"
      fi
   fi
   echo "unix_socket_dir=$UNIX_SOCKET_DIR" >> "$CONFIG_FILE"
   if [ -n "$CLIENT_TLS_SSLMODE" ] && [ `echo $CLIENT_TLS_SSLMODE | grep -iq "disable"` ]
   then
      echo "client_tls_sslmode=$CLIENT_TLS_SSLMODE" >> "$CONFIG_FILE"
      echo "client_tls_ca_file=$CLIENT_TLS_CA_FILE" >> "$CONFIG_FILE"
      echo "client_tls_cert_file=$CLIENT_TLS_CERT_FILE" >> "$CONFIG_FILE"
      echo "client_tls_key_file=$CLIENT_TLS_KEY_FILE" >> "$CONFIG_FILE"
   fi
   if [ -n "$SERVER_RESET_QUERY" ]
   then
      echo "server_reset_query=$SERVER_RESET_QUERY" >> "$CONFIG_FILE"
   fi
   for conf in $ADDITIONAL_CONFIGURATION
   do
      echo "$conf" >> "$CONFIG_FILE"
   done
fi

if [ -n "$AUTH_HBA" ] && [ ! -f "$AUTH_HBA_FILE" ]
then
   mkdir -p "$(dirname "$AUTH_HBA_FILE")"
   for hba in $AUTH_HBA
   do
      echo "$hba" >> "$AUTH_HBA_FILE"
   done
fi

if [ ! -f "$AUTH_FILE" ]
then
   mkdir -p "$(dirname "$AUTH_FILE")"
   for auth in $AUTH
   do
      echo "$auth" >> "$AUTH_FILE"
   done
fi

if [ ! -e "$UNIX_SOCKET_DIR" ]
then
   mkdir -p "$UNIX_SOCKET_DIR"
fi

pgbouncer "$CONFIG_FILE"
exit 0


varnishd -j ${JAIL} -P "${PID_FILE}" -f "${VARNISH_CONFIG_DIR}/default.vcl" -r ${READ_ONLY_PARAMS} -a ${LISTEN_ADDRESS}:${LISTEN_PORT} -T ${MANAGEMENT_ADDRESS}:${MANAGEMENT_PORT} -s ${STORAGE} -t ${DEFAULT_TTL} -F ${ADDITIONAL_OPTS}
