# Publish a patch release (0.1.0 → 0.1.1)
patch:
    npm version patch
    git push && git push --tags

# Publish a minor release (0.1.0 → 0.2.0)
minor:
    npm version minor
    git push && git push --tags

# Publish a major release (0.1.0 → 1.0.0)
major:
    npm version major
    git push && git push --tags

# Test the installer locally
test-install:
    node bin/install.mjs

# Test the uninstaller locally
test-uninstall:
    node bin/install.mjs uninstall
