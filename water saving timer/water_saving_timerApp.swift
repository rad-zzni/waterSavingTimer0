//
//  water_saving_timerApp.swift
//  water saving timer
//
//  Created by Radmehr Jowkar Dris on 12/8/25.
//

import SwiftUI

@main
struct water_saving_timerApp: App {
    @StateObject private var sharedState = SharedState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(WindowAccessor())
                .environmentObject(sharedState)

        }
    }
}

// Helper view to access NSWindow and change its opacity
struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let nsView = NSView()
        DispatchQueue.main.async {
            if let window = nsView.window {
                window.alphaValue = 0.95  // adjust opacity here
            }
        }
        return nsView
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}
