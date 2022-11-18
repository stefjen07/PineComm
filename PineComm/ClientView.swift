//
//  ClientView.swift
//  PineComm
//
//  Created by Евгений on 13.11.22.
//

import SwiftUI

struct ClientView: View {
	@ObservedObject var viewModel: ViewModel

    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			ChatView(messages: viewModel.messages, deviceId: viewModel.deviceId)

			HStack {
				Spacer()
			}
				.frame(height: 2)
				.background(Color("SecondaryBackground"))
			HStack {
				TextField("message", text: $viewModel.currentMessage)
				Button(action: viewModel.sendMessage, label: {
					Image(systemName: "paperplane.fill")
						.resizable()
						.foregroundColor(.white)
						.aspectRatio(contentMode: .fit)
						.frame(width: 20)
						.padding(12)
						.offset(x: -2)
						.background(
							Circle()
								.foregroundColor(viewModel.isSendingDisabled ? .gray : .blue)
						)
				})
				.disabled(viewModel.isSendingDisabled)
				.padding(5)
			}
			.padding(.horizontal, 10)
			.padding(.top, 5)
			.padding(.bottom, 10)
			.background(
				Color("SecondaryBackground")
					.opacity(0.5)
					.edgesIgnoringSafeArea(.all)
			)
		}
		.navigationBarItems(trailing: Button(action: viewModel.startPickingImage, label: {
			Image(systemName: "photo.circle")
		}))
		.sheet(isPresented: $viewModel.isPickingImage) {
			ImagePicker { image in
				viewModel.sendImage(image)
			}
			.edgesIgnoringSafeArea(.all)
		}
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
		ClientView(viewModel: .init())
    }
}
