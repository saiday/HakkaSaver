//
//  PreferencesWindowController.swift
//  HakkaSaver
//
//  Created by saiday on 2019/3/5.
//  Copyright © 2019 saiday. All rights reserved.
//

import Cocoa
import ScreenSaver

protocol WindowSheetDelegate: AnyObject {
    func sheetClosed(code: NSApplication.ModalResponse)
}

class PreferencesWindowController: NSWindowController {
    weak var delegate: WindowSheetDelegate? = nil
    weak var doneButton: NSButton!
    weak var cancelButton: NSButton!
    weak var blurRadiusTextField: NSTextField!

    override func loadWindow() {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
                          styleMask: [NSWindow.StyleMask.titled],
                          backing: .buffered,
                          defer: true)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let window = window else {
            return
        }
        
        setupSubviews(window: window)
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("arsars")
    }
    
    func setupSubviews(window: NSWindow) {
        let blurRadiusTextField = NSTextField(string: "text field")
        let formatter = RadiusNumberFormatter()
        blurRadiusTextField.formatter = formatter
        blurRadiusTextField.doubleValue = UserDefaultsManager.shared.blurRadius
        self.blurRadiusTextField = blurRadiusTextField
        
        let sliderLabal = NSTextField(labelWithString: "Blur Radius: ")
        
        let sliderStackView = NSStackView(views: [sliderLabal, blurRadiusTextField])
        sliderStackView.orientation = .horizontal
        
        let cancelButton = NSButton(title: "Cancel", target: self, action: #selector(windowClosed(sender:)))
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.keyEquivalent = "\u{1b}"
        self.cancelButton = cancelButton
        let doneButton = NSButton(title: "Done", target: self, action: #selector(windowClosed(sender:)))
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.keyEquivalent = "\r"
        self.doneButton = doneButton

        let buttonStackView = NSStackView(views: [cancelButton, doneButton])
        buttonStackView.orientation = .horizontal
        
        let controlStackView = NSStackView(views: [sliderStackView, buttonStackView])
        controlStackView.orientation = .vertical
        controlStackView.spacing = 20

        window.contentView?.addSubview(controlStackView)
        // 淪落到用原生 AutoLayout API
        controlStackView.trailingAnchor.constraint(equalTo: window.contentView!.trailingAnchor, constant: -20).isActive = true
        controlStackView.leadingAnchor.constraint(equalTo: window.contentView!.leadingAnchor, constant: 20).isActive = true
        controlStackView.topAnchor.constraint(equalTo: window.contentView!.topAnchor, constant: 20).isActive = true
        controlStackView.bottomAnchor.constraint(equalTo: window.contentView!.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func windowClosed(sender: NSButton) {
        let response: NSApplication.ModalResponse = sender == doneButton ? .OK : .cancel
        
        if case .OK = response {
            UserDefaultsManager.shared.blurRadius = blurRadiusTextField.doubleValue
        }
        
        window?.sheetParent?.endSheet(window!, returnCode: response)
        delegate?.sheetClosed(code: response)
    }
}
