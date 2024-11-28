# Example Xcode project for iOS Tutorials

This complements the following mimik Client Library tutorials:

- [Understanding the mimik Client Library for iOS](https://devdocs.mimik.com/key-concepts/10-index).
- [Creating a Simple iOS Application that Uses an edge microservice](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/01-index).
- [Integrating the mimik Client Library into an iOS project](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/02-index).
- [Working with mim OE in an iOS project](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/03-index).
- [Working with edge microservices in an iOS project](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/04-index).


# Prerequisites

- Attaching a **real iOS device** to the development Mac and selecting it as the build target. This won't work with the iOS simulator.

|**NOTE:** <br/><br/>Working with the iOS Simulator and the mimik Client Libraries entails some special consideration. For more more information about iOS Simulator support see [this tutorial](https://devdocs.mimik.com/tutorials/01-submenu/02-submenu/03-index#workingwithaniossimulator).|
|----------|


# Getting the Source Code

The example Xcode project has all the UI elements and initialization behavior needed to get the code up and running. 

The place to start is cloning the code from GitHub:

```
git clone https://github.com/mimikgit/iOS-devdocs-example-01.git
```

# Opening the Xcode Project

As mentioned in the tutorials, the mimik Client Library cocoapods need to be made available to the application source code. We will do this with the help of CocoaPods dependency manager.

We have setup these references in the `Podfile` file at the project level for you.

**Step 1:** From the command line run the following command to get to the Xcode project directory.

```
cd iOS-devdocs-example-01
```

**Step 2:** From the command line run the following command (from inside the Xcode project directory).

```
pod install --repo-update
```

**Step 3:** From the command line run the following command in your project directory.

```
open example.xcworkspace
```

**Step 4:**  Go to the [mimik Developer Console](https://console.mimik.com) and generate the Developer ID Token from an edge project that you create.

Once generated, copy the Developer ID Token. Then in the example project code find the `let devIdToken` placeholder and replace it with the actual Developer ID Token value.


**Step 5:**  Back to the mimik Developer Console and copy the mim OE (Edge) License from there as well. 

In the example project code find the `let edgeLicense` placeholder and replace it with the actual Developer edge License value.

**Step 6:**  Connect an actual iOS device to the Xcode machine, compile the project and run it on the connected device. Explore the functions while reading through the tutorials.

|**NOTE:** <br/><br/>**This example project requires a real iOS device running the latest iOS version.**<br/><br/>Working with the iOS Simulator and the mimik Client Libraries entails some special consideration. For more more information about iOS Simulator support see [this tutorial](../tutorials/12-index#workingwithaniossimulator).|
|----------|

# Screenshot:

![Get ID Token](images/example-screenshot-01.png)

