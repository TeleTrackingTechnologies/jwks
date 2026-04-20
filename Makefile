KID ?= epic-test-key-1
ALG ?= RS384

PUBLIC_DIR := public
JWKS_DIR := $(PUBLIC_DIR)/.well-known
JWKS_FILE := $(JWKS_DIR)/jwks.json
SCRIPT := scripts/build_jwks.py

.PHONY: all keys jwks clean show

all: jwks

keys: private_key.pem public_key.pem

private_key.pem:
	openssl genrsa -out private_key.pem 2048

public_key.pem: private_key.pem
	openssl rsa -in private_key.pem -pubout -out public_key.pem

$(JWKS_DIR):
	mkdir -p $(JWKS_DIR)

$(PUBLIC_DIR)/.nojekyll:
	touch $(PUBLIC_DIR)/.nojekyll

jwks: public_key.pem $(SCRIPT) | $(JWKS_DIR) $(PUBLIC_DIR)/.nojekyll
	KID=$(KID) ALG=$(ALG) uvx --with cryptography python $(SCRIPT)

show:
	@echo "KID=$(KID)"
	@echo "ALG=$(ALG)"
	@echo "JWKS_FILE=$(JWKS_FILE)"
	@ls -l private_key.pem public_key.pem $(JWKS_FILE) 2>/dev/null || true

clean:
	rm -f private_key.pem public_key.pem
	rm -rf $(PUBLIC_DIR)
