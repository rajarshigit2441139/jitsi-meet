FROM jitsi/prosody:stable

# # Install Python and venv
# RUN apt-get update && apt-get install -y python3 python3-venv

# # Create and activate a virtual environment
# RUN python3 -m venv /opt/venv

# # Install pyhocon in the venv
# RUN /opt/venv/bin/pip install --upgrade pip && /opt/venv/bin/pip install pyhocon

# RUN /opt/venv/bin/pip install --upgrade pyhocon


# # Make the venv's Python and pip default
# ENV PATH="/opt/venv/bin:$PATH"

# Copy your scripts and templates
COPY pre-configure.sh /pre-configure.sh
#COPY edit_hocon.py /edit_hocon.py
COPY prosody-v.service.template /prosody-v.service.template
COPY prosody.cfg.lua.visitor.template /prosody.cfg.lua.visitor.template
RUN chmod +x /pre-configure.sh

ENTRYPOINT ["/pre-configure.sh"]
