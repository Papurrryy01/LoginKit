//
//  DashboardView.swift
//  LoginKit
//
//  Created by Carlos Vera on 10/10/26.
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


            Button("Log Out", role: .destructive) {
                onLogout()
            }
            .buttonStyle(.bordered)
            .accessibilityIdentifier("logout_button")
            .padding(.top, 8)
            .disabled(!showActions)
            .opacity(showActions ? 1 : 0.4)

        }
        .padding()
        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
        .task {
            do {
                try await Task.sleep(for: entranceDelay)
            } catch {
                return
            }
            let animation: Animation? = ProcessInfo.processInfo.arguments.contains("-UITesting-NoAnimations") ? nil : .easeOut(duration: 0.4)
            withAnimation(animation) {
                showActions = true
            }
        }
    }

    // Simulates a dashboard that finishes loading its actions after it appears.
    private var entranceDelay: Duration {
        if ProcessInfo.processInfo.arguments.contains("-UITesting-NoAnimations") {
            return .zero
        }
        return .milliseconds(Int.random(in: 300...1500))
    }
}
