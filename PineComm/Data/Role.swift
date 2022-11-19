//
//  Role.swift
//  PineComm
//
//  Created by Евгений on 20.11.22.
//

import SwiftUI

enum Role: String, Identifiable, CaseIterable {
	case server
	case client

	var id: Int {
		rawValue.hashValue
	}

	var description: String {
		switch self {
		case .server:
			return "server".localized
		case .client:
			return "client".localized
		}
	}

	var color: Color {
		switch self {
		case .server:
			return .blue
		case .client:
			return .green
		}
	}
}
