//
//  ChatView.swift
//  PineComm
//
//  Created by Евгений on 14.11.22.
//

import SwiftUI

struct ChatView: View {
	@Binding var messages: [Message]
	var deviceId: String

    var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				HStack {
					Spacer()
				}
				ForEach(messages) { message in
					HStack {
						if message.sender == deviceId {
							Spacer()
						}
						Text(message.text)
							.padding(10)
							.background(Color("SecondaryBackground"))
							.cornerRadius(10)
							.padding(.horizontal, 10)
					}
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
