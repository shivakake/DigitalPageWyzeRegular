//
//  ResponsesDetailsView.swift
//  WebSites
//
//  Created by Nagendar on 04/01/23.
//

import Cocoa

class ResponsesDetailsView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var emailLabel: NSTextField!
    @IBOutlet weak var mobileLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var informationLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var textDataLabel: NSTextField!
    
    var navCallBack: (() -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect )
        commonMethods()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethods()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public func commonMethods() {
        addView()
        textStyling()
    }
    
    fileprivate func addView() {
        Bundle(for: ResponsesDetailsView.self).loadNibNamed("ResponsesDetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func textStyling(){
        titleLabel.font = .styleSelectionBoldText
        informationLabel.font = .systemFont(ofSize: 12, weight: .regular)
        emailLabel.font = .systemFont(ofSize: 12, weight: .regular)
        mobileLabel.font = .systemFont(ofSize: 12, weight: .regular)
        nameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        typeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        textDataLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        navCallBack?()
        self.removeFromSuperview()
    }
}
