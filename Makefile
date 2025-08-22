SHELL := /bin/bash

.PHONY: help get analyze format test test-integration clean doctor ci prepare hook-install hook-uninstall hook-install-all protect-main fix-arb

help:
	@echo "Common Flutter tasks:" && \
	echo "  make get              # flutter pub get" && \
	echo "  make analyze          # flutter analyze" && \
	echo "  make format           # dart format ." && \
	echo "  make prepare          # get + format + analyze" && \
	echo "  make hook-install     # install pre-commit hook (prepare)" && \
	echo "  make hook-install-all # install pre-commit + commit-msg hooks" && \
	echo "  make hook-uninstall   # remove pre-commit hook" && \
	echo "  make protect-main     # apply GitHub branch protection via gh" && \
	echo "  make fix-arb          # normalize ARB files (format/sort/metadata)" && \
	echo "  make test             # flutter test -r compact" && \
	echo "  make test FILE=path   # flutter test -r compact <path>" && \
	echo "  make test-integration # flutter test integration_test -r compact" && \
	echo "  make clean            # flutter clean" && \
	echo "  make doctor           # flutter doctor -v" && \
	echo "  make ci               # get + analyze + test"

get:
	flutter pub get

analyze:
	flutter analyze

format:
	@if command -v dart >/dev/null 2>&1; then \
		dart format . ; \
	else \
		flutter format . ; \
	fi

test:
	@if [ -n "$(FILE)" ]; then \
		flutter test -r compact $(FILE) ; \
	else \
		flutter test -r compact ; \
	fi

test-integration:
	flutter test integration_test -r compact

clean:
	flutter clean

doctor:
	flutter doctor -v

ci: get analyze test

prepare: get format analyze

hook-install:
	@mkdir -p .git/hooks
	cp scripts/hooks/pre-commit.sh .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "Installed Git pre-commit hook to run 'prepare'"

hook-uninstall:
	@rm -f .git/hooks/pre-commit
	@echo "Removed Git pre-commit hook"

hook-install-all: hook-install
	@mkdir -p .git/hooks
	cp scripts/hooks/commit-msg.sh .git/hooks/commit-msg
	chmod +x .git/hooks/commit-msg
	@echo "Installed commit-msg hook (Conventional Commits)"

protect-main:
	@echo "Applying branch protection to main via GitHub CLI..."
	@bash scripts/protect_main_branch.sh

fix-arb:
	bash scripts/fix_arb.sh
