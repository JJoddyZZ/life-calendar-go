# code management

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