//
//  ClientView-ViewModel.swift
//  PineComm
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

extension ClientView {
	@MainActor class ViewModel: ObservableObject {
		var multipeerService: MultipeerServiceProtocol

		@Published var currentMessage = ""
		@Published var isPickingImage = false
		@Published var isServerConnected = false
		@Published var messages: [Message] = []

		var deviceId: String {
			multipeerService.deviceId
		}

		var isSendingDisabled: Bool {
			currentMessage.isEmpty || !isServerConnected
		}

		func sendMessage() {
			multipeerService.sendMessage(currentMessage)
			currentMessage = ""
		}

		func sendImage(_ image: UIImage) {
			multipeerService.sendImage(image)
		}

		func startPickingImage() {
			isPickingImage = true
		}

		func start() {
			self.multipeerService.start()
		}

		func stop() {
			self.multipeerService.stop()
		}

		init(multipeerService: MultipeerServiceProtocol = MultipeerService(role: .client)) {
			self.multipeerService = multipeerService

			self.multipeerService.delegate = self
		}
	}
}

extension ClientView.ViewModel: MultipeerServiceDelegate {
	func multipeerService(_ service: MultipeerServiceProtocol, serverConnected isConnected: Bool) {
		isServerConnected = isConnected
	}

	func multipeerService(_ service: MultipeerServiceProtocol, receivedMessage message: Message) {
		DispatchQueue.main.async {
			self.messages.append(message)
		}
	}
}
