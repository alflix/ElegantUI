//
//  MapOPenURL.swift
//  GGUI
//
//  Created by John on 2018/10/25.
//  Copyright © 2018年 Ganguo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

public enum MapApp {
    case apple
    case goolge
    case amap
    case baidu
    case tencent
}

public extension UIApplication {
    /// 拨打系统电话
    ///
    /// - Parameter number: 电话号码
    static func makePhoneCall(number: String) {
        let phoneScheme = "tel:\(number)"
        guard let url = URL(string: phoneScheme) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (_) in }
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    /// 显示 actionSheet 的 AlertController 打开地图 app，支持 系统地图，Google 地图，高德地图，百度地图，腾讯地图
    /// - 需要在 LSApplicationQueriesSchemes 中设置白名单：
    ///   - 高德： iosamap
    ///   - Google：comgooglemaps
    ///   - 腾讯：qqmap
    ///   - 百度：baidumap
    /// - Parameters:
    ///   - coordinate: 目的地的坐标
    ///   - destination: 目的地名称
    ///   - viewController: 控制器
    static func openMap(to coordinate: CLLocationCoordinate2D,
                        _ destination: String,
                        by viewController: UIViewController) {
        let openAction: (_ url: String) -> Void = { url in
            var allowedCharacters = CharacterSet.alphanumerics
            allowedCharacters.insert(charactersIn: ".:/,&?=")
            if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: allowedCharacters), let openURL = URL(string: encodedUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(openURL)
                }
            }
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIApplication.canOpen(map: .apple) {
            alert.addAction(UIAlertAction(title: "systemMap".bundleLocalize, style: .default, handler: { (_) in
                let regionDistance: CLLocationDistance = 10000
                let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = destination
                mapItem.openInMaps(launchOptions: options)
            }))
        }
        // https://developers.google.com/maps/documentation/urls/ios-urlscheme
        if UIApplication.canOpen(map: .goolge) {
            alert.addAction(UIAlertAction(title: "googleMap".bundleLocalize, style: .default, handler: { (_) in
                let url = "comgooglemaps://?center=\(coordinate.latitude),\(coordinate.longitude)&daddr=\(destination)&zoom=14&directionsmode=driving"
                openAction(url)
            }))
        }
        // https://lbs.amap.com/api/amap-mobile/guide/ios/route
        if UIApplication.canOpen(map: .amap) {
            alert.addAction(UIAlertAction(title: "gaodeMap".bundleLocalize, style: .default, handler: { (_) in
                let url = "iosamap://path?sourceApplication=applicationName&sid=BGVIS1&did=BGVIS2&dlat=\(coordinate.latitude)&dlon=\(coordinate.longitude)&dname=\(destination)&dev=0&m=0&t=0"
                openAction(url)
            }))
        }
        // https://lbsyun.baidu.com/index.php?title=uri/api/ios
        if UIApplication.canOpen(map: .baidu) {
            alert.addAction(UIAlertAction(title: "baiduMap".bundleLocalize, style: .default, handler: { (_) in
                let url = "baidumap://map/direction?origin={{我的位置}}&destination=\(coordinate.latitude),\(coordinate.longitude)&mode=driving&src=JumpMapDemo"
                openAction(url)
            }))
        }
        // https://lbs.qq.com/uri_v1/guide-mobile-navAndRoute.html
        if UIApplication.canOpen(map: .tencent) {
            alert.addAction(UIAlertAction(title: "tencentMap".bundleLocalize, style: .default, handler: { (_) in
                let url = "qqmap://map/routeplan?type=drive&to=\(destination)&tocoord=\(coordinate.latitude),\(coordinate.longitude)&policy=1&referer=MapJump"
                openAction(url)
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel".bundleLocalize, style: .cancel, handler: { (_) in

        }))
        // https://stackoverflow.com/questions/24224916/presenting-a-uialertcontroller-properly-on-an-ipad-using-ios-8
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = viewController.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        viewController.present(alert, animated: true, completion: nil)
    }

    static func canOpen(map: MapApp) -> Bool {
        switch map {
        case .apple:
            return UIApplication.shared.canOpenURL(URL(string: "maps://")!)
        case .goolge:
            return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        case .amap:
            return UIApplication.shared.canOpenURL(URL(string: "iosamap://")!)
        case .baidu:
            return UIApplication.shared.canOpenURL(URL(string: "baidumap://")!)
        case .tencent:
            return UIApplication.shared.canOpenURL(URL(string: "qqmap://")!)
        }
    }
}
