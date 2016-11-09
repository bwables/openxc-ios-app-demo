# OpenXC-iOS-App-Demo
OpenXC Enabler app that use all of the features of the [openxc-ios-framework](https://github.com/openxc/openxc-ios-framework). This can be a starting app for any OpenXC iOS application that wishes to use the C5 BLE device.

The OpenXC iOS Framework must be downloaded and included in this app. Make sure that openXCiOSFramework.framework is added as an “Embedded Binary” in the openXCenabler General project settings.

Once the application & framework is downloaded, add both the frameworks(openxc-ios & protobuf) in "Link Binary with Libraries" under "Build Phases" and "Embedded Binary". 


## Building from XCode
XCode7 and iOS9 must be installed to build the application. Refer to this [document]() for more details.


## Contributing

Please see our [Contribution Documents](https://github.com/openxc/openxc-ios-app-demo/blob/master/CONTRIBUTING.mkd)

## License
Copyright (c) 2016 Ford Motor Company
Licensed under the BSD license.