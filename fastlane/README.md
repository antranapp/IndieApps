fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios certificates_dev
```
fastlane ios certificates_dev
```
Download and setup if needed all certificates for Dev target
### ios certificates_prod
```
fastlane ios certificates_prod
```
Download and setup if needed all certificates for AppStore Production target
### ios beta
```
fastlane ios beta
```
Push a new beta build to TestFlight
### ios register_new_device
```
fastlane ios register_new_device
```
Register new device
### ios refresh_profiles
```
fastlane ios refresh_profiles
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
