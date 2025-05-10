#!/bin/bash
set -e
set -x

# HOCON_CONFIG="/config/jicofo.conf"
# if [ ! -f "$HOCON_CONFIG" ]; then
#   mkdir -p "$(dirname "$HOCON_CONFIG")"
#   echo '{}' > "$HOCON_CONFIG"
# fi

# # Ensure password is set
# if ! python3 /edit_hocon.py $HOCON_CONFIG get "jicofo.xmpp.client.password" >/dev/null 2>&1; then
#   NEWPASS=$(openssl rand -hex 16)
#   python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.client.password" "$NEWPASS"
# fi

# PASS=$(python3 /edit_hocon.py $HOCON_CONFIG get "jicofo.xmpp.client.password")

# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.selection-strategy" "VisitorSelectionStrategy"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.visitor-selection-strategy" "RegionBasedBridgeSelectionStrategy"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.participant-selection-strategy" "RegionBasedBridgeSelectionStrategy"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.bridge.topology-strategy" "VisitorTopologyStrategy"

# # Make sure INSTANCE is set
# if [ -z "$INSTANCE" ]; then
#   INSTANCE=1
# fi

# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.enabled" true
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.conference-service" "conference.v${INSTANCE}.meet.jitsi"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.hostname" 127.0.0.1
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.port" 5222${INSTANCE}
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.domain" "auth.meet.jitsi"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.xmpp-domain" "v${INSTANCE}.meet.jitsi"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.password" "${PASS}"
# python3 /edit_hocon.py $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.disable-certificate-verification" true

# # Write password for Prosody to shared volume
# echo "About to write password to /config/focus-password.txt"
# echo "$PASS" > /config/focus-password.txt
# echo "Wrote password to /config/focus-password.txt"


# # Start Jicofo
# exec /init


####==========================================Given by the devloper=========================================

#Configure jicofo
HOCON_CONFIG="/etc/jitsi/jicofo/jicofo.conf"
if [ ! -f "$HOCON_CONFIG" ]; then
  mkdir -p "$(dirname "$HOCON_CONFIG")"
  echo '{}' > "$HOCON_CONFIG"
fi
cat "$HOCON_CONFIG"

hocon -f $HOCON_CONFIG set "jicofo.bridge.selection-strategy" "VisitorSelectionStrategy"
hocon -f $HOCON_CONFIG set "jicofo.bridge.visitor-selection-strategy" "RegionBasedBridgeSelectionStrategy"
hocon -f $HOCON_CONFIG set "jicofo.bridge.participant-selection-strategy" "RegionBasedBridgeSelectionStrategy"
hocon -f $HOCON_CONFIG set "jicofo.bridge.topology-strategy" "VisitorTopologyStrategy"

PASS=$(hocon -f $HOCON_CONFIG get "jicofo.xmpp.client.password")

#prosodyctl --config /etc/prosody-v${INSTANCE}/prosody.cfg.lua register focus auth.meet.jitsi $PASS
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.enabled" true
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.conference-service" "conference.v${INSTANCE}.meet.jitsi"
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.hostname" 127.0.0.1
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.port" 5222${INSTANCE}
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.domain" "auth.meet.jitsi"
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.xmpp-domain" "v${INSTANCE}.meet.jitsi"
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.password" "${PASS}"
hocon -f $HOCON_CONFIG set "jicofo.xmpp.visitors.v${INSTANCE}.disable-certificate-verification" true

echo "About to write password to /config/focus-password.txt"
echo "$PASS" > /config/focus-password.txt
echo "Wrote password to /config/focus-password.txt"
exec /init

# service jicofo restart