# sam-varnish
A Secure and Minimal docker-image with Varnish. Listens by default on port 6081.

## Environment variables
### pre-set variables (can be set at runtime)
* JAIL (none)
* VCL_FILE (/etc/varnish/default.vcl)
* READ_ONLY_PARAMS (cc_command,vcc_allow_inline_c,vmod_path)
* LISTEN_ADDRESS ("")
* LISTEN_PORT (6081)
* MANAGEMENT_ADDRESS (localhost)
* MANAGEMENT_PORT (6082)
* STORAGE (malloc,100M)
* DEFAULT_TTL (120)
* ADDITIONAL_OPTS ("") f ex. "-p tcp_fastopen=on -S /etc/varnish/secret"

### Optional runtime variables
* IMPORTS: #-separated list of imports.
* BACKENDS: #-separated list of backend names.
* \<backend\>: #-separated list of backend definition rows for \<backend\>.
* ACLS: #-separated list of acl names.
* \<acl\>: #-separated list of acl definition rows for \<acl\>.
* VCL_INIT, VCL_RECV, VCL_PIPE, VCL_PASS, VCL_HASH, VCL_HIT, VCL_MISS, VCL_BACKEND_RESPONSE, VCL_BACKEND_ERROR, VCL_DELIVER, VCL_PURGE, VCL_SYNTH, VCL_FINI: #-separated list of sub definition rows. F ex VCL_RECV='set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");# return (pass);'.

## Capabilities
### Can drop
* All but CHOWN, SETGID and SETUID.
