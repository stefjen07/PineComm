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
