.PHONY: test docs

# Run tests
test:
	cd test && go test -v -timeout 5m

# Generate documentation using terraform-docs
docs:
	terraform-docs markdown .