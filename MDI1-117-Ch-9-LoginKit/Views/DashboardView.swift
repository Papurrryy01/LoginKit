//
//  DashboardView.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Andres de la Cruz on 10/7/26.
//

import SwiftUI
 
struct DashboardView: View {
    let user: User
    let onLogout: () -> Void

    @State private var showActions = false
 
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)
 
            Text("Welcome, \(user.name)")
                .font(.title2.bold())
                .accessibilityIdentifier("welcome_label")
 
            if showActions {
                Button("Log Out", role: .destructive) {
                    onLogout()
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("logout_button")
                .padding(.top, 8)
                .disabled(!showActions)
                .opacity(showActions ? 1 : 0.4)
            }
        }
        .padding()
        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
        .task {
            try? await Task.sleep(for: entranceDelay)
            withAnimation(.easeOut(duration: 0.4)) {
                showActions = true
            }
        }
    }

    // Simulates a dashboard that finishes loading its actions after it appears.
    // TODO (Exercise 3): return .zero when the app is launched with "-UITesting-NoAnimations"
    private var entranceDelay: Duration {
        .milliseconds(Int.random(in: 300...1500))
    }
}
