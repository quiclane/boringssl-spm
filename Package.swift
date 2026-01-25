// swift-tools-version:6.0
import PackageDescription
let package=Package(name:"boringssl-spm",products:[.library(name:"BoringSSL",targets:["BoringSSL"])],targets:[.binaryTarget(name:"BoringSSL",path:"BoringSSL.xcframework")])
