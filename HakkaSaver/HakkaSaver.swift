//
//  HakkaSaver.swift
//  HakkaSaver
//
//  Created by saiday on 2019/1/3.
//  Copyright © 2019 saiday. All rights reserved.
//

import ScreenSaver
import os

@objc(HakkaSaver)
class HakkaSaver: ScreenSaverView {
    var previewShown = false
    var imageView: NSImageView!
    var label: NSTextField!
    
    // MARK: new properties
    typealias WindowInfo = [String: Any]
    let ScreenSaverWindowLayer = CGWindowLevelForKey(.screenSaverWindow)
    
    lazy var preferencesWindowController: PreferencesWindowController = {
        let pref = PreferencesWindowController()
        pref.delegate = self
        return pref
    }()

    var displayID: CGDirectDisplayID? {
        guard let devInfo = window?.screen?.deviceDescription else {
            os_log("Could not get device information for ScreenSaverView's screen",
                   type: .error)
            return nil
        }
        
        return devInfo [NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
    }
    
    /// Bounds of the display the current instance of ScreenSaverView is
    /// presented on in global screen space coordinates. `nil` if the device
    /// description of the screen can't be accessed which _shouldn't_ happen.
    var displayBounds: CGRect? {
        guard let displayID = displayID else {
            return nil
        }
        return CGDisplayBounds(displayID)
    }

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("not impletemted")
    }

    func screenshotImage() -> CGImage? {
        guard let onscreenWindows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [WindowInfo]? else {
            os_log("No windows are on screen", type: .info)
            return nil
        }
        
        guard let displayBounds = displayBounds else {
            return nil
        }
        
        // TODO: though CGWindowLevel > SCreenSaverWindowLayer but it still have chance see lock screen captured
        if let topWindow = onscreenWindows.filter({ $0["kCGWindowLayer"] as! CGWindowLevel > ScreenSaverWindowLayer }).reversed().first {
            os_log("aaaaaaaa had top window", type: .info)
            NSLog("aaaaaaaa had top window")
            return CGWindowListCreateImage(displayBounds, .optionOnScreenBelowWindow, topWindow["kCGWindowNumber"]! as! CGWindowID, .bestResolution)
        } else {
            os_log("aaaaaaaa no top window", type: .info)
            NSLog("aaaaaaaa no top window")
            return CGWindowListCreateImage(displayBounds, .optionOnScreenOnly, kCGNullWindowID, .bestResolution)
        }
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        guard let screenShot = screenshotImage() else {
            os_log("Could not take a screenshot")

            NSColor.clear.setFill()
            __NSRectFill(self.bounds)
            NSColor.black.set()
            let errorMessage:NSString = "Could not take a screenshot"
            errorMessage.draw(at: NSPoint(x: 100.0, y: 200.0), withAttributes:nil)

            return
        }

        let context = CIContext(options: nil)
        let originImage = CIImage(cgImage: screenShot)
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(originImage, forKey: kCIInputImageKey)
        filter.setValue(UserDefaultsManager.shared.blurRadius, forKey: "inputRadius")
        let resultImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
        let resizedImage = context.createCGImage(resultImage, from: originImage.extent)!
        let blurredScreenshot = CIImage(cgImage: resizedImage)
        blurredScreenshot.draw(in: rect,
                               from: blurredScreenshot.extent,
                               operation: .copy,
                               fraction: 1.0)
    }
}

extension HakkaSaver {
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        return preferencesWindowController.window
    }
}

extension HakkaSaver: WindowSheetDelegate {
    func sheetClosed(code: NSApplication.ModalResponse) {
        needsDisplay = code == .OK
    }
}
