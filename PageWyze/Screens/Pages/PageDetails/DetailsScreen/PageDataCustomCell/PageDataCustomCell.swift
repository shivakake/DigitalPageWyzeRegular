//
//  PageDataCustomCell.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 01/03/23.
//

import Cocoa

class PageDataCustomCell: NSTableCellView {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var valueTextField: NSTextField!
    
    var pageData : PageDataListModel?
    var valusCallBack: ((String) -> Void)?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        valueTextField.delegate = self
    }
    
    func configureCell(pageDataModel: PageDataListModel?, websiteDataModel: PageDataModel?) {
        pageData = pageDataModel
        titleLabel.stringValue = (websiteDataModel?.name ?? "") + "(\(pageDataModel?.keyString ?? ""))"
        valueTextField.stringValue = "\(pageDataModel?.valueString ?? "")"
    }
}

extension PageDataCustomCell : NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        if let value = obj.object as? NSTextField {
            valusCallBack?(value.stringValue)
        }
    }
}
