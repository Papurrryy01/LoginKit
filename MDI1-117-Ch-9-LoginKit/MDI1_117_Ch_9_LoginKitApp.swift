//
//  MDI1_117_Ch_9_LoginKitApp.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/7/26.
//

import SwiftUI

@main
struct MDI1_117_Ch_9_LoginKitApp: App {
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("-UITesting-Reset") {
            SessionStore().clear()
        }
        // TODO (Exercise 3): when launched with "-UITesting-NoAnimations",
        // call UIView.setAnimationsEnabled(false). You'll need `import UIKit`.
    }
 
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
