//
//  PineCommApp.swift
//  PineComm
//
//  Created by Евгений on 13.11.22.
//

import SwiftUI

@main
struct PineCommApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationView {
				RolePickerView()
			}
        }
    }
}
