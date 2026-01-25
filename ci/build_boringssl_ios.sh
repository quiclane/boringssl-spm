#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/build-out"
UP="$ROOT/_upstream/boringssl"
rm -rf "$ROOT/_upstream" "$OUT"
mkdir -p "$ROOT/_upstream" "$OUT"
REPO="$(sed -n 's/^repo=//p' "$ROOT/ci/boringssl-upstream.txt")"
BRANCH="$(sed -n 's/^branch=//p' "$ROOT/ci/boringssl-upstream.txt")"
git clone --depth 1 --branch "$BRANCH" "$REPO" "$UP"
cd "$UP"
git rev-parse --short HEAD > "$OUT/boringssl_rev.txt"

build_one(){ local SDK="$1";local ARCH="$2";local TAG="$3";local BDIR="$OUT/$TAG";rm -rf "$BDIR";mkdir -p "$BDIR";cmake -S . -B "$BDIR" -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_SYSROOT="$SDK" -DCMAKE_OSX_ARCHITECTURES="$ARCH" -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=OFF -DBORINGSSL_ALLOW_CXX_RUNTIME=ON;cmake --build "$BDIR";}

build_one iphoneos arm64 ios_arm64
build_one iphonesimulator arm64 sim_arm64
build_one iphonesimulator x86_64 sim_x86_64

mkdir -p "$OUT/fat_sim"
lipo -create "$OUT/sim_arm64/ssl/libssl.a" "$OUT/sim_x86_64/ssl/libssl.a" -output "$OUT/fat_sim/libssl.a"
lipo -create "$OUT/sim_arm64/crypto/libcrypto.a" "$OUT/sim_x86_64/crypto/libcrypto.a" -output "$OUT/fat_sim/libcrypto.a"

mkdir -p "$OUT/Headers"
rsync -a --delete "$UP/include/" "$OUT/Headers/"

rm -rf "$OUT/BoringSSL.xcframework"
xcodebuild -create-xcframework \
  -library "$OUT/ios_arm64/ssl/libssl.a" -headers "$OUT/Headers" \
  -library "$OUT/ios_arm64/crypto/libcrypto.a" -headers "$OUT/Headers" \
  -library "$OUT/fat_sim/libssl.a" -headers "$OUT/Headers" \
  -library "$OUT/fat_sim/libcrypto.a" -headers "$OUT/Headers" \
  -output "$OUT/BoringSSL.xcframework"

cd "$OUT"
rm -f BoringSSL.xcframework.zip
/usr/bin/zip -qry BoringSSL.xcframework.zip BoringSSL.xcframework
