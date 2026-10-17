//
//  MDI1_117_Ch_9_LoginKitApp.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Carlos Vera on 10/7/26.
//

import SwiftUI

@main
struct MDI1_117_Ch_9_LoginKitApp: App {
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("-UITesting-Reset") {
            SessionStore().clear()
        }
    }
 
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
