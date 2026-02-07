// swift-tools-version: 6.2
import PackageDescription
let package=Package(name:"boringssl-spm",platforms:[.iOS(.v13)],products:[.library(name:"BoringSSL",targets:["BoringSSL"])],targets:[.binaryTarget(name:"BoringSSL",url:"https://github.com/quiclane/boringssl-spm/releases/download/ios-20260208-305bcfce00b1/BoringSSL.xcframework.zip",checksum:"7b38abcb125c6148280e2aa9379ed0c18f19f554f36e10f5466fff01f2d35d0f")])
