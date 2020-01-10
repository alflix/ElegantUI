//
//  SizeHelper
//  ElegantUI
//
//  Created by John on 2019/1/21.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import UIKit

public class Size {
    /// 屏幕宽度
    public static let screenWidth = UIScreen.main.bounds.width
    /// 屏幕高度
    public static let screenHeight = UIScreen.main.bounds.height
    /// NavagationBar 高度
    public static let navigationBarHeight: CGFloat = statusBarHeight + 44
    /// TabBar 高度
    public static let tabBarHeight: CGFloat = bottomSafeAreaHeight + 44
    /// BottomSafeAreaHeight，如果是iPhone X则为34，其它为0
    public static let bottomSafeAreaHeight: CGFloat = UIDevice.current.isIphoneXSeries ? 34 : 0

    /// StatusBar高度
    public static let statusBarHeight: CGFloat = {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        var topOffset = min(statusBarFrame.maxX, statusBarFrame.maxY)
        let isInCallStatusBar = topOffset == 40.0
        if isInCallStatusBar {
            topOffset -= 20.0
        }
        return topOffset
    }()

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
