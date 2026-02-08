// swift-tools-version: 6.2
import PackageDescription
let package=Package(name:"boringssl-spm",platforms:[.iOS(.v13)],products:[.library(name:"BoringSSL",targets:["BoringSSL"])],targets:[.binaryTarget(name:"BoringSSL",path:"BoringSSL.xcframework")])
