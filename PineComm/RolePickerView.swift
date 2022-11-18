//
//  RolePickerView.swift
//  PineComm
//
//  Created by Евгений on 13.11.22.
//

import SwiftUI

enum Role: String, Identifiable, CaseIterable {
	case server
	case client

	var id: Int {
		rawValue.hashValue
	}

	var description: String {
		switch self {
		case .server:
			return "server".localized
		case .client:
			return "client".localized
		}
	}

	var color: Color {
		switch self {
		case .server:
			return .red
		case .client:
			return .blue
		}
	}
}

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
						AnyView(ServerView())
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
