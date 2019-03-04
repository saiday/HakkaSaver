//
//  PreferencesWindowController.swift
//  HakkaSaver
//
//  Created by saiday on 2019/3/5.
//  Copyright © 2019 saiday. All rights reserved.
//

import Cocoa
import ScreenSaver

protocol WindowSheetDelegate {
    func sheetClosed(code: NSApplication.ModalResponse)
}

class PreferencesWindowController: NSWindowController {
    weak var delegate: WindowSheetDelegate? = nil
}
