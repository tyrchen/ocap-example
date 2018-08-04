TOP_DIR=.
OUTPUT_DIR=$(TOP_DIR)/output
README=$(TOP_DIR)/README.md
PRIV_DIR=$(TOP_DIR)/src/priv

BUILD_NAME=ocap_service
VERSION=$(strip $(shell cat version))
ELIXIR_VERSION=$(strip $(shell cat src/.elixir_version))
OTP_VERSION=$(strip $(shell cat src/.otp_version))
DB_USER=postgres
DB_PASS=postgres
DB_ETH=ethereum
DB_BTC=bitcoin
DB_NOTEBOOK=notebook
DB_LIST=$(DB_BTC) $(DB_ETH) $(DB_NOTEBOOK)
FIXTURE_BTC=$(PRIV_DIR)/$(DB_BTC)/fixture
FIXTURE_ETH=$(PRIV_DIR)/$(DB_ETH)/fixture

build:
	@echo "Building the software..."
	@rm -rf src/_build/dev/lib/{ocap_service,ocap_rpc,ocap_schema};
	@make format

format:
	@cd src; mix compile; mix format;

init: submodule install dep
	@echo "Initializing the repo..."
	@brew install yamllint
	@make init-db

init-db:
	$(foreach db,$(DB_LIST),PGPASSWORD=$(DB_PASS) psql -U $(DB_USER) -d postgres -c "drop database $(db)" || true;)

	@cd src; mix ecto.create; mix ecto.migrate
	@cp $(FIXTURE_BTC)/* /tmp/
	@PGPASSWORD=$(DB_PASS) psql -U $(DB_USER) -d $(DB_BTC) -a -f /tmp/bitcoin.sql

travis-init: submodule extract-deps dep
	@echo "Initialize software required for travis (normally ubuntu software)"

npm:
	@cd src/assets; npm install;

install:
	@echo "Install software required for this repo..."
	@mix local.hex --force
	@mix local.rebar --force

dep:
	@echo "Install dependencies required for this repo..."
	@cd src; mix deps.get

pre-build: install dep api-doc-install
	@echo "Running scripts before the build..."

post-build:
	@echo "Running scripts after the build is done..."

all: pre-build build post-build build-api-docs

test:
	@echo "Running test suites..."
	@cd src; MIX_ENV=test mix test

lint:
	@echo "Linting the software..."

doc:
	@echo "Building the documenation..."

precommit: pre-build build post-build build-api-docs test

travis: precommit

travis-deploy:
	@echo "Deploy the software by travis"
	@make build-release
	@make release


clean: clean-api-docs
	@echo "Cleaning the build..."
	@rm -rf src/_build/dev/lib/ocap_service

watch:
	@make build
	@echo "Watching templates and slides changes..."
	@fswatch -o src/ | xargs -n1 -I{} make build

run:
	@echo "Running the software..."
	@cd src; iex -S mix phx.server

submodule:
	@git submodule update --init --recursive

rebuild-deps:
	@cd src; rm -rf mix.lock; rm -rf deps/{goldorin,utility_belt,ocap_schema,ocap_rpc};
	@make dep

build-run:
	@make build
	@make run
include .makefiles/*.mk

.PHONY: build init travis-init install dep pre-build post-build all test doc precommit travis clean watch run bump-version create-pr submodule build-release
