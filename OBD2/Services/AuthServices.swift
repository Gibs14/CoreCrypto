//
//  AuthServices.swift
//  OBD1
//
//  Created by Gibran Shevaldo on 23/09/25.
//

import SwiftUI
import LocalAuthentication

class AuthenticationService {
    private var context = LAContext()

    func authenticate() async -> Bool {
        do {
            let reason = "Please authenticate to access your secure captures."
            return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        } catch {
            print("Authentication failed: \(error.localizedDescription)")
            return false
        }
    }
}
