//
//  Device+.swift
//  GGUI
//
//  Created by John on 2019/2/26.
//  Copyright © 2019年 GGUI. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    /// 是否全面屏系列的设备
    var isIphoneXSeries: Bool {
        let device = Device.current
        return device.isOneOf(Device.allXSeriesDevices) || device.isOneOf(Device.allSimulatorXSeriesDevices)
    }

    /// 是否 4 寸的设备
    var is4InchDevice: Bool {
        let device = Device.current
        if device.isOneOf([
            Device.iPhone5,
            Device.simulator(.iPhone5),
            .iPhone5c,
            Device.simulator(.iPhone5c),
            .iPhone5s,
            Device.simulator(.iPhone5s),
            .iPhoneSE,
            Device.simulator(.iPhoneSE)]) {
            return true
        }
        return false
    }

    /// 获取当前设备的IP地址
    var IpAddress: String? {
        var addresses = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if ((flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) && (addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6)) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                        if let address = String(validatingUTF8: hostname) {
                            addresses.append(address)
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
}

public func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
}

public func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
}

public func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
}
