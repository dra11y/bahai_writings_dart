# Changelog

(See notes on [Versioning](#versioning).)

## [0.1.0+240524] - 2024-07-16

### Added

- Initial release.

# Versioning

## SemVer+CalVer

This package uses a combination of [Semantic Versioning (SemVer)](https://semver.org/) and [Calendar Versioning (CalVer)](https://calver.org/) that is compatible with pub.dev.

- The *major*, *minor*, and *patch* numbers follow SemVer.

- The *build identifier* (after the `+`) follows CalVer in the pattern: `\d{6}[b-z]?` and represents the latest referenced **publication date** (NOT retrieval date) in the format: `yyMMdd + disambiguation`, of content retrieved from bahai.org, hence should, with high probability, remain idempotent.

- Thus, an update to the package API and/or code can result in the same *build identifier* for a different semantic version.
