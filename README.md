# RKBarcodeScanner

[![CI Status](http://img.shields.io/travis/cmtrounce/RKBarcodeScanner.svg?style=flat)](https://travis-ci.org/cmtrounce/RKBarcodeScanner)
[![Version](https://img.shields.io/cocoapods/v/RKBarcodeScanner.svg?style=flat)](http://cocoapods.org/pods/RKBarcodeScanner)
[![License](https://img.shields.io/cocoapods/l/RKBarcodeScanner.svg?style=flat)](http://cocoapods.org/pods/RKBarcodeScanner)
[![Platform](https://img.shields.io/cocoapods/p/RKBarcodeScanner.svg?style=flat)](http://cocoapods.org/pods/RKBarcodeScanner)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RKBarcodeScanner is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RKBarcodeScanner'
```

## Usage

You are not able to initiaise it using code, this is a xib only implementation at the moment.

* Create your view in your storyboard or xib file

* Set the class to **RKBarcodeScanner**

* To begin:

```swift
barcodeScanner.beginCapture { [unowned self] barcode in

// barcode is of String type. Each new barcode read comes in here if the scanner is active.

}
```

* When you're done with it:

```swift
barcodeScanner.stopCapture()
```

And that's it!

## Author

cmtrounce, ctrounce94@gmail.com

## License

RKBarcodeScanner is available under the MIT license. See the LICENSE file for more info.
