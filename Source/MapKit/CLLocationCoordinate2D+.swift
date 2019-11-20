//
//  CLLocationCoordinate2D+.swift
//  GGUI
//
//  Created by John on 2019/7/16.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation
import MapKit

// MARK: GCJ-02(火星坐标即中国国测局)、WGS-84（世界标准坐标）之间的转换
public extension CLLocationCoordinate2D {
    /// WGS-84 -> GCJ-02
    func wgsToGcj() -> CLLocationCoordinate2D {
        if isOutsideChina { return self }
        let (deltaLatitude, deltaLongitude) = delta(latitude: latitude, longitude: longitude)
        let revisedCoordinate = CLLocationCoordinate2D(latitude: latitude + deltaLatitude, longitude: longitude + deltaLongitude)
        return revisedCoordinate
    }

    /// GCJ-02 -> WGS-84
    func gcjToWgs() -> CLLocationCoordinate2D {
        if isOutsideChina { return self }
        let (deltaLatitude, deltaLongitude) = delta(latitude: latitude, longitude: longitude)
        let revisedCoordinate = CLLocationCoordinate2D(latitude: latitude - deltaLatitude, longitude: longitude - deltaLongitude)
        return revisedCoordinate
    }

    private var isOutsideChina: Bool {
        if longitude < 72.004 || longitude > 137.8347 {
            return true
        }
        if latitude < 0.8293 || latitude > 55.8271 {
            return true
        }
        return false
    }

    private func transformLatitude(x: Double, y: Double) -> Double {
        let first = sin(6.0 * x * Double.pi),
        second = sin(2.0 * x * Double.pi),
        third = sin(y * Double.pi),
        forth = sin(y / 3.0 * Double.pi),
        fifth = sin(y / 12.0 * Double.pi),
        sixth = sin(y * Double.pi / 30.0)

        var deltaLatitude = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y
        deltaLatitude += 0.1 * x * y + 0.2 * sqrt(abs(x))
        deltaLatitude += (20.0 * first + 20.0 * second) * 2.0 / 3.0
        deltaLatitude += (20.0 * third + 40.0 * forth) * 2.0 / 3.0
        deltaLatitude += (160.0 * fifth + 320 * sixth) * 2.0 / 3.0
        return deltaLatitude
    }

    private func transformLongitude(x: Double, y: Double) -> Double {
        let first = sin(6.0 * x * Double.pi),
        second = sin(2.0 * x * Double.pi),
        third = sin(x * Double.pi),
        forth = sin(x / 3.0 * Double.pi),
        fifth = sin(x / 12.0 * Double.pi),
        sixth = sin(x / 30.0 * Double.pi)

        var deltaLongitude = 300.0 + x + 2.0 * y + 0.1 * x * x
        deltaLongitude += 0.1 * x * y + 0.1 * sqrt(abs(x))
        deltaLongitude += (20.0 * first + 20.0 * second) * 2.0 / 3.0
        deltaLongitude += (20.0 * third + 40.0 * forth) * 2.0 / 3.0
        deltaLongitude += (150.0 * fifth + 300.0 * sixth) * 2.0 / 3.0
        return deltaLongitude
    }

    private func delta(latitude: Double, longitude: Double) -> (Double, Double) {
        let radious = 6378245.0
        let eValue = 0.00669342162296594323
        let radLatitude = latitude / 180.0 * Double.pi
        var magic = sin(radLatitude)
        magic = 1 - eValue * magic * magic
        let sqrtMagic = sqrt(magic)
        var deltaLatitude = transformLatitude(x: longitude - 105.0, y: latitude - 35.0)
        var deltaLongitude = transformLongitude(x: longitude - 105.0, y: latitude - 35.0)
        deltaLatitude = (deltaLatitude * 180.0) / ((radious * (1 - eValue)) / (magic * sqrtMagic) * Double.pi)
        deltaLongitude = (deltaLongitude * 180.0) / (radious / sqrtMagic * cos(radLatitude) * Double.pi)
        return (deltaLatitude, deltaLongitude)
    }
}
