//
//  PhotoSaveHelper.swift
//  ElegantUI
//
//  Created by John on 2019/5/22.
//  Copyright © 2018 ElegantUI. All rights reserved.
//

import UIKit
import Photos

public class PhotoSaveHelper: NSObject {
    public static let share = PhotoSaveHelper()

    private var writeToAlbumCompletionBlock: ResponseBlock?

    /// 保存图片
    public func writeImageToAlbum(image: UIImage, completion: ResponseBlock? = nil) {
        writeToAlbumCompletionBlock = completion
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
                if status == .authorized {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                } else {
                    self?.writeToAlbumCompletionBlock?(false, "notDetermined")
                }
            })
        case .authorized:
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        default:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            })
        }
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            writeToAlbumCompletionBlock?(false, error.localizedRecoverySuggestion)
            return
        }
        writeToAlbumCompletionBlock?(true, nil)
    }
}
