# GitLab Code Quality

[![pipeline status](https://gitlab.com/gitlab-org/ci-cd/codequality/badges/master/pipeline.svg)](https://gitlab.com/gitlab-org/ci-cd/codequality/commits/master)
[![coverage report](https://gitlab.com/gitlab-org/ci-cd/codequality/badges/master/coverage.svg)](https://gitlab.com/gitlab-org/ci-cd/codequality/commits/master)

GitLab tool for running Code Quality checks on provided source code.
It is currently based on CodeClimate only, but this may change in the future.

## How to use

1. `cd` into the directory of the source code you want to scan
1. Run the Docker image:

   ```sh
   docker run \
     --env SOURCE_CODE="$PWD" \
     --volume "$PWD":/code \
     --volume /var/run/docker.sock:/var/run/docker.sock \
     registry.gitlab.com/gitlab-org/ci-cd/codequality:${VERSION:-latest} /code
   ```

   `VERSION` can be replaced with the latest available release matching your GitLab version. See [Versioning](#versioning-and-release-cycle) for more details.

1. The results will be stored in the `gl-code-quality-report.json` file in the application directory.

**Why mounting the Docker socket?**

Some tools require to be able to launch Docker containers to scan your application.

### Environment variables

Code Quality can be configured with environment variables, here is a list:

| Name              | Function                                                                                                  |
| ----------------- | --------------------------------------------------------------------------------------------------------- |
| SOURCE_CODE       | Path to the source code to scan                                                                           |
| TIMEOUT_SECONDS   | Custom timeout for the `codeclimate analyze` command                                                      |
| CODECLIMATE_DEBUG | Set to enable [Code Climate debug mode](https://github.com/codeclimate/codeclimate#environment-variables) |
| CODECLIMATE_DEV   | Set to enable `--dev` mode which lets you run engines not known to the CLI.                               |
| REPORT_STDOUT     | Set to print the report to `STDOUT` instead of generating the usual report file.                          |

### Configuration

GitLab Code Quality comes with some default engines enabled and [default configurations](./codeclimate_defaults) but we encourage you to customize them to your own needs.
Please refer to [CodeClimate documentation](https://docs.codeclimate.com/docs/configuring-your-analysis) to learn more.

## Versioning and release cycle

GitLab Code Quality versions follow the Code Climate versions used and is available as a Docker image.

For example, if the current version of Code Climate used is `0.85.5` and there are no other changes introduced yet to Code Quality, the image would be:

- `registry.gitlab.com/gitlab-org/ci-cd/codequality:0.85.5`

If there are changes made but the Code Climate version is still `0.85.5`, the image would then have the appended incremental version:

- `registry.gitlab.com/gitlab-org/ci-cd/codequality:0.85.5-gitlab.1`

When we update to a newer version of Code Climate, we restart the version without the appended `-gitlab.x`. For example, if there is a version `0.99.1` released:

- `registry.gitlab.com/gitlab-org/ci-cd/codequality:0.99.1`

### Old Versioning Scheme

GitLab Code Quality used to follow the versioning of GitLab (`MAJOR.MINOR` versions only, like `12.4`) with images tagged with `MAJOR-MINOR-stable`.

For those who are not able to migrate yet to the new versioning scheme, we released images for `12-5-stable`, `12-6-stable`, `12-7-stable`, `12-8-stable`, `12-9-stable`, `12-10-stable` that
are copies of `12-4-stable`. Please note that we will not backport future modifications to these old versions.

Please note that the Auto-DevOps feature automatically uses the correct version. If you have your own `.gitlab-ci.yml` in your project, please ensure you are up-to-date with the [Auto-DevOps template](https://gitlab.com/gitlab-org/gitlab-ci-yml/blob/master/Auto-DevOps.gitlab-ci.yml).

# Contributing

If you want to help and extend the list of supported scanners, read the
[contribution guidelines](CONTRIBUTING.md).
