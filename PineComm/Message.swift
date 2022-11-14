//
//  Message.swift
//  PineComm
//
//  Created by Евгений on 14.11.22.
//

import Foundation

struct Message: Identifiable, Codable {
	var id: UUID
	var text: String
	var date: Date
	var sender: String
}
