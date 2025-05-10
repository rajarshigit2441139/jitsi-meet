#!/bin/bash
set -e
set -x

SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

INSTANCE="${VISITOR_INSTANCE:-$1}"

if [[ -z "$INSTANCE" ]] || ! [[ $INSTANCE =~ ^[0-9]+$ ]]; then
  echo "error: VISITOR_INSTANCE is not set or not a number" >&2
  exit 1
fi

echo "Will configure visitor prosody instance $INSTANCE"

#JICOFO_HOSTNAME=$(echo get jitsi-videobridge/jvb-hostname | debconf-communicate jicofo | cut -d' ' -f2-)
JICOFO_HOSTNAME="${JICOFO_HOSTNAME:-localhost}"



# Configure this prosody instance
cp prosody-v.service.template /lib/systemd/system/prosody-v${INSTANCE}.service
sed -i "s/vX/v${INSTANCE}/g" /lib/systemd/system/prosody-v${INSTANCE}.service
mkdir /etc/prosody-v${INSTANCE}
ln -s /etc/prosody/certs /etc/prosody-v${INSTANCE}/certs
cp prosody.cfg.lua.visitor.template /etc/prosody-v${INSTANCE}/prosody.cfg.lua
sed -i "s/vX/v${INSTANCE}/g" /etc/prosody-v${INSTANCE}/prosody.cfg.lua
sed -i "s/jitmeet.example.com/$JICOFO_HOSTNAME/g" /etc/prosody-v${INSTANCE}/prosody.cfg.lua
# fix the ports
sed -i "s/52691/5269${INSTANCE}/g" /etc/prosody-v${INSTANCE}/prosody.cfg.lua
sed -i "s/52221/5222${INSTANCE}/g" /etc/prosody-v${INSTANCE}/prosody.cfg.lua
sed -i "s/52801/5280${INSTANCE}/g" /etc/prosody-v${INSTANCE}/prosody.cfg.lua
sed -i "s/52811/5281${INSTANCE}/g" /etc/prosody-v${INSTANCE}/prosody.cfg.lua


while [ ! -f /jicofo-config/focus-password.txt ]; do
  echo "Waiting for /jicofo-config/focus-password.txt..."
  sleep 2
done
# Read password from shared volume
PASS=$(cat /jicofo-config/focus-password.txt)
prosodyctl --config /etc/prosody-v${INSTANCE}/prosody.cfg.lua register focus auth.meet.jitsi $PASS

service prosody-v${INSTANCE} restart


# #Configure jicofo
# HOCON_CONFIG="/etc/jitsi/jicofo/jicofo.conf"
# if [ ! -f "$HOCON_CONFIG" ]; then
#   mkdir -p "$(dirname "$HOCON_CONFIG")"
#   echo '{}' > "$HOCON_CONFIG"
# fi
# cat "$HOCON_CONFIG"

# hocon -f $HOCON_CONFIG set "jicofo.bridge.selection-strategy" "VisitorSelectionStrategy"
# hocon -f $HOCON_CONFIG set "jicofo.bridge.visitor-selection-strategy" "RegionBasedBridgeSelectionStrategy"
# hocon -f $HOCON_CONFIG set "jicofo.bridge.participant-selection-strategy" "RegionBasedBridgeSelectionStrategy"
# hocon -f $HOCON_CONFIG set "jicofo.bridge.topology-strategy" "VisitorTopologyStrategy"

# PASS=$(hocon -f $HOCON_CONFIG get "jicofo.xmpp.client.password")

# prosodyctl --config /etc/prosody-v${INSTANCE}/prosody.cfg.lua register focus auth.meet.jitsi $PASS
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.enabled" true
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.conference-service" "conference.v${INSTANCE}.meet.jitsi"
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.hostname" 127.0.0.1
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.port" 5222${INSTANCE}
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.domain" "auth.meet.jitsi"
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.xmpp-domain" "v${INSTANCE}.meet.jitsi"
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.password" "${PASS}"
# hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.disable-certificate-verification" true

#================================



# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.selection-strategy" "VisitorSelectionStrategy"
# cat /etc/jitsi/jicofo/jicofo.conf

# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.visitor-selection-strategy" "RegionBasedBridgeSelectionStrategy"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.participant-selection-strategy" "RegionBasedBridgeSelectionStrategy"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.topology-strategy" "VisitorTopologyStrategy"

# PASS=$(python3 /edit_hocon.py $HOCON_CONFIG get "jicofo.xmpp.client.password")

# prosodyctl --config /etc/prosody-v${INSTANCE}/prosody.cfg.lua register focus auth.meet.jitsi $PASS

# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.enabled" true
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.conference-service" "conference.v${INSTANCE}.meet.jitsi"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.hostname" 127.0.0.1
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.port" 5222${INSTANCE}
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.domain" "auth.meet.jitsi"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.xmpp-domain" "v${INSTANCE}.meet.jitsi"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.password" "${PASS}"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.disable-certificate-verification" true


# service jicofo restart

