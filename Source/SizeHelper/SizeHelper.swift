//
//  SizeHelper
//  ElegantUI
//
//  Created by John on 2019/1/21.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import UIKit

/*
iPhone                   | 状态栏 | 状态栏  |    导航栏    | 导航栏     | tabBar     |    tabBar
                         | 竖屏   | 横屏   |    竖屏      | 横屏       | 竖屏       |    横屏
5s/SE/6/6s/7/8(iOS10)    | 20    | 20    |    44        | 32        | 49        |    49
5s/SE/6/6s/7/8(iOS11)    | 20    | 20    |    44        | 32        | 49        |    32
6/6s/7/8 Plus            | 20    | 20    |    44        | 44        | 49        |    49
X/XS                     | 44    | 0     |    44        | 32        | 83(49+34) |    53(32+21)
XR/XS Max                | 44    | 0     |    44        | 44        | 83(49+34) |    70(49+21)
*/
public class Size {
    static let share = Size()
    private let tabarController = UITabBarController()
    private let navigationController = UINavigationController()

    /// 屏幕宽度
    public static var screenWidth = UIScreen.main.bounds.width
    /// 屏幕高度
    public static var screenHeight = UIScreen.main.bounds.height
    /// 屏幕最大边
    public static var screenMax = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    /// 屏幕最小边
    public static var screenMin = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)

    /// 屏幕宽度(考虑屏幕旋转)
    public static var screenWidthConsiderOrientation: CGFloat {
        if case .portrait = Device.current.orientation {
            return screenMin
        }
        return screenMax
    }

    /// 屏幕高度(考虑屏幕旋转)
    public static var screenHeightConsiderOrientation: CGFloat {
        if case .portrait = Device.current.orientation {
            return screenMax
        }
        return screenMin
    }

    /// NavagationBar 高度 (屏幕宽度小于400的设备横屏时为32，其余情况为44)
    public static var navigationBarHeight: CGFloat {
        return statusBarHeight + share.navigationController.navigationBar.frame.height
    }

    /// TabBar 高度 (屏幕宽度小于400的设备在iOS11以上的系统横屏时为32，其余情况为49)
    public static var tabBarHeight: CGFloat {
        return bottomSafeAreaHeight + Size.share.tabarController.tabBar.frame.height
//        UIApplication.shared.keyWindow?.safeAreaInsets.bottom
    }

    /// BottomSafeAreaHeight（如果是iPhone X则为34 (竖屏)，21(横屏)，其它为0）
    public static var bottomSafeAreaHeight: CGFloat {
        if case .portrait = Device.current.orientation {
            return UIDevice.current.isIphoneXSeries ? 34 : 0
        }
        return UIDevice.current.isIphoneXSeries ? 21 : 0
    }

    /// StatusBar高度(全面屏iPhone竖屏44，全面屏iPhone横屏0，普通iPhone为20)
    public static var statusBarHeight: CGFloat {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        var topOffset = min(statusBarFrame.maxX, statusBarFrame.maxY)
        let isInCallStatusBar = topOffset == 40.0
        if isInCallStatusBar {
            topOffset -= 20.0
        }
        return topOffset
    }

    /// 计算内容时文字标签的 collectionView 的高度
    ///
    /// - Parameters:
    ///   - stringDatasource: 文字 Datasource
    ///   - collectionViewWidth: collectionView 的宽度
    ///   - rowHeight: collectionView 的行高
    ///   - lineSpacing: collectionView 的垂直间距
    ///   - interitemSpacing: collectionView 的水平间距
    ///   - stringInset: 文字距离 cell 左右边距之和
    ///   - stringFont: 文字的字体
    /// - Returns: 高度
    public static func collectionViewHeight(stringDatasource: [String],
                                            collectionViewWidth: CGFloat,
                                            rowHeight: CGFloat,
                                            lineSpacing: CGFloat,
                                            interitemSpacing: CGFloat,
                                            stringInset: CGFloat,
                                            stringFont: UIFont) -> CGFloat {
        guard stringDatasource.count > 0 else { return 0 }
        var totalHeight: CGFloat = lineSpacing
        var totalWidth: CGFloat = 0
        var rowCount: CGFloat = 1
        for string in stringDatasource {
            let titleWidth = string.widthForLabel(font: stringFont, height: rowHeight) + stringInset
            totalWidth += (titleWidth + interitemSpacing)
            if totalWidth > collectionViewWidth + interitemSpacing {
                totalWidth = titleWidth + interitemSpacing
                rowCount += 1
            }
        }
        totalHeight += rowCount * rowHeight + (rowCount - 1) * lineSpacing
        return totalHeight
    }

    /// 计算cell固定大小时 collectionView 高度
    ///
    /// - Parameters:
    ///   - total: cell总数
    ///   - collectionViewWidth: collectionView 的宽度
    ///   - cellSize: collectionViewCell size
    ///   - lineSpacing: collectionView 垂直间距
    ///   - interitemSpacing: collectionView 的水平间距
    public static func collectionViewHeight(total: NSInteger,
                                            collectionViewWidth: CGFloat,
                                            cellSize: CGSize,
                                            lineSpacing: CGFloat,
                                            interitemSpacing: CGFloat) -> CGFloat {
        let rowCount = Int((collectionViewWidth+interitemSpacing)/(cellSize.width+interitemSpacing))
        let rows: CGFloat = CGFloat(total/rowCount + (total%rowCount != 0 ? 1 : 0))
        return total > 0 ? cellSize.height * rows + lineSpacing * (rows - 1) : 0
    }
}
