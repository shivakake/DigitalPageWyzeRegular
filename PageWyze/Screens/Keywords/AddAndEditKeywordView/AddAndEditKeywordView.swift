//
//  AddAndEditKeywordView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 13/01/23.
//

import Cocoa

class AddAndEditKeywordView: NSView {
    
    @IBOutlet weak var userInteractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var mainHeaderTitleLabel: NSTextField!
    @IBOutlet weak var descriptionView: NSView!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var descriptionTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    
    public var onBackClick: (() -> Void)?
    public var websiteLogic: WebsitesLogic?
    public var keywordLogic: KeywordLogic?
    public var keywordModel: KeywordDetailsDataModel?
    public weak var delegate: KeywordLogicDelegate?
    
    init(keywordLogic: KeywordLogic?, keywordDelegate: KeywordLogicDelegate?, keywordModel: KeywordDetailsDataModel?, websiteLogic: WebsitesLogic?) {
        super.init(frame: .zero)
        self.keywordLogic = keywordLogic
        self.delegate = keywordDelegate
        self.keywordModel = keywordModel
        self.websiteLogic = websiteLogic
        commonMethods()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethods()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    fileprivate func addView() {
        Bundle(for: AddAndEditKeywordView.self).loadNibNamed("AddAndEditKeywordView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        setupUI()
    }
    
    public func setupUI() {
        assignValuesToUI()
        mainHeaderTitleLabel.font = .styleSelectionForLargeTitle
        mainHeaderTitleLabel.textColor = StyleSheet.addHeaderTitleColor
        descriptionView.setBorder(color: .lightGray)
        cancelButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        createButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        cancelButton.font = .boldSystemFont(ofSize: 12)
        createButton.font = .boldSystemFont(ofSize: 12)
        descriptionTextView.delegate = self
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: nil, userInfo: [:]))
    }
    
    public func assignValuesToUI() {
        if keywordModel != nil {
            mainHeaderTitleLabel.stringValue = "Edit Keyword"
            self.descriptionTextView.string = keywordModel?.name ?? ""
        }
    }
    
    @IBAction func createButtonTapped(_ sender: NSButton) {
        
        guard let descriptionString = descriptionTextView?.string else { return }
        
        keywordLogic?.delegate = delegate
        
        if keywordLogic?.keywordDetailsData != nil {
            keywordLogic?.editKeyword(websiteId: self.websiteLogic?.websiteDetailsModel?.id, keywordId: self.keywordLogic?.keywordDetailsData?.id, name: descriptionString)
        } else {
            if descriptionString.isEmpty {
                FunctionsExtension.sharedInstance.showValidationAlert(messgae: "Enter Description")
            }else{
                keywordLogic?.addNewKeyword(websiteId: self.websiteLogic?.websiteDetailsModel?.id, name: descriptionString , pageId: "none")
            }
        }
        onBackClick?()
        self.removeFromSuperview()
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
}

extension AddAndEditKeywordView : NSTextViewDelegate {
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let newText = (textView.string as NSString).replacingCharacters(in: affectedCharRange, with: replacementString!)
        let numberOfChars = newText.count
        return numberOfChars <= 250
    }
    
    public func textDidChange(_ notification: Notification) {
        let height = descriptionTextView.attributedString().height(containerWidth: descriptionTextView.frame.size.width)
        descriptionTextViewConstraint.constant = height < 300 ? height: 300
    }
}
