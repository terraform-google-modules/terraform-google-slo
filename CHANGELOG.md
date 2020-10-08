# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [0.2.2](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v0.2.1...v0.2.2) (2020-10-08)


### Bug Fixes

* upgrade defaut slo-generator version to 1.1.2 [[#46](https://www.github.com/terraform-google-modules/terraform-google-slo/issues/46)] ([f16b8d6](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/f16b8d6b9611c14636dffa1e20efb19f79e2932b))

### Features
* Add dataset_create flag to skip creation if already exists [[#48](https://github.com/terraform-google-modules/terraform-google-slo/pull/48)] ([638078d](https://github.com/terraform-google-modules/terraform-google-slo/commit/638078df81cd78f404994ab51db21a6920f11940))

### [0.2.1](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v0.2.0...v0.2.1) (2020-09-22)


### Bug Fixes

* Correct example `table_name` to `table_id` ([#36](https://www.github.com/terraform-google-modules/terraform-google-slo/issues/36)) ([adfc671](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/adfc6714f830b581c529723895e9242f197e26ef))
* README broken links ([54486eb](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/54486ebfa95f1b410b8eeca0e5ed45f8b2382364))
* SLO IAM roles for Service Monitoring ([12951a0](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/12951a01282817366dd3f77d6f83fbf3689cf4ec))
* TF variable validation for backend so we can use other backends ([#43](https://www.github.com/terraform-google-modules/terraform-google-slo/issues/43)) ([e3dd0cb](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/e3dd0cb72150e1d6ba14881e247f0a909af2b5bd))

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
