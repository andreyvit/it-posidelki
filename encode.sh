#!/bin/bash

# Based on Marco Arment's encoding script for atp.fm:
# https://gist.github.com/marcoarment/88da1a8c403fa103c6d0

# brew install lame mp3info
 
# Encode a WAV to a finalized podcast MP3 with metadata, in the current directory
# Requires lame
# With Homebrew on Mac OS X: brew install lame

cd ~/Recordings
 
SHOW_AUTHOR="АйТиПи"

SHOW_PREFIX="IT-posidelki-"
 
EPISODE_NUMBER=03
EPISODE_TITLE="iPhone Galaxy S6"
EPISODE_SUMMARY="Тактильные интерфейсы устройств, а также кто и почему может хотеть новый MacBook."
EPISODE_SAMPLE_RATE=44.1

EPISODE_NUMBER=04
EPISODE_TITLE="Бесконечный медитативный цикл"
EPISODE_SUMMARY="Тима закончил конверсию проекта из Subversion в Git, а Андрей портирует LiveReload на Swift 1.2 и размышляет о бесцельно потраченных на JavaScript годах."
EPISODE_SAMPLE_RATE=44.1

EPISODE_NUMBER=02
EPISODE_TITLE="Самый Air'ный Air изо всех Air'ов"
EPISODE_SUMMARY="Стратегия Microsoft одной ОС на всех платформах, почему покупателям нового MacBook не хватает просто iPad'а, изменения в Windows 10, а также разные API для написания интерфейсов пользователя."
EPISODE_SAMPLE_RATE=48

EPISODE_NUMBER=06
EPISODE_TITLE="Первое правило Эппл Ивентов"
EPISODE_SUMMARY="Глубокой ночью сразу после сентябрьского Apple Event; разговор пытается скатиться к SSL, HTTP и файрволам, хотя начинается с айпадов и стилусов."
EPISODE_SAMPLE_RATE=48

EPISODE_NUMBER=07
EPISODE_TITLE="Маленькая неудача"
EPISODE_SUMMARY="Наши впечатления от Windows 10, ее проблемы с приватностью, экосистемой и новым браузером."
EPISODE_SAMPLE_RATE=44.1

EPISODE_NUMBER=08
EPISODE_TITLE="(А)моральная реклама"
EPISODE_SUMMARY="Обсуждаем эстафету топовых Ad Blocker-ов под IOS и моральные аспекты блокировки рекламы в целом."
EPISODE_SAMPLE_RATE=44.1


SHOW_PREFIX="AiTiPi-"

EPISODE_NUMBER=09
EPISODE_TITLE="Неинформированное согласие"
EPISODE_SUMMARY="Пилотный эпизод нового формата, обсуждающий дилемму телеметрии в стиле винды против стиля мака с айос, а также про самсунг, отпечатки пальцев, глюки скайпа, социалки против чатов, сяоми, активацию и прочие грехи майкрософта"
EPISODE_SAMPLE_RATE=44.1

EPISODE_NUMBER=10
EPISODE_TITLE="Нейромама спешиал"
EPISODE_SUMMARY="Специальный выпуск про нейромаму!"
EPISODE_SAMPLE_RATE=44.1

INPUT_WAV_FILE="${SHOW_PREFIX}0${EPISODE_NUMBER}.wav"
OUTPUT_MP3_FILE="${INPUT_WAV_FILE%%.wav}.mp3"

S3_BUCKET="files.tarantsov.com"
S3_PREFIX=""

# Artwork: ideally 1400x1400, but less than 128 KB to maximize compatibility
ARTWORK_JPG_FILENAME="${HOME}/Dropbox/АйТиПи/АйТиПи.png"
 
if true; then
    # Output quality (kbps): 96 or 64 recommended
    MP3_KBPS=96
     
    lame --noreplaygain -a --cbr -h -b $MP3_KBPS --resample $EPISODE_SAMPLE_RATE --tt "$EPISODE_NUMBER: $EPISODE_TITLE" --tc "$EPISODE_SUMMARY" --ta "$SHOW_AUTHOR" --ty `date '+%Y'` --ti "$ARTWORK_JPG_FILENAME" --add-id3v2 "$INPUT_WAV_FILE" "$OUTPUT_MP3_FILE"
fi

DURATION="$(mp3info -p "%m:%02s" "${OUTPUT_MP3_FILE}")"
URL="http://${S3_BUCKET}/${S3_PREFIX}/${OUTPUT_MP3_FILE}"
SIZE="$(stat -f '%z' "${OUTPUT_MP3_FILE}")"

cat <<END

---
number: "${EPISODE_NUMBER}"
title: "${EPISODE_TITLE}"
layout: episode
duration: "${DURATION}"
summary: "${EPISODE_SUMMARY}"
audio:
  name: ${OUTPUT_MP3_FILE}
  size: $SIZE
---

END

if true; then
    # echo s3cmd put -P "$OUTPUT_MP3_FILE" "s3://${S3_BUCKET}/${S3_PREFIX}"
    # s3cmd put -P "$OUTPUT_MP3_FILE" "s3://${S3_BUCKET}/${S3_PREFIX}"
    echo aws s3 cp --acl public-read "$OUTPUT_MP3_FILE" "s3://${S3_BUCKET}/${S3_PREFIX}"
    aws s3 cp --acl public-read "$OUTPUT_MP3_FILE" "s3://${S3_BUCKET}/${S3_PREFIX}"
fi
