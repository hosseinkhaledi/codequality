# GitLab CodeQuality changelog

GitLab Code Quality versions follow the Code Climate versions used, and generate a `[CODE_CLIMATE_VERSION]-gitlab.[CHANGE_INCREMENT]` [Docker image](https://gitlab.com/gitlab-org/ci-cd/codequality/container_registry). Versioning before `0.85.5` was based on major GitLab versions, and was deprecated after GitLab `12.4`.

## master (unreleased)

## 0.85.10

- Add jest test pattern to excluded patterns of code climate (!14)

## 0.85.9-gitlab.2

- Add support for overriding the memory limit via the `ENGINE_MEMORY_LIMIT_BYTES` env variable

## 0.85.9-gitlab.1

- Add temporary support for overriding the CodeClimate image used via the `CODECLIMATE_IMAGE` env variable

## 0.85.9

## 0.85.9

## 0.85.8

## 0.85.7 (skipped)

## 0.85.6

## 0.85.5

- This marks the start of the new versioning scheme
- Ignore minified files (`*.min.js`, `*.min.css`)
- Suppress the progress of downloading layers on running codeclimate image
- Run engines:install separately before analyze to avoid timing out

## 12-4-stable

- Upgrade Code Climate to 0.85.5

## 12-3-stable

## 12-2-stable

## 12-1-stable

- Fix TIMEOUT_SECONDS setting
- Add optional variable `CODECLIMATE_DEV` to enable Code Climate development mode
- Add optional variable `REPORT_STDOUT` to print the result to `STDOUT` instead of generating the usual report file

## 12-0-stable

- Upgrade Code Climate to 0.85.4

## 11-10-stable

- Upgrade Code Climate to 0.85.1
- Update Code Climate default excludes
- Add optional variable `CODECLIMATE_DEBUG` to enable Code Climate debug logging

## 11-9-stable

- Upgrade Code Climate to 0.83.0

## 11-8-stable

## 11-7-stable

## 11-6-stable

## 11-5-stable

## 11-4-stable

## 11-3-stable

## 11-2-stable

## 11-1-stable

## 11-0-stable

- Upgrade Code Climate to 0.72.0
- **Breaking Change:** rename report file from `codeclimate.json` to `gl-code-quality-report.json`

## 10-8-stable

- Update to Code Climate 0.71.2
- Add optional variable `TIMEOUT_SECONDS` to allow user to give a custom timeout for the `codeclimate analyze` command

## 10-7-stable

- Fix code climate issue type filter
- Check all supported config files before copying defaults

## 10-6-stable

- Initial release

## 10-5-stable

- **Backport:** Initial release

## 10-4-stable

- **Backport:** Initial release
