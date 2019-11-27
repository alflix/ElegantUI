//
//  CountdownButton.swift
//  GGUI
//
//  Created by John on 2019/3/12.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public enum CountdownButtonState {
    case countdowning
    case end
}

public typealias CountdownBlock = (_ state: CountdownButtonState, _ seconds: Int) -> Void

open class CountdownButton: UIButton {
    @IBInspectable public var seconds: Int = 60

    private var timer: SwiftCountDownTimer?
    public var countdownState: CountdownButtonState = .end

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// 开始倒计时
    public func startTimer(handler: CountdownBlock? = nil) {
        timer = SwiftCountDownTimer(interval: .fromSeconds(1),
                                    times: seconds,
                                    handler: { [weak self] (_, seconds) in
                                        guard let self = self else { return }
                                        handler?(.countdowning, seconds)
                                        if seconds > 0 {
                                            self.isEnabled = false
                                            self.countdownState = .countdowning
                                            handler?(.countdowning, seconds)
                                        } else {
                                            self.isEnabled = true
                                            self.countdownState = .end
                                            handler?(.end, seconds)
                                        }
        })
        timer?.start()
    }

    public func setupUI(title: String? = nil, titleColor: UIColor? = nil, borderColor: UIColor? = nil) {
        if let title = title {
            setTitle(title, for: [.normal, .disabled])
        }
        if let titleColor = titleColor {
            setTitleColor(titleColor, for: [.normal, .disabled])
        }
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
    }

    /// 结束倒计时
    public func invalidateTimer() {
        timer = nil
    }
}
