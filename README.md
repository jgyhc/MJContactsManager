# MJContactsManager

[![CI Status](https://img.shields.io/travis/jgyhc/MJContactsManager.svg?style=flat)](https://travis-ci.org/jgyhc/MJContactsManager)
[![Version](https://img.shields.io/cocoapods/v/MJContactsManager.svg?style=flat)](https://cocoapods.org/pods/MJContactsManager)
[![License](https://img.shields.io/cocoapods/l/MJContactsManager.svg?style=flat)](https://cocoapods.org/pods/MJContactsManager)
[![Platform](https://img.shields.io/cocoapods/p/MJContactsManager.svg?style=flat)](https://cocoapods.org/pods/MJContactsManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MJContactsManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MJContactsManager'
```

## Author

jgyhc, jgyhc@foxmail.com.com

## License

MJContactsManager is available under the MIT license. See the LICENSE file for more info.

## 使用方法

```
    _manager = [[MJContactsManager alloc] init];
    [self.manager JudgeAddressBookPowerWithViewController:self resultBlock:^(NSString *contactName, NSString *contactMobile) {
        NSLog(@"contactName:%@", contactName);
        NSLog(@"contactMobile:%@", contactMobile);
    }];
```
