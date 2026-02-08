boringssl-spm
=============

Deterministic, auto-updating **BoringSSL** binary distribution for Apple platforms,
packaged for **Swift Package Manager** as a prebuilt XCFramework.

This repo exists because getting BoringSSL into a clean, reusable, zero-friction
Apple binary artifact is *way* harder than it should be.

Goal
----

• build BoringSSL correctly for iOS (device + simulator)  
• package it as a single XCFramework that Xcode can consume  
• ship it via SwiftPM with checksum verification  
• update automatically from upstream with traceability  

Paste URL → works.

What BoringSSL is (plain English)
---------------------------------

BoringSSL is Google’s TLS/crypto library, derived from OpenSSL years ago and then
heavily refactored to match Google’s security + engineering needs.

Key points:

- It is *not* OpenSSL
- It does *not* promise stable public APIs like OpenSSL does
- It is primarily built to be a “known-good crypto/TLS core” used inside major
  Google/Chromium infrastructure

If you want a modern TLS 1.3 implementation with battle-tested internals and
excellent real-world hardening, BoringSSL is often the best foundation.

Why this repo exists (the real problem)
---------------------------------------

BoringSSL is intentionally upstream-first and “build-system opinionated”.

It is not shipped as:
- a ready-made `.xcframework`
- a Swift Package
- a stable semver library

It is a C/C++ codebase meant to be built as part of a larger system.

So if you want to use it in iOS apps, you hit a wall:

1) Build outputs are not “drop-in Apple artifacts”
   - you get static libs and headers, not an XCFramework

2) iOS build is multi-arch + multi-SDK
   - device: arm64 (iphoneos)
   - simulator: arm64 + x86_64 (iphonesimulator)

3) You must match headers + build defines exactly across slices
   - a mismatch gives link failures or subtle runtime breakage

4) XCFramework packaging is strict
   - expects consistent header layout
   - expects correct architecture slices
   - expects proper library naming

5) SwiftPM binaryTarget has a strict integrity model
   - the artifact must be a stable URL
   - the SHA-256 checksum must match exactly

So “just add BoringSSL” is never “just add BoringSSL”.
This repo turns it into a one-line import.

What this repo ships
--------------------

- A prebuilt `BoringSSL.xcframework` (static libs inside)
- Packaged as a SwiftPM `binaryTarget`
- Hosted as GitHub Releases `.xcframework.zip`
- Checksum verified by SwiftPM on install

No source builds occur on user machines.

Upstream trust + integrity model
--------------------------------

This repo tracks Google’s upstream BoringSSL repository (main branch).

Trust is enforced in multiple layers:

1) Upstream source of truth
   - builds are produced from Google’s repo directly (no hand-edited vendoring)

2) Deterministic build pipeline
   - the GitHub Action rebuilds from scratch
   - output is always freshly assembled (no stale intermediate cache assumptions)

3) Artifact immutability via release tags
   - every build is published as an immutable release tag like:

     ios-YYYYMMDD-<short-hash>

   That tag represents:
   - the upstream commit state used for that build
   - the exact XCFramework zip that SwiftPM will download

4) SwiftPM checksum verification
   - SwiftPM refuses to use the binary unless the SHA-256 checksum matches
   - this prevents silent binary swaps or corrupted downloads

In practice:
- upstream authenticity comes from “built from Google’s main”
- distribution integrity comes from “SwiftPM checksum gate”

How to use in Xcode
-------------------

1. Open your Xcode project
2. File → Add Package Dependencies…
3. Paste:

   https://github.com/quiclane/boringssl-spm.git

4. Version rule:
   - Choose **Up to Next Major**
   - Enter **1.0.0**

Then import / link as needed.

Common pairing:
- boringssl-spm + nghttp2-spm (HTTP/2 stacks)
- boringssl-spm + lsquic-spm (QUIC stacks)

Why versioning looks unusual
----------------------------

You will see release tags like:

- ios-20260208-305bcfce00b1

These are *build identity tags*:
they map 1:1 to a specific upstream snapshot and output artifact.

But SwiftPM/Xcode requires semantic versions.

So we use a stable-pointer tagging model:

- `1.0.0` → stable pointer (recommended for most apps)
- `1.0.1` → fresh pointer (newer build)

These tags are updated to point at newer build releases over time.

Think of them as “human-friendly entry points” that always resolve in Xcode
without forcing users to pick through timestamp tags.

SwiftPM still verifies the downloaded zip via checksum.

What makes BoringSSL packaging hard (deeper detail)
---------------------------------------------------

BoringSSL’s build outputs are not “one library”.

It produces multiple components that must stay consistent, typically:

- crypto
- ssl
- (and internal support code, depending on build config)

Apple packaging expects:
- coherent headers
- stable module exposure
- correct slice assembly for each platform/arch set

Additionally:
- AppleClang + iOS SDKs impose specific constraints on flags and arch selection
- simulator is now dual-world (arm64 + x86_64) in many projects
- you must avoid mismatched compile settings between device and simulator slices

One mismatched define can make the headers disagree with the compiled symbols.
That becomes:
- link errors
- or worse: runtime behavior inconsistencies

This repo exists so downstream projects never touch that complexity.

Guarantees
----------

- Static libs only
- Works with SwiftPM in Xcode
- No scripts run locally
- No dependency on Homebrew for users
- Deterministic release artifacts
- SwiftPM checksum integrity enforced

Related repos
-------------

- https://github.com/quiclane/nghttp2-spm
- https://github.com/quiclane/lsquic-spm

License
-------

BoringSSL is licensed upstream by Google.
This repo redistributes binaries built from upstream source.
See upstream BoringSSL licensing for details.
