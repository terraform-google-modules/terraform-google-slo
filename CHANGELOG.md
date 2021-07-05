# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v1.0.3...v2.0.0) (2021-07-05)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#85)

### Features

* add Terraform 0.13 constraint and module attribution ([#85](https://www.github.com/terraform-google-modules/terraform-google-slo/issues/85)) ([6de1459](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/6de14595e8292ac2be1762f7f19e4709ddeb31f2))

### [1.0.3](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v1.0.2...v1.0.3) (2021-05-05)


### Bug Fixes

* add error_budget_policy as SLO module output ([2143534](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/2143534a1aadeff73735446bc736310b91b2b945))

### [1.0.2](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v1.0.1...v1.0.2) (2021-02-26)


### Bug Fixes

* add ability to disable logs-writer iam ([96aa353](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/96aa353b205e67e757f4a7e0c503f6ce07e5c93d))
* add ability to disable logs-writer iam ([96aa353](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/96aa353b205e67e757f4a7e0c503f6ce07e5c93d))

### [1.0.1](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v1.0.0...v1.0.1) (2020-11-27)


### Bug Fixes

* SLO Pipeline IAM roles ([07890d9](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/07890d9731212f3b436dc5f90b55c2e7a514af96))

## [1.0.0](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v0.3.2...v1.0.0) (2020-11-16)


### ⚠ BREAKING CHANGES

* Add metadata labels

### Features

* Add metadata labels ([db432a0](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/db432a0339e8957f687b70d356c29c6eb3e42d61))
* custom GCF name for SLO module ([b2aa6bf](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/b2aa6bf4bd5227765d37ac2b2a3b3e0a93391196))
* update slo-generator to 1.4.0 ([afdc43b](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/afdc43b269fba7ac681ace7bec9b349c3e90c0b3))


### Bug Fixes

* GCS improvements ([#65](https://www.github.com/terraform-google-modules/terraform-google-slo/issues/65)) ([0691d79](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/0691d7950b9ff3fca49f748c33b10acde32fb208))
* prevent updating / recreating GCF when SLO configs change ([161dbe4](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/161dbe4fe7079214bec7543a670df6859567b636))
* SLO pipeline updating constantly (local files) ([524909c](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/524909c7b7876e3be5fe836ce306159872d6b14b))
* Terraform variable validation ([f5e6c00](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/f5e6c003527fe80fdbcb0cabfba07e9601e65f2b))

### [0.3.2](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v0.3.1...v0.3.2) (2020-10-23)


### Bug Fixes

* Add GCF timeout + memory ([495a2ca](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/495a2ca9200aaa095b3a89cff182619c31163d96))
* update slo-generator to v1.3.2 ([d50b09e](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/d50b09e9119749c7fa06ab36516c7fd0573343f0))

### [0.3.1](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v0.3.0...v0.3.1) (2020-10-23)


### Bug Fixes

* Update slo-generator to v1.3.1 ([e602495](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/e6024958ed629598b809f575b86e73c0d7654143))

## [0.3.0](https://www.github.com/terraform-google-modules/terraform-google-slo/compare/v0.2.2...v0.3.0) (2020-10-21)


### Features

* upgrade slo-generator to version 1.2.0 ([5796e77](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/5796e7799d2057db0befa990d0aa8ce16e8107f5))
* upload SLO configs to GCS, support VPC connector ([e35ab7a](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/e35ab7af17ec67521a9a2ce77b0e33941aa9e90e))


### Bug Fixes

* GCS links in GCF ([37ce07f](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/37ce07ff846f81563e6a4f8d5df672e9ceed804c))
* GCS object path ([f06f041](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/f06f041ba5b076d5d6b99ca682bd8078e5637d86))
* Revert [#24](https://www.github.com/terraform-google-modules/terraform-google-slo/issues/24) as it triggers duplicate logs in Cloud Logging ([05296bc](https://www.github.com/terraform-google-modules/terraform-google-slo/commit/05296bcb181d0f6fc2e28d8438b76d0aab01bc57))

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
