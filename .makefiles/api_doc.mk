DOC_DIR=./src/api_docs
ARCBLOCK_LOGO=./docs/logo.png
SLATE_DIR=$(DOC_DIR)/.shared/slate
IGNORES=.shared
DOCS=$(filter-out $(IGNORE), $(sort $(dir $(wildcard $(DOC_DIR)/*/.))))
PORT=8888

SCHEMAS=OcapService.GQL.Schema.Bitcoin OcapService.GQL.Schema.Ethereum

VERSION=$(strip $(shell cat version))
SCHEMA_PATH=../output

gen-schema:
	cd src; $(foreach schema, $(SCHEMAS), mix absinthe.schema.json $(SCHEMA_PATH)/$(schema).json --schema $(schema); mv $(SCHEMA_PATH)/$(schema).json $(SCHEMA_PATH)/$(patsubst OcapService.GQL.Schema.%,%,$(schema).json);)
	@echo "\nDone! Schema files are created in $(OUTPUT_DIR)/."

build-api-docs: $(OUTPUT_DIR) gen-schema
	@$(foreach dir,$(DOCS),$(MAKE) -C $(dir) build;)
	@cp $(ARCBLOCK_LOGO) $(OUTPUT_DIR)/bitcoin/images/
	@cp $(ARCBLOCK_LOGO) $(OUTPUT_DIR)/ethereum/images/
	@echo "All API docs are built."

all-api-docs: build-api-docs
	@aws s3 sync $(OUTPUT_DIR) s3://ocap-docs.arcblock.io --region us-west-2

api-doc-install:
	@echo "install dependencies for API doc"
	@cd $(SLATE_DIR); bundle install;

clean-api-docs:
	@rm -rf $(OUTPUT_DIR)
	@echo "All docs are cleaned."

$(OUTPUT_DIR):
	@mkdir -p $@

watch-api-docs:
	@make build-api-docs
	@echo "Watching templates and slides changes..."
	@fswatch -o $(DOC_DIR) | xargs -n1 -I{} make build-api-docs

run-api-docs:
	@http-server $(OUTPUT_DIR) -p $(PORT) -c-1
