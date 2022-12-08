FROM golang:1.19.3 as build

ENV GO111MODULE=on

WORKDIR /app/server

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

# build app binary without CGO_ENABLED (required for alpine versions)
RUN CGO_ENABLED=0 go build main.go

FROM alpine:latest as server

WORKDIR /app/server

COPY --from=build /app/server/main ./

RUN chmod +x ./main

# run binary as non-root
RUN addgroup --system runner && adduser --system --no-create-home --disabled-password runner && adduser runner runner
USER runner

CMD ["./main"]
