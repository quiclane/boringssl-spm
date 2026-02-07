#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPDIR="$ROOT/_upstream/boringssl"
OUT="$ROOT/build-out"
SDK_IOS="$(xcrun --sdk iphoneos --show-sdk-path)"
SDK_SIM="$(xcrun --sdk iphonesimulator --show-sdk-path)"
git -C "$ROOT" submodule update --init --recursive
[ -d "$UPDIR" ]||{ echo "missing upstream at $UPDIR" >&2; exit 1; }
rm -rf "$OUT"
mkdir -p "$OUT"
build_one(){
  local name="$1" sysroot="$2" arch="$3"
  local dir="$OUT/$name"
  cmake -S "$UPDIR" -B "$dir" -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_SYSROOT="$sysroot" -DCMAKE_OSX_ARCHITECTURES="$arch" -DCMAKE_MACOSX_BUNDLE=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DOPENSSL_NO_ASM=OFF -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF -DCMAKE_SKIP_INSTALL_RULES=ON -DINSTALL_ENABLED=OFF -DBUILD_TOOL=OFF
  ninja -C "$dir" crypto ssl decrepit pki
}
build_one ios_arm64 "$SDK_IOS" arm64
build_one sim_arm64 "$SDK_SIM" arm64
build_one sim_x86_64 "$SDK_SIM" x86_64
mkdir -p "$OUT/fat_sim"
for a in crypto ssl decrepit pki; do lipo -create "$OUT/sim_arm64/lib${a}.a" "$OUT/sim_x86_64/lib${a}.a" -output "$OUT/fat_sim/lib${a}.a"; done
libtool -static -o "$OUT/libboringssl_ios_arm64.a" "$OUT/ios_arm64/libcrypto.a" "$OUT/ios_arm64/libssl.a" "$OUT/ios_arm64/libdecrepit.a" "$OUT/ios_arm64/libpki.a"
libtool -static -o "$OUT/libboringssl_sim.a" "$OUT/fat_sim/libcrypto.a" "$OUT/fat_sim/libssl.a" "$OUT/fat_sim/libdecrepit.a" "$OUT/fat_sim/libpki.a"
mkdir -p "$OUT/Headers/openssl"
rsync -a "$UPDIR/include/openssl/" "$OUT/Headers/openssl/"
for h in opensslconf.h; do if [ -f "$OUT/ios_arm64/include/openssl/$h" ]; then cp -f "$OUT/ios_arm64/include/openssl/$h" "$OUT/Headers/openssl/$h"; fi; done
rm -rf "$OUT/BoringSSL.xcframework" "$OUT/BoringSSL.xcframework.zip"
xcodebuild -create-xcframework -library "$OUT/libboringssl_ios_arm64.a" -headers "$OUT/Headers" -library "$OUT/libboringssl_sim.a" -headers "$OUT/Headers" -output "$OUT/BoringSSL.xcframework"
(cd "$OUT" && zip -qry BoringSSL.xcframework.zip BoringSSL.xcframework)
ls -la "$OUT/BoringSSL.xcframework.zip"
swift package compute-checksum "$OUT/BoringSSL.xcframework.zip"
