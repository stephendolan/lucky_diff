# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LuckyDiff is a Crystal/Lucky Framework application that compares different versions of Lucky framework scaffolded apps. It displays diffs between versions to help developers understand changes between Lucky releases. This app does not use a database.

## Requirements

- **Crystal**: 1.16.3 or higher (via asdf or similar)
- **Lucky Framework**: 1.4.0
- **Browser**: Chrome, Chromium, or Firefox (only needed for flow tests)

## Development Commands

### Setup
```bash
./script/setup  # Install dependencies and prepare the project
asdf install crystal 1.16.3  # If using asdf for Crystal version management
```

### Running the Application
```bash
crystal run tasks.cr -- dev  # Start development server
# Or the shorter alias if configured:
lucky dev
```

### Asset Compilation
```bash
# Development (with watching)
yarn build:js && yarn watch:js
yarn build:css && yarn watch:css

# Production
yarn prod  # Builds and minifies both JS and CSS
```

### Testing
```bash
crystal spec  # Run all tests (requires browser for flow tests)
crystal spec spec/spec_helper_spec.cr  # Skip flow tests if no browser installed

# If chromedriver version mismatch occurs:
rm -rf ~/.webdrivers/  # Force LuckyFlow to download correct version
```

### Linting
```bash
bin/ameba  # Crystal linter (using master branch for Crystal 1.16.3 compatibility)
bin/ameba --fix  # Auto-fix correctable issues
```


### Adding New Lucky Versions
```bash
./script/create_new_version vx.x.x  # Creates a new version directory
# Then add the version to src/models/version.cr SUPPORTED_VERSIONS array
```

## Architecture

### Core Structure
- **Lucky Framework**: Web framework built on Crystal
- **Actions**: Handle HTTP requests (`src/actions/`)
  - `Home::Index` - Main diff comparison page
  - `Commits::Index` - Shows GitHub commits between versions
- **Pages**: HTML views using Lucky's type-safe HTML DSL (`src/pages/`)
- **Models**: Domain objects (`src/models/`)
  - `Version` - Manages supported Lucky versions
  - `GitHub::*` - Models for GitHub API integration

### Version Storage
- Generated Lucky apps are stored in `/generated/` directory
- Each version has its own subdirectory (e.g., `/generated/1.4.0/`)
- Diffs are generated on-the-fly using system `diff` command

### Frontend
- **Stimulus.js**: JavaScript framework for interactivity
- **Tailwind CSS**: Utility-first CSS framework
- **diff2html**: Library for rendering diffs in HTML format
- Assets compiled with esbuild (JS) and Tailwind CLI (CSS)

### Key Implementation Details
- The app compares two versions by running `diff` on their respective directories
- Diff output is sanitized to remove directory paths for cleaner display
- Version validation ensures only existing versions can be compared
- GitHub API integration fetches commit information between version tags

## Upgrade Notes (Lucky 1.4.0 / Crystal 1.16.3)

### Dependencies
- Use `lucky_env: ~> 0.3.0` (not 0.2.0)
- Ameba 1.6.x has issues with Crystal 1.16.3 - use master branch: `github: crystal-ameba/ameba, branch: master`
- LuckyFlow automatically manages chromedriver downloads - no need to install manually

### Breaking Changes Fixed
- Removed `Lucky::CatchUnpermittedAttribute` (no longer exists in Lucky 1.4)
- Updated error handling: `error.renderable_message` → `error.message || DEFAULT_MESSAGE`
- LuckyFlow API changes: `visit Action` → `visit Action.path`
- Removed deprecated `LuckyFlow::Server::INSTANCE.reset`

### Testing Configuration
- Spec files should NOT have `_spec.cr` suffix in `spec/setup/` directory
- LuckyFlow requires a real browser installed (Chrome, Chromium, or Firefox)
- The webdrivers shard automatically downloads matching chromedriver
- If version mismatch occurs, delete `~/.webdrivers/` to force re-download

### Common Issues
- **macOS diff**: The app uses GNU diff options not available on macOS (e.g., `--ignore-tab-expansion`)
- **Browser requirement**: Flow tests need an actual browser, not just the driver
- **Ameba false positives**: Configure `.ameba.yml` to disable `Lint/UselessAssign` for Lucky's `needs` macro

### Key Implementation Details
- The app compares two versions by running `diff` on their respective directories
- Diff output is sanitized to remove directory paths for cleaner display
- Version validation ensures only existing versions can be compared
- GitHub API integration fetches commit information between version tags