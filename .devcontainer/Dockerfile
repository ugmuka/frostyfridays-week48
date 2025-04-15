FROM mcr.microsoft.com/devcontainers/python:3.11

RUN apt-get update && apt-get install -y direnv

# setup direnv
RUN echo 'eval "$(direnv hook bash)"' >> /home/vscode/.bashrc
