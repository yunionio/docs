OUTPUT_DIR := "./_output"

run-all: clean
	./collect-input.py ../content/zh/docs $(OUTPUT_DIR)

run-all-en: clean
	./collect-input.py ../content/en/docs $(OUTPUT_DIR)

run-admin: clean
	./collect-input.py ../content/zh/docs $(OUTPUT_DIR) admin

run-admin-en: clean
	./collect-input.py ../content/en/docs $(OUTPUT_DIR) admin

run-faq: clean
	./collect-input.py ../content/zh/docs $(OUTPUT_DIR) faq

run-faq-en: clean
	./collect-input.py ../content/en/docs $(OUTPUT_DIR) faq

run-quick: clean
	./collect-input.py ../content/zh/docs $(OUTPUT_DIR) quick

run-quick-en: clean
	./collect-input.py ../content/en/docs $(OUTPUT_DIR) quick

run-quickuse: clean
	./collect-input.py ../content/zh/docs $(OUTPUT_DIR) quickuse

run-quickuse-en: clean
	./collect-input.py ../content/en/docs $(OUTPUT_DIR) quickuse

run-user: clean
	./collect-input.py ../content/zh/docs $(OUTPUT_DIR) user

run-user-en: clean
	./collect-input.py ../content/en/docs $(OUTPUT_DIR) user

clean:
	rm -rf $(OUTPUT_DIR)

gen-docx:
	(cd $(OUTPUT_DIR) && pandoc \
		--highlight-style breezedark \
		-f markdown -t docx *.md \
		-o output.docx)
	@echo "Generate to $(OUTPUT_DIR)/output.docx"

gen-all-docx: run-all gen-docx

# gen-all-docx-en: run-all-en gen-docx

# gen-admin-docx: run-admin gen-docx

# gen-admin-docx-en: run-admin-en gen-docx

# gen-faq-docx: run-faq gen-docx

# gen-faq-docx-en: run-faq-en gen-docx

# gen-quick-docx: run-quick gen-docx

# gen-quick-docx-en: run-quick-en gen-docx

# gen-quickuse-docx: run-quickuse gen-docx

# gen-quickuse-docx-en: run-quickuse-en gen-docx

# gen-user-docx: run-user gen-docx

# gen-user-docx-en: run-user-en gen-docx
