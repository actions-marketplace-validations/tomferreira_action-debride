#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group:: Installing debride with extensions ... https://github.com/seattlerb/debride'
# if 'gemfile' debride version selected
if [ "$INPUT_DEBRIDE_VERSION" = "gemfile" ]; then
  # if Gemfile.lock is here
  if [ -f 'Gemfile.lock' ]; then
    # grep for debride version
    DEBRIDE_GEMFILE_VERSION=$(ruby -ne 'print $& if /^\s{4}debride\s\(\K.*(?=\))/' Gemfile.lock)

    # if debride version found, then pass it to the gem install
    # left it empty otherwise, so no version will be passed
    if [ -n "$DEBRIDE_GEMFILE_VERSION" ]; then
      DEBRIDE_VERSION=$DEBRIDE_GEMFILE_VERSION
      else
        printf "Cannot get the debride's version from Gemfile.lock. The latest version will be installed."
    fi
    else
      printf 'Gemfile.lock not found. The latest version will be installed.'
  fi
  else
    # set desired debride version
    DEBRIDE_VERSION=$INPUT_DEBRIDE_VERSION
fi

gem install -N debride --version "${DEBRIDE_VERSION}"
echo '::endgroup::'

echo '::group:: Running debride with reviewdog 🐶 ...'
debride ${INPUT_DEBRIDE_FLAGS}  . |
  reviewdog 
    -efm="%*[\ ]%m%*[\ ]%f:%l" \
    -efm="%*[\ ]%m%*[\ ]%f:%l-%e" \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS}

exit_code=$?
echo '::endgroup::'

exit $exit_code