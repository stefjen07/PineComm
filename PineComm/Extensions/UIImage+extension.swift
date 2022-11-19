//
//  UIImage+extension.swift
//  PineComm
//
//  Created by Евгений on 17.11.22.
//

import UIKit

extension UIImage: Identifiable {
	public var id: Int {
		self.hashValue
	}
}

extension UIImage {
	var fixedOrientation: UIImage {
		if imageOrientation == .up {
			return self
		}

		var transform: CGAffineTransform = CGAffineTransform.identity

		switch imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: size.height)
			transform = transform.rotated(by: CGFloat.pi)
		case .left, .leftMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.rotated(by: CGFloat.pi / 2)
		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: size.height)
			transform = transform.rotated(by: CGFloat.pi / -2)
		default:
			break
		}

		switch imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: size.height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		default:
			break
		}

		guard
			let cgImage = self.cgImage,
			let colorSpace = cgImage.colorSpace,
			let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
		else { return self }

		ctx.concatenate(transform)

		switch self.imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
		default:
			ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		}

		guard let ctxImage: CGImage = ctx.makeImage() else { return self }

		return UIImage(cgImage: ctxImage)
	}
}
