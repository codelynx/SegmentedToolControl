#  SegmentedToolControl

![xcode](https://img.shields.io/badge/Xcode-11.1-blue)
![swift](https://img.shields.io/badge/Swift-5.1-orange.svg)
![license](https://img.shields.io/badge/License-MIT-yellow.svg)

If you are working on some productivity type of app, you may like to provide many tool items.  No matter how much you want to add items, the screen size is limited, and many not be able to place all in one line.  Also sometime, you may also want to place tool items vertically, not horizontally for some usabilities or design issues.

I run into a situation to develop such a component for iOS, and I spent some time to clean up my code, and decided to make it open source to share my work.

Here is an example of `SegmentedToolControl`, it is placed vertically, and placed on the right size of the screen.  Each segment represents a category or a group, and it contains several subitems associated with the category.  Hence, a small segmented control like user interface objects can provide preetty much subitems to select.

<img src="https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F65634%2F0643ef1c-abc2-b034-e242-84c9796dac4a.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&s=d0f3c5d8f0816d3c213812921357052b" width="200"/>

At this moment, `SegmentedToolControl` can be placed in storyboard, but you will need to configure them by code.

### License

The MIT License


