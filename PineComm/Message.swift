//
//  Message.swift
//  PineComm
//
//  Created by Евгений on 14.11.22.
//

import UIKit

struct Message: Identifiable, Codable {
	var id: UUID
	var text: String?
	var imageData: Data?
	var date: Date
	var sender: String

	var image: UIImage? {
		get {
			guard let imageData = imageData else { return nil }
			return UIImage(data: imageData)
		}
		set {
			imageData = newValue?.pngData()
		}
	}

	private init(deviceId: String) {
		self.id = UUID()
		self.date = Date()
		self.sender = deviceId
	}

	init(text: String, deviceId: String) {
		self.init(deviceId: deviceId)
		self.text = text
	}

	init(image: UIImage, deviceId: String) {
		self.init(deviceId: deviceId)
		self.image = image
	}
}
