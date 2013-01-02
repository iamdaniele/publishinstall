# publishinstall

This Titanium module exposes the publishInstall method from the Facebook SDK 3.1. It is useful to run and track Mobile Install App Ads properly.

## Build and install

You need to download and build the Facebook SDK for the platforms you wish to use. Once you build, you need to setup the right libraries/paths in order to build the module.

After that, you should be able to install this module by following Titanium's [guide](https://wiki.appcelerator.org/display/tis/Using+Titanium+Modules).

### Build for iOS

1. Download the Facebook SDK for iOS. [https://developers.facebook.com/ios/](This) is a good place to start.
2. Install the SDK and take note of your install path, you will need it in the next step.
3. Open the Xcode project. Select the project, then select the target named `publishinstall-ios`. Add the Facebook SDK install path to the Framework Search Paths.
4. Build the module from using `build.py` and execute the test to make sure that the module build successfully. Edit example/app.js to add your app id, then run `titanium.py run` to fire up the Simulator.
5. Go to your App Dashboard on [https://developers.facebook.com/apps](Facebook Developers) and make sure that the install has been tracked.
6. If everything looks good, install the module in Titanium Studio, or unzip the package in your app.

### Build for Android

1. Clone/zip/tar the Facebook SDK source for Android from the [https://github.com/facebook/facebook-android-sdk](Facebook Github repo).
2. From the SDK directory, configure the project (`android update project --path YOUR_PATH/facebook --subprojects`) and then run `ant release install` to generate `bin/facebooksdk.jar`.
3. Clone this project, open Eclipse, and import `publishinstall`. Add the JAR you just created into the project.
4. Go to the module's source directory, and edit `examples/app.js` to add your app id.
5. Make sure you are on the top directory of `publishinstall`, then run `ant install`. Notice that you are running the Titanium's build target for `publishinstall`.
6. Go to your App Dashboard on [https://developers.facebook.com/apps](Facebook Developers) and make sure that the install has been tracked.
7. If everything looks good, install the module in Titanium Studio, or unzip the package in your app.

### License

https://developers.facebook.com/licensing/
