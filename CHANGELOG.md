# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v0.1.0...v0.2.0) (2020-09-16)


### Features

* Add support for native SLOs ([#33](https://www.github.com/terraform-google-modules/terraform-google-slo/issues/33)) ([55b2319](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/55b23194494273ddb968ed1a39d5e32894b14a85))


## 0.1.0 (2020-05-12)

### Fixed

* Updating SLO configs now correctly re-deploys Cloud Functions. Fixes [#7]
* Allow to use a custom service account in both modules. Fixes [#13]
* Upgrade to latest slo-generator version. Fixes [#14]

### Added

* Added random suffix to bucket names to allow easy recreation. [#3]
* Initial release

[unreleased]: https://github.com/terraform-google-modules/terraform-google-slo/compare/v0.1.0...HEAD

[0.1.0]: https://github.com/terraform-google-modules/terraform-google-slo/releases/tag/v0.1.0

[#3]: https://github.com/terraform-google-modules/terraform-google-slo/pull/3
