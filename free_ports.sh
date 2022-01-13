#! /bin/bash
# find files with 443 in them: grep 443 /usr/syno/share/nginx/*.mustache
# view in use ports: netstat -plnt | grep ":443"
# 
# idea from: https://gist.github.com/hjbotha/f64ef2e0cd1e8ba5ec526dcd6e937dd7
# modified from this one, because it fails when ran a 2nd time: https://www.reddit.com/r/synology/comments/ahs3xh/prevent_dsm_listening_on_port_80443/
#
NEW_HTTP_PORT=80
NEW_HTTPS_PORT=443

#sed -i -e 's/80/81/' -e 's/443/444/' /usr/syno/share/nginx/server.mustache /usr/syno/share/nginx/DSM.mustache /usr/syno/share/nginx/WWWService.mustache
#sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)80\([^0-9]\)/\1$NEW_HTTP_PORT\2/" /usr/syno/share/nginx/*.mustache
#sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)443\([^0-9]\)/\1$NEW_HTTPS_PORT\2/" /usr/syno/share/nginx/*.mustache
sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)80\([^0-9]\)/\1$NEW_HTTP_PORT\2/" /usr/syno/share/nginx/server.mustache /usr/syno/share/nginx/DSM.mustache /usr/syno/share/nginx/WWWService.mustache
sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)443\([^0-9]\)/\1$NEW_HTTPS_PORT\2/" /usr/syno/share/nginx/server.mustache /usr/syno/share/nginx/DSM.mustache /usr/syno/share/nginx/WWWService.mustache


if which synoservicecfg; then
  synoservicecfg --restart nginx
else
  synosystemctl restart nginx
fi


# sed -i -e 's/50050050080/80/' -e 's/505050443/443/' /usr/syno/share/nginx/server.mustache /usr/syno/share/nginx/DSM.mustache /usr/syno/share/nginx/WWWService.mustache