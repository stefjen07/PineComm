//
//  MessageView.swift
//  PineComm
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

struct MessageView: View {
	var message: Message
	var deviceId: String
	var imageWidth: CGFloat

	@Binding var imageToShow: UIImage?

	var body: some View {
		HStack {
			if message.sender == deviceId {
				Spacer()
			}
			VStack {
				if let text = message.text {
					Text(text)
						.padding(10)
						.background(Color("SecondaryBackground"))
				}
				if let image = message.image {
					Button(action: {
						imageToShow = image
					}, label: {
						Image(uiImage: image)
							.resizable()
							.aspectRatio(contentMode: .fit)
					})
					.frame(width: imageWidth)
				}
			}
			.cornerRadius(10)
			.padding(.horizontal, 10)
			.padding(.vertical, 3)
			if message.sender != deviceId {
				Spacer()
			}
		}
	}
}
