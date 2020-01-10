//
//  SwiftTimer.swift
//  ElegantUI
//
//  Created by John on 08/28/19.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

public class SwiftTimer {
    private let internalTimer: DispatchSourceTimer
    private var isRunning = false
    private var handler: SwiftTimerHandler

    public let repeats: Bool
    public typealias SwiftTimerHandler = (SwiftTimer) -> Void

    public init(interval: DispatchTimeInterval, repeats: Bool = false,
                queue: DispatchQueue = .main, handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            guard let self = self else { return }
            handler(self)
        }
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            internalTimer.schedule(deadline: .now() + interval)
        }
    }

    public static func repeaticTimer(interval: DispatchTimeInterval, queue: DispatchQueue = .main, handler: @escaping SwiftTimerHandler) -> SwiftTimer {
        return SwiftTimer(interval: interval, repeats: true, queue: queue, handler: handler)
    }

    deinit {
        if !isRunning {
            internalTimer.resume()
        }
    }

    // You can use this method to fire a repeating timer without interrupting its regular firing schedule.
    // If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }

    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }

    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }

    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }

    public func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            guard let self = self else { return }
            handler(self)
        }
    }
}

// MARK: Throttle
public extension SwiftTimer {
    private static var timers = [String: DispatchSourceTimer]()

    static func throttle(interval: DispatchTimeInterval, identifier: String,
                         queue: DispatchQueue = .main, handler: @escaping () -> Void ) {
        if let previousTimer = timers[identifier] {
            previousTimer.cancel()
            timers.removeValue(forKey: identifier)
        }

        let timer = DispatchSource.makeTimerSource(queue: queue)
        timers[identifier] = timer
        timer.schedule(deadline: .now() + interval)
        timer.setEventHandler {
            handler()
            timer.cancel()
            timers.removeValue(forKey: identifier)
        }
        timer.resume()
    }

    static func cancelThrottlingTimer(identifier: String) {
        if let previousTimer = timers[identifier] {
            previousTimer.cancel()
            timers.removeValue(forKey: identifier)
        }
    }
}

// MARK: Count Down
public class SwiftCountDownTimer {
    private let internalTimer: SwiftTimer
    private var leftTimes: Int
    private let originalTimes: Int
    private let handler: (SwiftCountDownTimer, _ leftTimes: Int) -> Void

    public init(interval: DispatchTimeInterval, times: Int, queue: DispatchQueue = .main,
                handler:  @escaping (SwiftCountDownTimer, _ leftTimes: Int) -> Void ) {
        leftTimes = times
        originalTimes = times
        self.handler = handler
        internalTimer = SwiftTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        internalTimer.rescheduleHandler { [weak self] _ in
            guard let self = self else { return }
            if self.leftTimes > 0 {
                self.leftTimes = self.leftTimes - 1
                self.handler(self, self.leftTimes)
            } else {
                self.internalTimer.suspend()
            }
        }
    }

    public func start() {
        internalTimer.start()
    }

    public func suspend() {
        internalTimer.suspend()
    }

    public func reCountDown() {
        leftTimes = originalTimes
    }
}

public extension DispatchTimeInterval {
    static func fromSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return .milliseconds(Int(seconds * 1000))
    }
}
