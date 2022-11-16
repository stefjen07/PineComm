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
	@State var isPickingImage = false

    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
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
						.frame(width: 20)
						.padding(12)
						.offset(x: -2)
						.background(
							Circle()
								.foregroundColor(currentMessage.isEmpty ? .gray : .blue)
						)
				})
				.disabled(currentMessage.isEmpty)
				.padding(5)
			}
			.padding(.horizontal, 10)
			.padding(.top, 5)
			.padding(.bottom, 10)
			.background(Color("SecondaryBackground").opacity(0.5))
		}
		.navigationBarItems(trailing: Button(action: {
			isPickingImage = true
		}, label: {
			Image(systemName: "photo.circle")
		}))
		.sheet(isPresented: $isPickingImage) {
			ImagePicker { image in
				multipeerService.sendImage(image)
			}
			.edgesIgnoringSafeArea(.all)
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
