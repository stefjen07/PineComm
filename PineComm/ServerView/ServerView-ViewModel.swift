//
//  ServerView-ViewModel.swift
//  PineComm
//
//  Created by Евгений on 20.11.22.
//

import Foundation

extension ServerView {
	@MainActor class ViewModel: ObservableObject {
		var multipeerService: MultipeerServiceProtocol

		@Published var messages: [Message] = []

		var deviceId: String {
			multipeerService.deviceId
		}

		func start() {
			self.multipeerService.start()
		}

		func stop() {
			self.multipeerService.stop()
		}

		init(multipeerService: MultipeerServiceProtocol = MultipeerService(role: .server)) {
			self.multipeerService = multipeerService

			self.multipeerService.delegate = self
		}
	}
}

extension ServerView.ViewModel: MultipeerServiceDelegate {
	func multipeerService(_ service: MultipeerServiceProtocol, serverConnected isConnected: Bool) {
		
	}

	func multipeerService(_ service: MultipeerServiceProtocol, receivedMessage message: Message) {
		DispatchQueue.main.async {
			self.messages.append(message)
		}
	}
}
