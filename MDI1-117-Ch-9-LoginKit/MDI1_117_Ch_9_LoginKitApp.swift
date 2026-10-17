//
//  MDI1_117_Ch_9_LoginKitApp.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Carlos Vera on 10/7/26.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@main
struct MDI1_117_Ch_9_LoginKitApp: App {
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("-UITesting-Reset") {
            SessionStore().clear()
        }
        #if canImport(UIKit)
        if ProcessInfo.processInfo.arguments.contains("-UITesting-NoAnimations") {
            UIView.setAnimationsEnabled(false)
        }
        #endif
    }
 
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
