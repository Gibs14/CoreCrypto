//
//  LockedView.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

struct LockedView: View {
    var onUnlock: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield.fill").font(.system(size: 80)).foregroundStyle(.blue)
            Text("Secure Area").font(.largeTitle).fontWeight(.bold)
            Text("Please authenticate to access the secure camera and your saved captures.").multilineTextAlignment(.center).padding(.horizontal)
            Button(action: onUnlock) {
                Label("Unlock with Face ID", systemImage: "faceid").font(.headline).padding().frame(maxWidth: .infinity).background(.blue).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 12))
            }.padding()
        }
    }
}
