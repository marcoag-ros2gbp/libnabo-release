#!/bin/bash
#
# Build and run docker container for testing build system user script.
#   - Image:      nabo.ubuntu20.buildsystem.test
#   - Container:  IamBuildSystemTester
#
# Usage:
#   $ bash ./[build_system/[tests/]]build_and_run_IamBuildSystemTester.bash [<cmd+arg appended to docker run tail>]
#
set -e
#set -v
#set -x

DOCKER_CMD_ARGS=${*}

clear

TMP_CWD=$(pwd)

# ....Helper function..............................................................................
if [[ "$(basename $(pwd))" == "tests" ]]; then
  cd ../
fi

# ....path resolution logic........................................................................
_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
NABO_ROOT_DIR="$(dirname "${_PATH_TO_SCRIPT}")/../../.."
cd "${NABO_ROOT_DIR}"

set -o allexport && source ./build_system/.env && set +o allexport

# ....Helper function..............................................................................................
# import shell functions from utilities library
source "./build_system/utilities/norlab-shell-script-tools/import_norlab_shell_script_tools_lib.bash"

# ====Begin========================================================================================
print_formated_script_header 'build_and_run_IamBuildSystemTester.bash' "${MSG_LINE_CHAR_TEST}"

# ....Build image..................................................................................
echo
print_msg "Building 'nabo.ubuntu20.buildsystem.test'"
# Note: Build context must be at repository root

pwd
tree -L 1 -a

show_and_execute_docker "build -f build_system/tests/tests_docker_interactive/Dockerfile.build_system_test -t nabo.ubuntu20.buildsystem.test ."
#--no-cache

# ....Run container................................................................................
print_msg "Starting 'IamBuildSystemTester'"

if [[ -n ${DOCKER_CMD_ARGS} ]]; then
  print_msg "Passing command ${MSG_DIMMED_FORMAT}\"${DOCKER_CMD_ARGS}\"${MSG_END_FORMAT} to docker run"
fi

show_and_execute_docker "run --name IamBuildSystemTester -it --rm nabo.ubuntu20.buildsystem.test ${DOCKER_CMD_ARGS}"

print_formated_script_footer 'build_and_run_IamBuildSystemTester.bash' "${MSG_LINE_CHAR_TEST}"
# ====Teardown=====================================================================================
cd "${TMP_CWD}"
