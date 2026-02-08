
# 🎉 BoringSSL Swift Package Manager (SPM) Integration

## 📖 Overview

This repository provides a **Swift Package Manager (SPM)** integration for **BoringSSL**, a fork of **OpenSSL** designed for Google’s internal use. BoringSSL is a modern, high-performance cryptographic library used in many of Google’s secure communications protocols and other security-critical systems.

This package simplifies the integration of **BoringSSL** into your **iOS** and **macOS** projects by using **SPM**. With just a few clicks, you can integrate **BoringSSL** into your project and start utilizing its secure cryptographic functions, including **SSL/TLS** support. 🔒

## 🤔 Why This Was Built

While **BoringSSL** is a critical part of many of Google’s services, integrating it into iOS/macOS projects can be cumbersome. By wrapping **BoringSSL** into a **Swift Package**, the installation and management process becomes a breeze. This approach allows for:

- 💨 Effortless integration of **BoringSSL** into **iOS** and **macOS** apps.
- 🔄 **Automatic updates** every 3 days (or when a new release is available), ensuring you’re always working with the latest and most secure version.
- 🔧 Compatibility with modern **iOS/macOS** development tools, including **Xcode** and **Swift Package Manager**.

## 🌟 Features

- 📦 **Swift Package Manager (SPM) integration**: Easily include **BoringSSL** in your Xcode projects.
- 🔄 **Automatic updates**: The package automatically updates every 3 days or whenever a new release is available, ensuring you have the latest version.
- 🖥️ **Cross-platform support**: This package supports both **iOS** and **macOS** projects with appropriate architecture (arm64, x86_64).
- 🔐 **Secure**: Built on top of **BoringSSL** for strong cryptography and **SSL/TLS** support.

---

## ⚙️ How to Use

### 1️⃣ Add the Package Dependency to Your Xcode Project

To integrate **BoringSSL** into your project using **Swift Package Manager (SPM)**, follow these steps:

1. Open your project in **Xcode**.
2. In the **Xcode menu**, go to **File > Add Packages**.
3. In the **Search or Enter URL** field, paste the following GitHub URL:

   ```
   https://github.com/quiclane/boringssl-spm.git
   ```

4. Select the version you’d like to integrate (the default option should work well).
5. Click **Add Package**.

Xcode will automatically resolve the package dependency and download **BoringSSL** into your project. 🚀

---

### 2️⃣ Import and Use BoringSSL

After the package is added, you can import **BoringSSL** in your Swift code like this:

```swift
import BoringSSL
```

You can now use **BoringSSL**’s cryptographic functions, including **SSL/TLS** features, secure random number generation, and more. 🔑

---

### 3️⃣ Build and Run Your Project

Once **BoringSSL** is integrated, you can build and run your project as usual. **Xcode** will handle the rest. 🎯

---

## 🔄 Automatic Updates

This package is designed to update **every 3 days automatically, and keeps freshest build and one fallback build in case something breaks**. If there’s a new release of **BoringSSL** on GitHub, the workflow will automatically update your local version. If no update is necessary (i.e., if you already have the latest release), the process will do nothing. ✅

To ensure this process works smoothly, the repository is configured to check for updates, pull the latest code, and build the required dependencies. 🔄

---

## 🛠️ Troubleshooting

### ❓ If the Package Doesn’t Work

- 📶 Ensure you’re connected to the internet and **Xcode** can reach the **GitHub** repository.
- 🧹 If **Xcode** displays errors regarding the package, try running the **Clean Build Folder** (`Shift + Command + K`) and rebuilding.
- 📱 Ensure that the correct version of **Xcode** is being used and that you’re running the latest stable version of **macOS**.

---

## 📝 License

This project is licensed under the **MIT License**. 📝
