#!/usr/bin/env bash

set -e

# -----------------------------------------------------------------------------
# Select Nginx Configuration based on API_PROXY_SCHEME
# -----------------------------------------------------------------------------
NGINX_CONF_DIR="/etc/nginx/conf.d"
rm -f "${NGINX_CONF_DIR}/default.conf"
if [ -n "$API_PROXY_SCHEME" ]; then
    if [[ "${API_PROXY_SCHEME}" == "hybrid" ]]; then
        cp -f "$NGINX_CONF_DIR/ragflow.conf.hybrid" "$NGINX_CONF_DIR/ragflow.conf"
        echo "Applied nginx config: ragflow.conf.hybrid"
    elif [[ "${API_PROXY_SCHEME}" == "go" ]]; then
        cp -f "$NGINX_CONF_DIR/ragflow.conf.golang" "$NGINX_CONF_DIR/ragflow.conf"
        echo "Applied nginx config: ragflow.conf.golang (default)"
    else
        cp -f "$NGINX_CONF_DIR/ragflow.conf.python" "$NGINX_CONF_DIR/ragflow.conf"
        echo "Applied nginx config: ragflow.conf.python"
    fi
else
    # Default to python backend
    cp -f "$NGINX_CONF_DIR/ragflow.conf.python" "$NGINX_CONF_DIR/ragflow.conf"
    echo "Default: applied nginx config: ragflow.conf.python"
fi