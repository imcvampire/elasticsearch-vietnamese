ARG ELASTICSEARCH_VERSION

FROM elasticsearch:${ELASTICSEARCH_VERSION}

ARG ELASTICSEARCH_VERSION
ARG VIETNAMESE_ANALYSIS_VERSION

RUN elasticsearch-plugin install -b analysis-icu
RUN elasticsearch-plugin install -b https://github.com/sun-asterisk-research/elasticsearch-analysis-vi/releases/download/v${VIETNAMESE_ANALYSIS_VERSION}/analysis-vi-${VIETNAMESE_ANALYSIS_VERSION}-es${ELASTICSEARCH_VERSION}.zip
