//
//  CaptureMetaData.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 24/09/25.
//

import Foundation

extension CaptureMetadata {
    @objc(addDetectionsObject:)
    @NSManaged public func addToDetections(_ value: Detection)

    @objc(removeDetectionsObject:)
    @NSManaged public func removeFromDetections(_ value: Detection)

    @objc(addDetections:)
    @NSManaged public func addToDetections(_ values: NSSet)

    @objc(removeDetections:)
    @NSManaged public func removeFromDetections(_ values: NSSet)
}
