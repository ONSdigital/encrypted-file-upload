OSSINDEX_ERRORS = "Unable to contact OSS Index|authentication failed|401 Unauthorized|403 Forbidden|429 Too Many Requests|Too many requests|Rate limit|Unknown host|Connection refused|timed out|unreachable|402 Payment Required"

.PHONY: all
all: audit test build lint

.PHONY: audit
audit:
	@echo "🔍 Running OSS Index audit for encrypted-file-upload"
	@mkdir -p target
	@mvn ossindex:audit > target/ossindex-audit-encrypted-file-upload.log 2>&1; status=$$?; \
	cat target/ossindex-audit-encrypted-file-upload.log; \
	[ $$status -eq 0 ] && grep -Eiqn $(OSSINDEX_ERRORS) target/ossindex-audit-encrypted-file-upload.log && \
		{ echo "❌ OSS Index API/auth/network error (CMS) — see target/ossindex-audit-encrypted-file-upload.log"; exit 1; }; \
	exit $$status

.PHONY: build
build:
	mvn clean package -Dmaven.test.skip -Dossindex.skip=true

.PHONY: test
test:
	mvn -Dossindex.skip=true test

.PHONY: lint
lint:
	exit

