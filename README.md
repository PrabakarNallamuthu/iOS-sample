# Example Xcode project for iOS Tutorials

This project demonstrates how to integrate and use the **mimik Client Library** in an iOS app.  
It includes UI buttons and prewired Swift functions that let you interact with:  

- The **mimik Developer Console** (authentication, app management, token issuance)  
- The **mim OE runtime** (start, stop, reset, lifecycle management)  
- **Edge microservices** (deploy, list, update, call, undeploy)  

It is meant to be a practical companion to the tutorials on [mimik devdocs](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu).  

---

# Technical Prerequisites

To run this project, you will need:  

- An actual iOS device running the **latest iOS version** (simulator support is limited, see below).  
- A Mac with the **latest version of Xcode** installed.  
- A [mimik Developer Console](https://console.mimik.com) account with a valid **runtime (Edge) License**.  

---

# Getting the Source Code

Clone this repo and open the project in Xcode:

```bash
git clone https://github.com/mimikgit/iOS-devdocs-example-01.git
```

---

# Opening the Xcode Project

The project uses CocoaPods for dependency management.  

We’ve included the required libraries (`EdgeCore` and `mim-OE-ai-SE-iOS-developer`) in the `Podfile`.

### Step 1: Go to the project directory

```bash
cd iOS-devdocs-example-01
```

### Step 2: Install dependencies

```bash
pod install --repo-update
```

### Step 3: Open the workspace

```bash
open example.xcworkspace
```

### Step 4: Add your runtime license

Go to the [mimik Developer Console](https://console.mimik.com) and copy your **runtime (Edge) license**.  
In `ContentView.swift`, replace the placeholder:

```swift
private static let runtimeLicense = "{ADD-YOUR-RUNTIME-LICENSE-HERE}"
```

with your actual license value.  

For details, see the tutorial:  
👉 [Getting the mim OE license and Identity server values](https://devdocs.mimik.com/tutorials/01-submenu/01-submenu/02-index)

### Step 5: Run on a real device

Connect an iOS device, build, and run the app in Xcode.  

> ⚠️ **Important:** This project requires a real iOS device.  
> The mimik Client Libraries have limitations when running inside the Simulator.  
> See the [iOS Simulator support tutorial](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/03-index#workingwithaniossimulator) for more info.  

---

# Example Features

The sample UI exposes many core operations as buttons.  

Here are some highlights:

### Developer Console actions
- **Login** with your developer account  
- **Create**, **list**, or **delete** apps  
- **Get ID Tokens** and **Shared Tokens**  
- **Manage all apps** (⚠️ includes "delete all apps" functionality — use with care)

### Runtime lifecycle
- **Start / Stop / Reset** the runtime  
- **Check runtime info**  
- **Manage lifecycle automatically**  
- **Activate external runtime** (e.g. on another host/device)  

### Edge Microservices
- **Deploy microservices** (example `randomnumber-v1.tar` is included)  
- **List deployed services**  
- **Call a microservice endpoint** (`/randomNumber`)  
- **Update environment variables**  
- **Undeploy services**  

---

# Tutorials on devdocs

This project directly supports and builds on the step-by-step tutorials available at [mimik devdocs](https://devdocs.mimik.com).  

Some key tutorials to explore alongside this example:  

- [Integrating the mimik Client Library into an iOS project](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/02-index)  
  - Learn how to set up your environment and obtain your runtime license.  

- [Working with mim OE in an iOS project](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/03-index)  
  - Walkthrough on deploying microservices like the included `randomnumber-v1`.  

- [Working with edge microservices in an iOS project](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/04-index)  
  - Understanding developer console login, app creation, and token issuance.  

- [iOS Simulator Support](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/03-index#workingwithaniossimulator)  
  - Details on using mimik Client Libraries in simulator environments.  

- [All Tutorials](https://devdocs.mimik.com/tutorials)  
  - Browse the full library for topics including external runtimes, advanced microservice deployment, and integration with other platforms.  

Use this sample app while following the tutorials — the functions here map directly to the actions described in the documentation.  

---

# Example Screenshot

![Get ID Token](images/example-screenshot-01.png)

---

# Useful Resources

- 📘 [mimik developer documentation](https://devdocs.mimik.com)  
- 🖥️ [mimik developer console](https://console.mimik.com)  
- 📱 [mimik iOS client library docs](https://mimikgit.github.io/cocoapod-EdgeCore/documentation/edgecore/)  

---

# Tips for Developers

- **Enable logging**: The project sets mimik Client Library logging to `.debug` for easier troubleshooting.  
- **App cleanup**: If you experiment heavily, consider using the **delete all apps** button — but remove the `fatalError` guard first.  
- **Microservice images**: To deploy your own services, replace `randomnumber_v1.tar` with your own `.tar` image and update the config accordingly.  
- **Runtime license management**: You can switch between local and external runtimes by using the `activateExternalRuntime()` helper.  

---

Happy experimenting! 🚀  
ggThis project is your sandbox for learning how to interact with mimik runtimes, the developer console, and edge microservices directly from an iOS app — while following along with the official [mimik tutorials](https://devdocs.mimik.com/tutorials).
