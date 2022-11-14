//
//  ServerView.swift
//  PineComm
//
//  Created by Евгений on 14.11.22.
//

import SwiftUI

struct ServerView: View {
	@ObservedObject var multipeerService = MultipeerService(role: .server)

	var body: some View {
		ChatView(messages: $multipeerService.messages, deviceId: multipeerService.deviceId)
			.onAppear {
				multipeerService.start()
			}
	}
}
