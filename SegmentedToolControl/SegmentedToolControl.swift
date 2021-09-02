//
//	SegmentedItemControl.swift
//	SegmentedItemControl
//
//	Created by Kaz Yoshikawa on 5/6/19.
//	Copyright © 2021 Electricwoods LLC. All rights reserved.
//

import UIKit


open class SegmentedItem: NSObject {

	public let identifier: String
	public var image: UIImage

	private weak var _segmentedItem: SegmentedCategoryItem!

	public var segmentedItem: SegmentedCategoryItem {
		get { return _segmentedItem }
		set { _segmentedItem = newValue }
	}

	public init(identifier: String, image: UIImage) {
		self.identifier = identifier
		self.image = image
		super.init()
	}

}

open class SegmentedItemView: UIView {

	public let item: SegmentedItem

	init(frame: CGRect, item: SegmentedItem) {
		self.item = item
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	lazy public var imageView: UIImageView = {
		let imageView = UIImageView(frame: self.bounds.insetBy(dx: 1, dy: 1))
		imageView.contentMode = .scaleAspectFit
		self.addSubview(imageView)
		return imageView
	}()

	public var isHighlighted: Bool = false {
		didSet {
			self.imageView.isHighlighted = self.isHighlighted
		}
	}
	
	public var image: UIImage? {
		didSet {
			self.imageView.image = self.image?.withRenderingMode(.alwaysTemplate)
			self.imageView.highlightedImage = self.image?.invertingAlpha()?.withRenderingMode(.alwaysTemplate)
		}
	}

	private lazy var setup: (()->()) = {
		self.image = item.image
		return {}
	}()

	override open func layoutSubviews() {
		self.setup()
		super.layoutSubviews()
		self.backgroundColor = UIColor.white
		self.imageView.frame = self.bounds.insetBy(dx: 1, dy: 1)
	}

	override open func draw(_ rect: CGRect) {
		self.tintColor.set()
		UIRectFrame(self.bounds)
	}

}

open class SegmentedCategoryItem: NSObject {
	public var items: [SegmentedItem]
	public var selectedItem: SegmentedItem
	public init(items: [SegmentedItem]) {
		assert(items.count > 0)
		self.items = items
		self.selectedItem = items.first!
		super.init()
		self.items.forEach { $0.segmentedItem = self }
	}
	public var image: UIImage {
		return self.selectedItem.image
	}
}

// it is not actually UIControl, if you like to make it a subclass of UIControl, be aware thre are some problems.

open class SegmentedToolControl: UIControl {

	static let orientationKey = "orientation"
	static let horizontalValue = "horizontal"
	static let verticalValue = "vertical"

	public enum Direction {
		case left
		case right
		case up
		case down
		var vector: CGSize {
			switch self {
			case .left: return CGSize(width: -1, height: 0)
			case .right: return CGSize(width: 1, height: 0)
			case .up: return CGSize(width: 0, height: -1)
			case .down: return CGSize(width: 0, height: 1)
			}
		}
	}

	public var direction: Direction = .right {
		didSet { self.sizeToFit() }
	}
	public var itemSize: CGSize = CGSize(width: 32, height: 32) {
		didSet { self.sizeToFit() }
	}
	
	public enum Orientation: Int {
		case vertical
		case horizontal
	}

	public var orientation: Orientation = .vertical {
		didSet { self.sizeToFit() }
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}

	private var _selectedSegmentItem: SegmentedCategoryItem!

	public var selectedCategoryItem: SegmentedCategoryItem {
		get {
			if let selectedSegmentItem = _selectedSegmentItem { return selectedSegmentItem }
			let selectedSegmentItem = segmentedCategoryItems.first!
			self._selectedSegmentItem = selectedSegmentItem
			return selectedSegmentItem
		}
		set {
			assert(self.segmentedCategoryItems.contains(newValue))
			if self._selectedSegmentItem != newValue {
				self._selectedSegmentItem = newValue
			}
			self.sizeToFit()
			self.setNeedsDisplay()
		}
	}

	lazy public var segmentedCategoryItems: [SegmentedCategoryItem] = {
		return [
			SegmentedCategoryItem(items: [SegmentedItem(identifier: "placeholder", image: self.placeholderImage!)])
		]
	}()
	
	public var selectedItem: SegmentedItem {
		return self.selectedCategoryItem.selectedItem
	}
	
	public func selectItem(with identifier: String) {
		for categoryItems in self.segmentedCategoryItems {
			for item in categoryItems.items {
				if item.identifier == identifier {
					self.selectedCategoryItem = categoryItems
					categoryItems.selectedItem = item
					return
				}
			}
		}
	}
	
	public override var isEnabled: Bool {
		didSet {
			self.isUserInteractionEnabled = self.isEnabled
			self.setNeedsDisplay()
		}
	}

	lazy private var setup: (()->()) = {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SegmentedToolControl.tapAction(_:)))
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(SegmentedToolControl.longPressAction(_:)))
		longPressGesture.minimumPressDuration = 0.3
		self.addGestureRecognizer(tapGesture)
		self.addGestureRecognizer(longPressGesture)
		self.clipsToBounds = false
		self.backgroundColor = .systemBackground
		return {}
	}()

	override open func layoutSubviews() {
		self.setup()
		super.layoutSubviews()
	}

	private func update() {
		self.bounds = CGRect(origin: self.bounds.origin, size: self.intrinsicContentSize)
	}

	override open func awakeFromNib() {
		super.awakeFromNib()
		self.update()
	}

	private func itemFrame(at index: Int) -> CGRect {
		switch self.orientation {
		case .vertical:
			return CGRect(origin: CGPoint(x: self.bounds.minX + 1, y: CGFloat(index) * (itemSize.height + 1) + 1), size: itemSize)
		case .horizontal:
			return CGRect(origin: CGPoint(x: CGFloat(index) * (itemSize.height + 1) + 1, y: self.bounds.minY + 1), size: itemSize)
		}
	}

	override open func draw(_ rect: CGRect) {
		let alpha: CGFloat = self.isEnabled ? 1.0 : 0.5
		self.tintColor.withAlphaComponent(alpha).set()
		switch self.orientation {
		case .vertical:
			let delta = CGPoint(x: 0.5, y: 0.0)
			UIBezierPath(points: [self.bounds.minXminY + delta, self.bounds.minXmaxY + delta])?.stroke()
			UIBezierPath(points: [self.bounds.maxXminY - delta, self.bounds.maxXmaxY - delta])?.stroke()
			for y in 0...self.segmentedCategoryItems.count {
				let top = CGFloat(y) * (itemSize.height + 1) + 0.5
				UIBezierPath(points: [CGPoint(x: self.bounds.minX, y: top), CGPoint(x: self.bounds.maxX, y: top)])?.stroke()
				if y < self.segmentedCategoryItems.count {
					let segment = self.segmentedCategoryItems[y]
					let icon = segment.image.resizing(to: self.itemSize)!
					let rect = CGRect(origin: CGPoint(x: self.bounds.minX + 1, y: top + 0.5), size: self.itemSize)
					let image = (segment == self.selectedCategoryItem) ? icon.invertingAlpha() : icon
					image?.withRenderingMode(.alwaysTemplate).draw(in: rect, blendMode: .normal, alpha: alpha)
				}
			}
		case .horizontal:
			let delta = CGPoint(x: 0.0, y: 0.5)
			UIBezierPath(points: [self.bounds.minXminY + delta, self.bounds.maxXminY + delta])?.stroke()
			UIBezierPath(points: [self.bounds.minXmaxY - delta, self.bounds.maxXmaxY - delta])?.stroke()
			for x in 0...self.segmentedCategoryItems.count {
				let left = CGFloat(x) * (itemSize.width + 1) + 0.5
				UIBezierPath(points: [CGPoint(x: left, y: self.bounds.minY), CGPoint(x: left, y: self.bounds.maxY)])?.stroke()
				if x < self.segmentedCategoryItems.count {
					let segment = self.segmentedCategoryItems[x]
					let icon = segment.image.resizing(to: self.itemSize)!
					let rect = CGRect(origin: CGPoint(x: left + 0.5, y: self.bounds.minY + 1), size: self.itemSize)
					let image = (segment == self.selectedCategoryItem) ? icon.invertingAlpha() : icon
					image?.withRenderingMode(.alwaysTemplate).draw(in: rect, blendMode: .normal, alpha: alpha)
				}
			}
		}
		
	}

	open override func sizeToFit() {
		self.setNeedsLayout()
		self.bounds.size = self.intrinsicContentSize
	}

	override open var intrinsicContentSize: CGSize {
		assert(segmentedCategoryItems.count > 0)
		switch self.orientation {
		case .vertical:
			let size = CGSize(width: itemSize.width + 2, height: CGFloat(self.segmentedCategoryItems.count) * (itemSize.height + 1) + 1)
			print(Self.self, #function, ".vertical", size)
			return size
		case .horizontal:
			let size = CGSize(width: CGFloat(self.segmentedCategoryItems.count) * (itemSize.width + 1) + 1, height: itemSize.height + 2)
			print(Self.self, #function, ".horizontal", size)
			return size
		}
	}

	func segmentItemIndex(at point: CGPoint) -> Int? {
		for index in 0 ..< self.segmentedCategoryItems.count {
			if itemFrame(at: index).contains(point) {
				return index
			}
		}
		return nil
	}

	@objc func tapAction(_ gesture: UIGestureRecognizer) {
		if let index = segmentItemIndex(at: gesture.location(in: self)) {
			self.selectedCategoryItem = self.segmentedCategoryItems[index]
			self.sendActions(for: .valueChanged)
		}
	}

	private var handlingSegment: SegmentedCategoryItem?

	@objc func longPressAction(_ gesture: UILongPressGestureRecognizer) {
		switch gesture.state {
		case .began:
			if let index = segmentItemIndex(at: gesture.location(in: self)) {
				let frame = itemFrame(at: index)
				let segmentItem = self.segmentedCategoryItems[index]
				if segmentItem.items.count > 1 {
					self.handlingSegment = segmentItem
					for (index, item) in segmentItem.items.enumerated() {
						let offset = ((self.itemSize * self.direction.vector) * CGFloat(index + 1)).point
						let itemFrame = (frame + offset).insetBy(dx: -1, dy: -1)
						let itemView = SegmentedItemView(frame: itemFrame, item: item)
						self.addSubview(itemView)
					}
				}
				else {
					self.selectedCategoryItem = segmentItem
				}
			}
		case .changed:
			let location = gesture.location(in: self)
			let itemViews = self.subviews.compactMap { $0 as? SegmentedItemView }
			let selection = itemViews.filter { $0.frame.contains(location) }.first
			itemViews.forEach { $0.isHighlighted = (selection == $0) }
		case .ended:
			let location = gesture.location(in: self)
			let itemViews = self.subviews.compactMap { $0 as? SegmentedItemView }
			let selection = itemViews.filter { $0.frame.contains(location) }.first
			if let selection = selection, let handlingSegment = handlingSegment {
				handlingSegment.selectedItem = selection.item
				self.selectedCategoryItem = handlingSegment
				self.sendActions(for: .valueChanged)
			}
			self.subviews.forEach { $0.removeFromSuperview() }
			self.handlingSegment = nil
		case .cancelled:
			self.subviews.forEach { $0.removeFromSuperview() }
			self.handlingSegment = nil
		default:
			break
		}
	}
	
	// MARK: -

	public var placeholderImage: UIImage? {
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let (width, height) = (Int(self.itemSize.width), Int(self.itemSize.height))
		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * width
		if let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow,
				space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue) {
			context.clear(CGRect(x: 0, y: 0, width: self.itemSize.width, height: self.itemSize.height))
			context.move(to: CGPoint(x: 0, y: 0))
			context.addLine(to: CGPoint(x: self.itemSize.width, y: self.itemSize.height))
			context.strokePath()
			context.move(to: CGPoint(x: self.itemSize.width, y: 0))
			context.addLine(to: CGPoint(x: 0, y: self.itemSize.height))
			context.strokePath()
			return context.makeImage().flatMap { UIImage(cgImage: $0).invertingAlpha() }
		}
		return nil
	}
}

