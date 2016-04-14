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
PROGRAM_NAME=generate-unidic-tokenized-string
ECHO_PREFIX="[${PROGRAM_NAME}] :"

UNIDIC_DIR=`mecab-config --dicdir`"/unidic"
MECAB_COMMAND="mecab -d ${UNIDIC_DIR} -Owakati"

TMP_MECAB_RESULT=$BASEDIR/../extension/tmp_unidic_tokenized_surface
TMP_SEED_SURFACE_POSID=$BASEDIR/../extension/tmp_surface_posid

SEED_DATA=$1

echo "${ECHO_PREFIX} Start.."

SEED_NAME_PREFIX=`echo ${SEED_DATA##*/} | cut -d $'.' -f 1,1`
echo "${ECHO_PREFIX} ${SEED_NAME_PREFIX} is there"

echo "${ECHO_PREFIX} Make key to join"
cat ${SEED_DATA} | cut -d $',' -f 1,2 > ${TMP_SEED_SURFACE_POSID}

echo "${ECHO_PREFIX} Get tokenizing result using UniDic"
cat ${SEED_DATA} | cut -d $',' -f 1,1 | ${MECAB_COMMAND} > ${TMP_MECAB_RESULT}

echo "${ECHO_PREFIX} Merge keys and tokenizing results"
paste ${TMP_SEED_SURFACE_POSID} ${TMP_MECAB_RESULT} > $BASEDIR/../extension/${SEED_NAME_PREFIX}.tsv

echo "${ECHO_PREFIX} Sort and Uniq"
LC_ALL=C sort $BASEDIR/../extension/${SEED_NAME_PREFIX}.tsv > $BASEDIR/../extension/${SEED_NAME_PREFIX}.tsv.sort
LC_ALL=C uniq $BASEDIR/../extension/${SEED_NAME_PREFIX}.tsv.sort > $BASEDIR/../extension/${SEED_NAME_PREFIX}.tsv
rm $BASEDIR/../extension/${SEED_NAME_PREFIX}.tsv.sort

echo "${ECHO_PREFIX} Compress the extension files"
xz -9 $BASEDIR/../extension/${SEED_NAME_PREFIX}.tsv

echo "${ECHO_PREFIX} Remove temp files"
rm ${TMP_MECAB_RESULT}
rm ${TMP_SEED_SURFACE_POSID}

echo "${ECHO_PREFIX} Finish !!"
