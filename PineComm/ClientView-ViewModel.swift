//
//  ClientView-ViewModel.swift
//  PineComm
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

extension ClientView {
	@MainActor class ViewModel: ObservableObject {
		@ObservedObject var multipeerService: MultipeerService

		@Published var currentMessage = ""
		@Published var isPickingImage = false

		var messages: Binding<[Message]> {
			$multipeerService.messages
		}

		var deviceId: String {
			multipeerService.deviceId
		}

		var isSendingDisabled: Bool {
			currentMessage.isEmpty
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

		init(multipeerService: MultipeerService = MultipeerService(role: .client)) {
			self.multipeerService = multipeerService

			self.multipeerService.start()
		}
	}
}
