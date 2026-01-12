FROM n8nio/n8n:latest
USER root
RUN npm install -g @tryfabric/martian
USER node
