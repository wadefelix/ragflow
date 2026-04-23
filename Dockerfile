# base stage
ARG BASEIMAGE=registry.home.renwei.net:5000/ragflow/base
FROM ${BASEIMAGE}

COPY admin admin
COPY api api
COPY conf conf
COPY deepdoc deepdoc
COPY rag rag
COPY agent agent
COPY pyproject.toml uv.lock ./
COPY mcp mcp
COPY common common
COPY memory memory
COPY bin bin
COPY tools/scripts tools/scripts

COPY docker/service_conf.yaml.template ./conf/service_conf.yaml.template
COPY docker/entrypoint.sh ./
RUN chmod +x ./entrypoint*.sh \
 && echo "${RAGFLOW_VERSION}" > /ragflow/VERSION
