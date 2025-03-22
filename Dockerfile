FROM docker:dind

WORKDIR /action
COPY . /action

ENTRYPOINT [ "/action/run-bullfrog.sh" ]
