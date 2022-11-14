//
//  ClientView.swift
//  PineComm
//
//  Created by Евгений on 13.11.22.
//

import SwiftUI

struct ClientView: View {
	@ObservedObject var multipeerService = MultipeerService(role: .client)

	@State var currentMessage = ""

    var body: some View {
		VStack(alignment: .leading) {
			ChatView(messages: $multipeerService.messages, deviceId: multipeerService.deviceId)

			HStack {
				Spacer()
			}
				.frame(height: 2)
				.background(Color("SecondaryBackground"))
			HStack {
				TextField("Сообщение", text: $currentMessage)
				Button(action: {
					multipeerService.sendMessage(currentMessage)
					currentMessage = ""
				}, label: {
					Image(systemName: "paperplane.fill")
						.resizable()
						.foregroundColor(.white)
						.aspectRatio(contentMode: .fit)
						.frame(width: 25)
						.padding(12)
						.offset(x: -2)
						.background(
							Circle()
								.foregroundColor(.blue)
						)
				})
			}
			.padding(.horizontal, 10)
			.padding(.top, 5)
			.padding(.bottom, 10)
		}
		.onAppear {
			multipeerService.start()
		}
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView()
    }
}
