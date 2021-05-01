#  SegmentedToolControl

![xcode](https://img.shields.io/badge/Xcode-11.1-blue)
![swift](https://img.shields.io/badge/Swift-5.1-orange.svg)
![license](https://img.shields.io/badge/License-MIT-yellow.svg)

If you are working on some productivity type of app, you may like to provide many tool items.  No matter how much you want to add items, the screen size is limited, and many not be able to place all in one line.  Also sometime, you may also want to place tool items vertically, not horizontally for some usabilities or design issues.

I run into a situation to develop such a component for iOS, and I spent some time to clean up my code, and decided to make it open source to share my work.

Here is an example of `SegmentedToolControl`, it is placed vertically, and placed on the right size of the screen.  Each segment represents a category or a group, and it contains several subitems associated with the category.  Hence, a small segmented control like user interface objects can provide preetty much subitems to select.

<img src="https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F65634%2F0643ef1c-abc2-b034-e242-84c9796dac4a.png?ixlib=rb-1.2.2&auto=compress%2Cformat&gif-q=60&s=d0f3c5d8f0816d3c213812921357052b" width="200"/>


## Main Classes

### SegmentedItem

It is a representation of a tool item. Make sure image size matches to `SegmentedToolControl`'s `itemSize` property.

```.swift
	SegmentedItem(identifier: "paintbrush", image: UIImage(systemName: "paintbrush")
```

### SegmentedCategoryItem

It represents a category or a group of sub items. There must be at least one `SegmentedItem` in `SegmentedCategoryItem`.

```.swift
    SegmentedCategoryItem(items: [
        SegmentedItem(identifier: "hammer", image: UIImage(systemName: "hammer"),
        SegmentedItem(identifier: "wrench", image: UIImage(systemName: "wrench")
    ])
```

### SegmentedToolControl

You may have to configure `SegmentedToolControl` by code. Here is an example of setting up this component by code.

```.swift
    let toolControl: SegmentedToolControl = ...
    toolControl.itemSize = Self.itemSize
    toolControl.orientation = .vertical
    toolControl.direction = .right
    toolControl.delegate = self
    toolControl.segmentedCategoryItems = [
        SegmentedCategoryItem(items: [
            SegmentedItem(identifier: "hammer", image: UIImage(named: "hammer"),
            SegmentedItem(identifier: "wrench", image: UIImage(named: "wrench")
        ]),
            SegmentedCategoryItem(items: [
            SegmentedItem(identifier: "hare", image: UIImage(named: "hare"),
            SegmentedItem(identifier: "tortoise", image: UIImage(named: "tortoise")
        ])
    ]
```

Here is the table of `SegmentedToolControl`'s property.


| Property | Type | Description |
| ---------| ---- | ----------- |
| itemSize | CGSize | Icon size of an item |
| orientation | Orientation | `vertical` or `horizontal` |
| direction | Direction | `left`, `right`, `up`, `down` |
| segmentedCategoryItems | [SegmentedCategoryItem] | indicate which `SegmentedCategoryItem` is selected. |
| selectedItem | SegmentedItem | indicate which tool item is currently selected |

## Target - Action

Just like UIControl, `SegmentedToolControl` fires `UIControl.Event.valueChanged` to targets.  You can use Interface Builder to wire action, but you must hook `value changed` to the target.

```.swift
	@IBAction func segmentedToolControlAction(_ sender: SegmentedToolControl) {
		print(sender.selectedItem.identifier)
	}
```

## Sample App

This project includes a sample iOS app to demonstrate how to use `SegmentedToolControl`.

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/65634/94c6025b-a666-93d6-fa50-31cd686d3ed2.png" width="340"/>

### License

The MIT License


