# Dabdub contracts Makefile

CONTRACTS := admin_auth admin_timelock batch_payments escrow fee_calculator fee_distributor liquidity_router registry

.PHONY: all build test clean help $(addprefix build-,$(CONTRACTS)) $(addprefix test-,$(CONTRACTS)) local-testnet-start local-testnet-stop local-testnet-deploy

all: build

help:
	@echo "Available targets:"
	@echo "  make build              Build all contracts"
	@echo "  make test               Run all contract tests"
	@echo "  make clean              Remove all build artifacts"
	@echo "  make help               Show this help message"
	@echo ""
	@echo "Local Soroban testnet targets:"
	@echo "  make local-testnet-start   Start local Soroban testnet (Docker)"
	@echo "  make local-testnet-stop    Stop local Soroban testnet"
	@echo "  make local-testnet-deploy  Deploy contracts to local testnet"
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

local-testnet-start:
	docker compose up -d
	@echo "Waiting for local Soroban testnet to become healthy..."
	@until curl -sf http://localhost:8000/soroban/rpc -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":1,"method":"getHealth"}' >/dev/null 2>&1; do sleep 2; done
	@echo "Local Soroban testnet is up at http://localhost:8000/soroban/rpc"

local-testnet-stop:
	docker compose down -v

local-testnet-deploy:
	./scripts/deploy-local-testnet.sh
