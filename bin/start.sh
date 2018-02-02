#!/bin/sh
set -e

if [ ! -e "$VCL_FILE" ]
then
   mkdir -p "$(dirname "$VCL_FILE")"
   if [ -n "$BACKENDS" ]
   then
      echo "vcl 4.0;" >> "$VCL_FILE"
      echo >> "$VCL_FILE"
      IFS="#"
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
      subs="VCL_INIT#VCL_RECV#VCL_PIPE#VCL_PASS#VCL_HASH#VCL_HIT#VCL_MISS#VCL_BACKEND_RESPONSE#VCL_BACKEND_ERROR#VCL_DELIVER#VCL_PURGE#VCL_SYNTH#VCL_FINI"
      for sub in $subs
      do
         sub_lc="$(echo $sub | tr '[:upper:]' '[:lower:]')"
         echo "sub $sub_lc {" >> "$VCL_FILE"
         eval "sub_rows=\$$sub"
         for row in $sub_rows
         do
            echo "   $row" >> "$VCL_FILE"
         done
         echo "}" >> "$VCL_FILE"
         echo >> "$VCL_FILE"
      done
   else
      cp $CONFIG_DIR/default.vcl.template "$VCL_FILE"
   fi
fi
varnishd -j $JAIL -P "$PID_FILE" -f "$VCL_FILE" -r $READ_ONLY_PARAMS -a $LISTEN_ADDRESS:$LISTEN_PORT -T $MANAGEMENT_ADDRESS:$MANAGEMENT_PORT -s $STORAGE -t $DEFAULT_TTL -F $ADDITIONAL_OPTS
exit 0
