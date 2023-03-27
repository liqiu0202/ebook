//
//  quickreadApp.swift
//  quickread
//
//  Created by Li Qiu on 3/18/23.
//

import SwiftUI

@main
struct quickreadApp: App {
    @StateObject private var bookManager = BookManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookManager)
        }
    }
}
