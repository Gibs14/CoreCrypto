//
//  CaptureConfirmationView.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 28/09/25.
//

import SwiftUI

struct CaptureConfirmationView: View {
    let imageData: Data
    var onConfirm: () -> Void
    var onRetake: () -> Void
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white, lineWidth: 2)).padding()
            }
            Spacer()
            HStack {
                Button(action: onRetake) { Text("Retake").font(.headline).padding().frame(maxWidth: .infinity).background(Color.black.opacity(0.5)).foregroundStyle(.white).clipShape(Capsule()) }
                Button(action: onConfirm) { Label("Save Securely", systemImage: "lock.fill").font(.headline).padding().frame(maxWidth: .infinity).background(.blue).foregroundStyle(.white).clipShape(Capsule()) }
            }.padding()
        }.background(Color.black.opacity(0.7).ignoresSafeArea())
    }
}
