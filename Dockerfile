FROM ubuntu AS builder 

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git cmake gcc build-essential default-jdk gawk

RUN git clone https://github.com/coccoc/coccoc-tokenizer.git 

WORKDIR /app/coccoc-tokenizer/build

RUN cmake -DBUILD_JAVA=1 ..
RUN make install 

WORKDIR /app

RUN git clone https://github.com/duydo/elasticsearch-analysis-vietnamese.git

WORKDIR /app/elasticsearch-analysis-vietnamese

RUN gawk -i inplace '{ gsub(/<version>7.4.0<\/version>/, "<version>7.12.1</version>") }; { print }' pom.xml
RUN gawk -i inplace '{ gsub(/\[7\.4\.0,\)/, "7.12.1") }; { print }' pom.xml

RUN apt-get install -y maven
RUN mvn package

FROM elasticsearch:7.12.1

COPY --from=builder /app/elasticsearch-analysis-vietnamese/target/releases/elasticsearch-analysis-vietnamese-7.12.1.zip .
RUN bin/elasticsearch-plugin install file:///usr/share/elasticsearch/elasticsearch-analysis-vietnamese-7.12.1.zip --batch
RUN bin/elasticsearch-plugin install analysis-icu --batch
RUN bin/elasticsearch-plugin install repository-gcs --batch

COPY --from=builder /usr/local/share/tokenizer /usr/local/share/tokenizer
COPY --from=builder /app/coccoc-tokenizer/build/libcoccoc_tokenizer_jni.so /usr/java/packages/lib/

