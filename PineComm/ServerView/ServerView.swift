//
//  ServerView.swift
//  PineComm
//
//  Created by Евгений on 14.11.22.
//

import SwiftUI

struct ServerView: View {
	@ObservedObject var viewModel: ViewModel
	var multipeerService = MultipeerService(role: .server)

	var body: some View {
		ChatView(messages: $viewModel.messages, deviceId: viewModel.deviceId, isServerConnected: true)
		.onAppear {
			viewModel.start()
		}
		.onDisappear {
			viewModel.stop()
		}
	}
}
