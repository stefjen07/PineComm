//
//  RolePickerView.swift
//  PineComm
//
//  Created by Евгений on 13.11.22.
//

import SwiftUI

struct RolePickerView: View {
    var body: some View {
		VStack {
			Spacer()
			Text("choose-role")
				.font(.largeTitle)
				.bold()
			ForEach(Role.allCases) { role in
				Spacer()
				NavigationLink(destination: {
					switch role {
					case .server:
						AnyView(ServerView(viewModel: .init()))
					case .client:
						AnyView(ClientView(viewModel: .init()))
					}
				}, label: {
					Text(role.description)
						.font(.title)
						.bold()
						.foregroundColor(.white)
						.padding(80)
						.background(
							Circle()
								.foregroundColor(role.color)
						)
				})
			}
			Spacer()
		}
    }
}

struct RolePickerView_Previews: PreviewProvider {
    static var previews: some View {
        RolePickerView()
    }
}
