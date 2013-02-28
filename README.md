# publishinstall

This Titanium module exposes the publishInstall method from the Facebook SDK 3.1. It is useful to run and track Mobile Install App Ads properly.

## Build and install

You should be able to install this module by following Titanium's [guide](https://wiki.appcelerator.org/display/tis/Using+Titanium+Modules).

### Build for iOS

1. Go to the module's source directory, and edit `examples/app.js` to add your app id.
2. Build the module from using `build.py` and execute the test to make sure that the module build successfully. Edit example/app.js to add your app id, then run `titanium.py run` to fire up the Simulator.
3. Go to your App Dashboard on [https://developers.facebook.com/apps](Facebook Developers) and make sure that the install has been tracked.
4. If everything looks good, install the module in Titanium Studio, or unzip the package in your app.

### Build for Android

1. Go to the module's source directory, and edit `examples/app.js` to add your app id.
2. Make sure you are on the top directory of `publishinstall`, then run `ant install`. Notice that you are running the Titanium's build target for `publishinstall`.
3. Go to your App Dashboard on [https://developers.facebook.com/apps](Facebook Developers) and make sure that the install has been tracked.
4. If everything looks good, install the module in Titanium Studio, or unzip the package in your app.

### License

https://developers.facebook.com/licensing/
