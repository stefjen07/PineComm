//
//  ChatView.swift
//  PineComm
//
//  Created by Евгений on 14.11.22.
//

import SwiftUI
import ScrollViewProxy

struct ChatView: View {
	@Binding var messages: [Message]
	var deviceId: String

	@State var imageToShow: UIImage?

    var body: some View {
		VStack {
			if messages.isEmpty {
				Spacer()
				HStack {
					Spacer()
					Text("no-messages")
						.foregroundColor(.secondary)
					Spacer()
				}
				Spacer()
			} else {
				GeometryReader { geometryProxy in
					ScrollView(showsIndicators: false) {
						ScrollViewReader { scrollProxy in
							ForEach(messages) { message in
								MessageView(
									message: message,
									deviceId: deviceId,
									imageWidth: geometryProxy.size.width * 0.45,
									imageToShow: $imageToShow
								)
								.scrollId(message.id)
							}
							.valueChanged(value: messages.last?.id) { id in
								scrollProxy.scrollTo(id, anchor: .bottom)
							}
						}
					}
				}
				.sheet(item: $imageToShow) { image in
					ARImageView(image: image)
						.edgesIgnoringSafeArea(.all)
				}
			}
		}
	}
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
		ChatView(messages: .constant([]), deviceId: "")
    }
}
