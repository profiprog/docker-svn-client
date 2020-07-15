FROM alpine:3.7
RUN apk add --no-cache subversion
COPY . /usr/local/bin
WORKDIR /workspace
VOLUME [ "/workspace" ]
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "svn" ]