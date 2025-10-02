//
//  AppViewModel.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import Foundation

@MainActor
class AppViewModel: ObservableObject {
    @Published var isUnlocked = false
    private let authService = AuthenticationService()
    
    func unlockApp() {
        Task {
            if await authService.authenticate() { isUnlocked = true }
        }
    }
}
