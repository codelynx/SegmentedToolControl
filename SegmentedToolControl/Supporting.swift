//
//	Supporting.swift
//	SegmentedItemControl
//
//	Created by Kaz Yoshikawa on 12/6/19.
//

import UIKit


extension UIBezierPath {
	convenience init?(points: [CGPoint]) {
		var iterator = points.makeIterator()
		guard let point1 = iterator.next() else { return nil }
		guard let point2 = iterator.next() else { return nil }
		let bezierPath = UIBezierPath()
		bezierPath.move(to: point1)
		bezierPath.addLine(to: point2)
		while let point = iterator.next() {
			bezierPath.addLine(to: point)
		}
		self.init(cgPath: bezierPath.cgPath)
	}
	func with(lineWidth: CGFloat) -> UIBezierPath {
		self.lineWidth = lineWidth
		return self
	}
}

extension CGPoint {
	init(_ size: CGSize) {
		self = CGPoint(x: size.width, y: size.height)
	}
}

extension UIImage {
	internal func invertingAlpha() -> UIImage? {
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let (width, height) = (Int(self.size.width * self.scale), Int(self.size.height * self.scale))
		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * width
		let byteOffsetToAlpha = 3 // [r][g][b][a]
		if let context = CGContext(
				data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow,
				space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue),
			let cgImage = self.cgImage {
			context.setFillColor(UIColor.clear.cgColor)
			context.fill(CGRect(origin: CGPoint.zero, size: self.size))
			context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: self.size * self.scale))
			if let memory: UnsafeMutableRawPointer = context.data {
				for y in 0..<height {
					let pointer = memory.advanced(by: bytesPerRow * y)
					let buffer = pointer.bindMemory(to: UInt8.self, capacity: bytesPerRow)
					for x in 0..<width {
						let rowOffset = x * bytesPerPixel + byteOffsetToAlpha
						buffer[rowOffset] = 0xff - buffer[rowOffset]
					}
				}
				if let cgImage =  context.makeImage() {
					let image = UIImage(cgImage: cgImage, scale: self.scale, orientation: .up)
					return image
				}
			}
		}
		return nil
	}
	internal func resizing(to newSize: CGSize) -> UIImage? {
		let widthRatio = newSize.width / size.width
		let heightRatio = newSize.height / size.height
		let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
		let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		draw(in: CGRect(origin: CGPoint((newSize - resizedSize) * 0.5), size: resizedSize))
		let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return resizedImage
	}
}
