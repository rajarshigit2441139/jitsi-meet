FROM jitsi/prosody:stable

# Copy your visitor Prosody config template and setup script
COPY prosody.cfg.lua.visitor.template /defaults/conf.d/prosody.cfg.lua.visitor.template
COPY pre-configure.sh /pre-configure.sh

RUN chmod +x /pre-configure.sh

ENTRYPOINT ["/pre-configure.sh"]
