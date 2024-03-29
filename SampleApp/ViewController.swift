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
	
	static let carKey = "car"
	static let busKey = "bus"
	static let tramKey = "tram"
	static let bicycleKey = "bicycle"
	static let walkKey = "figure.walk"

	@IBOutlet weak var leftControl: SegmentedToolControl!
	@IBOutlet weak var rightControl: SegmentedToolControl!
	@IBOutlet weak var bottomControl: SegmentedToolControl!
	@IBOutlet weak var topControl: SegmentedToolControl!
	@IBOutlet weak var barButtonControl: SegmentedToolControl!

	lazy var toolBarButtonItem: UIBarButtonItem = {
		let control = SegmentedToolControl()
		control.itemSize = CGSize(width: 27, height: 27)
		control.orientation = .horizontal
		control.direction = .down
		control.segmentedCategoryItems = [
			SegmentedCategoryItem(items: [
				self.makeSegmentedItem(Self.carKey),
				self.makeSegmentedItem(Self.busKey),
				self.makeSegmentedItem(Self.tramKey),
			]),
			SegmentedCategoryItem(items: [
				self.makeSegmentedItem(Self.bicycleKey),
				self.makeSegmentedItem(Self.walkKey),
			]),
		]
		control.backgroundColor = .systemBackground
		control.sizeToFit()
		return UIBarButtonItem(customView: control)
	}()

	static let itemSize = CGSize(width: 32, height: 32)

	func makeSegmentedItem(_ identifier: String) -> SegmentedItem {
		return SegmentedItem(identifier: identifier, image: UIImage(systemName: identifier)!.resizing(to: Self.itemSize)!)
	}

	private func setup(control: SegmentedToolControl, orientation: SegmentedToolControl.Orientation,  direction: SegmentedToolControl.Direction) {
		control.itemSize = Self.itemSize
		control.orientation = orientation
		control.direction = direction
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
		self.navigationItem.rightBarButtonItems = [self.toolBarButtonItem]
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
		print(Self.self, #function)
		for (key, control) in self.keyControlPairs {
			if let identifier = UserDefaults.standard.value(forKey: key) as? String {
				control.selectItem(with: identifier)
			}
		}
	}

	@IBAction func segmentedToolControlAction(_ sender: SegmentedToolControl) {
		if let (key, control) = self.keyControlPairs.filter({ $0.value == sender }).first {
			UserDefaults.standard.setValue(control.selectedItem.identifier, forKey: key)
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

