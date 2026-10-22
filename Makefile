# Dabdub contracts Makefile

CONTRACTS := admin_auth admin_timelock batch_payments escrow fee_calculator fee_distributor liquidity_router registry

.PHONY: all build test clean help $(addprefix build-,$(CONTRACTS)) $(addprefix test-,$(CONTRACTS))

all: build

help:
	@echo "Available targets:"
	@echo "  make build              Build all contracts"
	@echo "  make test               Run all contract tests"
	@echo "  make clean              Remove all build artifacts"
	@echo "  make help               Show this help message"
	@echo ""
	@echo "Per-contract build targets:"
	@$(foreach c,$(CONTRACTS),echo "  make build-$(c)";)
	@echo ""
	@echo "Per-contract test targets:"
	@$(foreach c,$(CONTRACTS),echo "  make test-$(c)";)

build:
	cargo build --workspace

test:
	cargo test --workspace

clean:
	cargo clean
	rm -rf target
	rm -rf test_snapshots

$(addprefix build-,$(CONTRACTS)): build-%:
	cargo build -p $*

$(addprefix test-,$(CONTRACTS)): test-%:
	cargo test -p $*
