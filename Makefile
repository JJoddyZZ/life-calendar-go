### code management

fmt:
	@echo "=== Formating the code ==="
	go fmt ./...
	@echo "=== Done ==="

update-deps:
	@echo "=== Updating dependencies ==="
	go get -u ./...
	@echo "=== Done ==="

remove-unused-deps:
	@echo "=== Running golint ==="
	go mod tidy -v
	@echo "=== Done ==="

### local deploy

local-build:
	@echo "=== Building service ==="
	go build -o bin/app/ ./...
	@echo "=== Done ==="

local-run: local-build
	@echo "=== Running service ==="
	@./bin/app/life-calendar-go

### container deployment

docker-build:
	@echo "=== Building container ==="
	docker build --tag life-calendar-go .
	@echo "=== Done ==="
# --progress=plain logs output to stdout
docker-build-verbose:
	@echo "=== Building container (verbose) ==="
	docker build --progress=plain --no-cache --tag life-calendar-go .
	@echo "=== Done ==="
# -d flag will ignore STDOUT prints
docker-run-detached-container: docker-build
	@echo "=== Running container (detached) ==="
	@docker run -d -p 8180:8080 --name life-calendar-go life-calendar-go
	@echo "=== Done ==="
docker-run-container: docker-build
	@echo "=== Building container ==="
	@docker run -p 8180:8080 --name life-calendar-go life-calendar-go
	@echo "=== Done ==="
docker-clean:
	@echo "=== Cleaning up docker deployment ==="
	-@docker stop life-calendar-go
	-@docker rm life-calendar-go
	-@docker rmi life-calendar-go
	@echo "=== Done ==="

### testing

test:
	@go test -cover -coverprofile=coverage.out -race ./...
test-verbose:
	@go test -v -cover -coverprofile=coverage.out -race ./...
display-cover: test
	@go tool cover -html=coverage.out