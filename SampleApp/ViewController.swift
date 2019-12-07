//
//	ViewController.swift
//	SampleApp
//
//	Created by Kaz Yoshikawa on 12/6/19.
//

import UIKit
import SegmentedToolControl

class ViewController: UIViewController {

	static let hammerKey = "hammer"
	static let paintbrushKey = "paintbrush"
	static let wrenchKey = "wrench"
	static let heartKey = "suit.heart"
	static let spadeKey = "suit.spade"
	static let diamondKey = "suit.diamond"
	static let clubKey = "suit.club"

	static let bubbleLeftKey = "bubble.left"
	static let micKey = "mic"
	static let phoneKey = "phone"
	static let tvKey = "tv"
	
	static let hareKey = "hare"
	static let tortoiseKey = "tortoise"
	static let antKey = "ant"
	
	static let leftKey = "left"
	static let rightKey = "right"
	static let topKey = "top"
	static let bottomKey = "bottom"

	@IBOutlet weak var leftControl: SegmentedToolControl!
	@IBOutlet weak var rightControl: SegmentedToolControl!
	@IBOutlet weak var bottomControl: SegmentedToolControl!
	@IBOutlet weak var topControl: SegmentedToolControl!

	static let itemSize = CGSize(width: 32, height: 32)

	func makeSegmentedItem(_ identifier: String) -> SegmentedItem {
		return SegmentedItem(identifier: identifier, image: UIImage(systemName: identifier)!.resizing(to: Self.itemSize)!)
	}

	private func setup(control: SegmentedToolControl, orientation: SegmentedToolControl.Orientation,  direction: SegmentedToolControl.Direction) {
		control.itemSize = Self.itemSize
		control.orientation = orientation
		control.direction = direction
		control.delegate = self
		control.segmentedCategoryItems = [
			SegmentedCategoryItem(items: [
				self.makeSegmentedItem(Self.hammerKey),
				self.makeSegmentedItem(Self.paintbrushKey),
				self.makeSegmentedItem(Self.wrenchKey),
			]),
			SegmentedCategoryItem(items: [
				self.makeSegmentedItem(Self.heartKey),
				self.makeSegmentedItem(Self.spadeKey),
				self.makeSegmentedItem(Self.diamondKey),
				self.makeSegmentedItem(Self.clubKey),
			]),
			SegmentedCategoryItem(items: [
				self.makeSegmentedItem(Self.bubbleLeftKey),
				self.makeSegmentedItem(Self.micKey),
				self.makeSegmentedItem(Self.phoneKey),
				self.makeSegmentedItem(Self.tvKey),
			]),
			SegmentedCategoryItem(items: [
				self.makeSegmentedItem(Self.hareKey),
				self.makeSegmentedItem(Self.tortoiseKey),
				self.makeSegmentedItem(Self.antKey),
			]),
		]
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setup(control: self.leftControl, orientation: .vertical, direction: .right)
		self.setup(control: self.rightControl, orientation: .vertical, direction: .left)
		self.setup(control: self.topControl, orientation: .horizontal, direction: .down)
		self.setup(control: self.bottomControl, orientation: .horizontal, direction: .up)
		self.title = String(describing: SegmentedToolControl.self)
	}

	var keyControlPairs: [String: SegmentedToolControl] {
		return [
			Self.leftKey: self.leftControl,
			Self.rightKey: self.rightControl,
			Self.topKey: self.topControl,
			Self.bottomKey: self.bottomControl
		]
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		for (key, control) in self.keyControlPairs {
			if let identifier = UserDefaults.standard.value(forKey: key) as? String {
				control.selectItem(with: identifier)
			}
		}
	}


}

extension ViewController: SegmentedToolControlDelegate {

	func segmentedToolControl(_ control: SegmentedToolControl, didSelectItem: SegmentedItem) {
		for (key, value) in self.keyControlPairs {
			if control == value {
				UserDefaults.standard.setValue(value.selectedItem.identifier, forKey: key)
				break
			}
		}
	}
}


extension UIImage {
	func resizing(to _size: CGSize) -> UIImage? {
		let widthRatio = _size.width / size.width
		let heightRatio = _size.height / size.height
		let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
		let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
		UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
		draw(in: CGRect(origin: .zero, size: resizedSize))
		let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return resizedImage
	}
}

