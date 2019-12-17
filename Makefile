.PHONY: cleanup test

test: cleanup
	swift test

cleanup:
	-rm -rf .build
	-rm -rf Package.resolved