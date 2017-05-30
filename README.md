# ZzeBlurredLabel
[![Version](https://img.shields.io/cocoapods/v/ZzeBlurredLabel.svg?style=flat)](http://cocoapods.org/pods/ZzeBlurredLabel)
[![Platform](https://img.shields.io/cocoapods/p/ZzeBlurredLabel.svg?style=flat)](http://cocoapods.org/pods/ZzeBlurredLabel)
[![License](https://img.shields.io/cocoapods/l/ZzeBlurredLabel.svg?style=flat)](https://github.com/organizze/ZzeBlurredLabel/blob/master/LICENSE)

#### Without filter
![Without Filter](https://github.com/organizze/ZzeBlurredLabel/tree/master/ZzeBlurredLabel/images/without-filter.png)

#### Filtered
![With Filter](https://github.com/organizze/ZzeBlurredLabel/tree/master/ZzeBlurredLabel/images/with-filter.png)

## Requirements
* iOS 8.0+

#### CocoaPods
Add the following line to your `Podfile`:
```
pod 'ZzeBlurredLabel'
```

#### Manual
Just import ZzeBlurredLabel to your project.

## How to use
#### 1. Create ZzeBlurredLabel
##### ・By coding
```objective-c
label = [[ZzeBlurredLabel alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
label.text = @"Your Text"
```

#### 2. Call getBlurryImageText
##### ・Method return image blurry
```objective-c
UIImage * convertedImage = [label getBlurryImageText];
```

This is method return UIImage create from UILabel text/atrributedText.

#### Extra . Call blurryText
##### ・Blurry text on UILabel

```objective-c
[label blurryText];
```

## License
This software is released under the MIT License.
