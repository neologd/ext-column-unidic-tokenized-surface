#!/usr/bin/env bash

# Copyright (C) 2016 Toshinori Sato (@overlast)
#
#       https://github.com/neologd/ext-column-unidic-tokenized-surface
#
# Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

BASEDIR=$(cd $(dirname $0);pwd)
PROGRAM_NAME=generate-extension-for-mecab-unidic-neologd
ECHO_PREFIX="[${PROGRAM_NAME}] :"

IPADIC_NEOLOGD_BUILD_DIR=$1;

SEED_FILES=($(find ${IPADIC_NEOLOGD_BUILD_DIR} -name "neologd*.csv" -o -name "mecab-user-dict-seed*.csv"))

echo "${ECHO_PREFIX} Start.."

for SEED_FILE in ${SEED_FILES[@]}; do
    echo "${ECHO_PREFIX} Make an extension data using ${SEED_FILE}"
    ${BASEDIR}/../libexec/generate-unidic-tokenized-string.sh ${SEED_FILE}
done

echo "${ECHO_PREFIX} Finish !!"
