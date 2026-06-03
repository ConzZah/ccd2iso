#!/usr/bin/env sh

### /// ccd2iso.sh // ConzZah // 2026-06-03 23:33 /// ###

## this is a build script for ccd2iso,
## the reason i wrote this is simple:
## ccd2iso always works when trying
## to convert cd-based ps2 games to iso, bchunk often doesn't.
## i just wanted to provide a quick way to build ccd2iso.

## === PLEASE NOTE ===
## ccd2iso was NOT written by me!!
## i just wrote the build script,
## and added a missing include.

## the original authors are:
## Danny Kurniawan <danny_kurniawan@users.sourceforge.net>
## Kerry Harris <tomatoe-source@users.sourceforge.net>

DEPS="sha1sum curl make gcc cut 7z"

for DEP in $DEPS; do
! command -v "$DEP" >/dev/null && \
printf '\n%s\n\n' "--> ERROR: $DEP MISSING. PLS INSTALL $DEP & TRY AGAIN." && exit 1
done

## find out where the script is located and cd to it
wd=""; wd="$(cd "$(dirname "$0")" && pwd)"
cd "$wd" || exit 1

## download ccd2iso's sauce code, if it's not there
[ ! -f "ccd2iso-0.3.7z" ] && \
curl -sLo "ccd2iso-0.3.7z" "https://github.com/ConzZah/ccd2iso/raw/refs/heads/main/ccd2iso-0.3.7z"

## check if sha1sum matches
[ "$(sha1sum "ccd2iso-0.3.7z"| cut -d ' ' -f 1)" != "9c51695bcf4028ee5c95cb0f5da62a3496c67958" ] && \
printf '\n%s\n\n' "ERROR: SHA1 DOESN'T MATCH!" && { rm "ccd2iso-0.3.7z"; exit 1 ;}

## extract the sauce
7z x -y "ccd2iso-0.3.7z"

## begin the build process
cd "src" || exit 1
sh configure && make || exit 1
cd - >/dev/null || exit 1

## copy the resulting executable to $wd
cp "src/src/ccd2iso" "${wd}"

## clean up
rm -rf "src"
