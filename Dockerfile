FROM swift:3.0.2

WORKDIR /package

COPY Package.swift ./
RUN swift package fetch

COPY . ./
RUN swift build

CMD swift test
