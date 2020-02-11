ARG ELASTICSEARCH_VERSION

FROM elasticsearch:${ELASTICSEARCH_VERSION}

ARG ELASTICSEARCH_VERSION

RUN elasticsearch-plugin install --batch https://github.com/duydo/elasticsearch-analysis-vietnamese/releases/download/v${ELASTICSEARCH_VERSION}/elasticsearch-analysis-vietnamese-${ELASTICSEARCH_VERSION}.zip
