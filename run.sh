#!/bin/sh

usage="$(basename "$0") [-h] <app_path>

where:
    -h  show this help text
    app_path The path to the source code of the project you want to analyze."

while getopts 'h' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

if [ $# -ne 1 ] ; then
  echo "$usage"
  exit
fi

APP_PATH=$1
REPORT_FILENAME="gl-code-quality-report.json"
DEFAULT_FILES_PATH=${DEFAULT_FILES_PATH:-/codeclimate_defaults}
CODECLIMATE_VERSION=${CODECLIMATE_VERSION:-0.85.8}
CODECLIMATE_IMAGE="codeclimate/codeclimate:$CODECLIMATE_VERSION"
CONTAINER_TIMEOUT_SECONDS=${TIMEOUT_SECONDS:-900} # default to 15 min

if [ -z "$SOURCE_CODE" ] ; then
  echo "SOURCE_CODE env variable not set"
  exit
fi

# Copy default config files unless already present for csslint, eslint (ignore), rubocop and coffeelint
for config_file in .csslintrc .eslintignore .rubocop.yml coffeelint.json; do
  if [ ! -f  $APP_PATH/$config_file ] ; then
    cp $DEFAULT_FILES_PATH/$config_file $APP_PATH/
  fi
done

# Copy default config file unless already present for code climate
# NB: check for all supported config files
if ! [ -f  $APP_PATH/.codeclimate.yml -o -f $APP_PATH/.codeclimate.json ] ; then
  cp $DEFAULT_FILES_PATH/.codeclimate.yml $APP_PATH/
fi

# Copy default config file unless already present for eslint
# NB: check for all supported config files
if ! [ -f  $APP_PATH/.eslintrc.js -o -f $APP_PATH/.eslintrc.yaml -o -f $APP_PATH/.eslintrc.yml -o -f $APP_PATH/.eslintrc.json -o -f $APP_PATH/.eslintrc ] ; then
  cp $DEFAULT_FILES_PATH/.eslintrc.yml $APP_PATH/
fi

# Pull the code climate image in advance of running the container to
# suppress progress.  The `--quiet` option is not passed to support
# Docker 18.09 or earlier: https://github.com/docker/cli/pull/882
docker pull "$CODECLIMATE_IMAGE" > /dev/null

# We need to run engines:install before analyze to avoid hitting timeout errors.
# See: https://github.com/codeclimate/codeclimate/issues/866#issuecomment-418758879
# We also dump the output to a /dev/null to not mess up the result when REPORT_STDOUT is enabled.
docker run \
    --env CODECLIMATE_CODE="$SOURCE_CODE" \
    --env CODECLIMATE_DEBUG="$CODECLIMATE_DEBUG" \
    --env CONTAINER_TIMEOUT_SECONDS="$CONTAINER_TIMEOUT_SECONDS" \
    --volume "$SOURCE_CODE":/code \
    --volume /tmp/cc:/tmp/cc \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    "$CODECLIMATE_IMAGE" engines:install > /dev/null

if [ $? -ne 0 ]; then
    echo "Could not install code climate engines for the repository at $APP_PATH"
    exit 1
fi

# Run the code climate container.
# SOURCE_CODE env variable must be provided when launching this script. It allow
# code climate engines to mount the source code dir into their own container.
# TIMEOUT_SECONDS env variable is optional. It allows you to increase the timeout
# window for the analyze command.
# CODECLIMATE_DEBUG env variable is optional. It enables Code Climate debug
# logging.
docker run \
    --env CODECLIMATE_CODE="$SOURCE_CODE" \
    --env CODECLIMATE_DEBUG="$CODECLIMATE_DEBUG" \
    --env CONTAINER_TIMEOUT_SECONDS="$CONTAINER_TIMEOUT_SECONDS" \
    --volume "$SOURCE_CODE":/code \
    --volume /tmp/cc:/tmp/cc \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    "$CODECLIMATE_IMAGE" analyze ${CODECLIMATE_DEV:+--dev} -f json > /tmp/raw_codeclimate.json

if [ $? -ne 0 ]; then
    echo "Could not analyze code quality for the repository at $APP_PATH"
    exit 1
fi

# redirect STDOUT to disk (default), unless REPORT_STDOUT is set
if [ -z "$REPORT_STDOUT" ]; then
  exec > "$APP_PATH/$REPORT_FILENAME"
fi

# Only keep "issue" type
jq -c 'map(select(.type | test("issue"; "i")))' /tmp/raw_codeclimate.json
