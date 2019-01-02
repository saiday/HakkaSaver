//
//  HakkaSaver.swift
//  HakkaSaver
//
//  Created by saiday on 2019/1/3.
//  Copyright © 2019 saiday. All rights reserved.
//

import ScreenSaver

@objc(HakkaSaver)
class HakkaSaver: ScreenSaverView {
    override func draw(_ rect: NSRect) {
        let img = CGWindowListCreateImage(rect
            , .optionOnScreenBelowWindow
            , CGWindowID(self.window!.windowNumber)
            , .bestResolution)!
        
        let context = NSGraphicsContext.current?.cgContext
        context?.draw(img, in: rect)
    }
    
    // TODO: extension override
    func isOpaque() -> Bool {
        return true
    }
    
    func performGammaFade() -> Bool {
        return false
    }
}
