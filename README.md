# GitHub Action: Run debride with reviewdog :dog:

[![Test](https://github.com/tomferreira/action-debride/workflows/Test/badge.svg)](https://github.com/tomferreira/action-debride/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/tomferreira/action-debride/workflows/reviewdog/badge.svg)](https://github.com/tomferreira/action-debride/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/tomferreira/action-debride/workflows/depup/badge.svg)](https://github.com/tomferreira/action-debride/actions?query=workflow%3Adepup)
[![release](https://github.com/tomferreira/action-debride/workflows/release/badge.svg)](https://github.com/tomferreira/action-debride/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tomferreira/action-debride?logo=github&sort=semver)](https://github.com/tomferreira/action-debride/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

![github-pr-review demo](https://user-images.githubusercontent.com/3797062/73162963-4b8e2b00-4132-11ea-9a3f-f9c6f624c79f.png)
![github-pr-check demo](https://user-images.githubusercontent.com/3797062/73163032-70829e00-4132-11ea-8481-f213a37db354.png)

This action runs [debride](https://github.com/seattlerb/debride) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

## Input

### `github_token`

`GITHUB_TOKEN`. Default is `${{ github.token }}`.

### `debride_version`

Optional. Set debride version. Possible values:
* empty or omit: install latest version
* `gemfile`: install version from Gemfile (`Gemfile.lock` should be presented, otherwise it will fallback to latest bundler version)
* version (e.g. `1.9.0`): install said version

### `debride_flags`

Optional. debride flags. (debride `<debride_flags>`).

### `tool_name`

Optional. Tool name to use for reviewdog reporter. Useful when running multiple
actions with different config.

### `level`

Optional. Report level for reviewdog [`info`, `warning`, `error`].
It's same as `-level` flag of reviewdog.

### `reporter`

Optional. Reporter of reviewdog command [`github-pr-check`, `github-check`, `github-pr-review`].
The default is `github-pr-check`.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [`added`, `diff_context`, `file`, `nofilter`].
Default is `added`.

### `fail_on_error`

Optional.  Exit code for reviewdog when errors are found [`true`, `false`].
Default is `false`.

### `reviewdog_flags`

Optional. Additional reviewdog flags.

### `workdir`

Optional. The directory from which to look for and run debride. Default `.`.

## Example usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  debride:
    name: runner / debride
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.0.0
      - name: debride
        uses: tomferreira/action-debride@v1
        with:
          debride_version: gemfile
          # Change reviewdog reporter if you need [github-check,github-pr-review,github-pr-check].
          reporter: github-pr-review
```
