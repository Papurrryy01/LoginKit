//
//  DashboardView.swift
//  MDI1-117-Ch-9-LoginKit
//
//  Created by Carlos Vera on 10/7/26.
//

import SwiftUI
 
struct DashboardView: View {
    let user: User
    let onLogout: () -> Void
 
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
        }
        .padding()
        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
    }
}
