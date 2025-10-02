//
//  CryptoServices.swift
//  OBD1
//
//  Created by Gibran Shevaldo on 23/09/25.
//

import SwiftUI
import CryptoKit

class CryptoService {
    private let keychainService = KeychainService()
    private var encryptionKey: SymmetricKey

    init() {
        if let key = keychainService.loadKey() {
            self.encryptionKey = key
        } else {
            let newKey = SymmetricKey(size: .bits256)
            self.encryptionKey = newKey
            try? keychainService.saveKey(newKey)
            print("Crypto: No key found in keychain. Generated and saved a new one.")
        }
    }

    func encrypt(data: Data) throws -> Data {
        let sealedBox = try ChaChaPoly.seal(data, using: encryptionKey)
        return sealedBox.combined
    }

    func decrypt(data: Data) throws -> Data {
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        return try ChaChaPoly.open(sealedBox, using: encryptionKey)
    }
}
