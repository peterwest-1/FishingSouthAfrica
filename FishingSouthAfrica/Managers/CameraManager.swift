//  CameraManager.swift
//  Fishing South Africa
//
//  Created by PV West on 2020/08/14.
//  Copyright © 2020 PV West. All rights reserved.
//

import Foundation
import Photos

struct CameraManager {
    static func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
            } else {}
        }

        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                } else {}
            }
        }
    }
}

