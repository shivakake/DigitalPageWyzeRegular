//
//  AddAndEditRoleView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 13/01/23.
//

import Cocoa

class AddAndEditRoleView: NSView {
    
    @IBOutlet weak var userInteractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var mainHeaderTitleLabel: NSTextField!
    @IBOutlet weak var roleNameView: NSView!
    @IBOutlet weak var roleNameTextField: NSTextField!
    @IBOutlet weak var descriptionView: NSView!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    
    public var onBackClick: (() -> Void)?
    public var websiteLogic: WebsitesLogic?
    public var teamLogic: TeamsLogic?
    public var roleModel: RoleDataModel?
    public weak var delegate: TeamsLogicDelegate?
    
    init(teamLogic: TeamsLogic?, teamDelegate: TeamsLogicDelegate?, roleModel: RoleDataModel?, websiteLogic: WebsitesLogic?) {
        super.init(frame: .zero)
        self.teamLogic = teamLogic
        self.delegate = teamDelegate
        self.roleModel = roleModel
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
        Bundle(for: AddAndEditRoleView.self).loadNibNamed("AddAndEditRoleView", owner: self, topLevelObjects: nil)
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
        roleNameView.setBorder(color: .lightGray)
        descriptionView.setBorder(color: .lightGray)
        cancelButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        createButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        cancelButton.font = .boldSystemFont(ofSize: 12)
        createButton.font = .boldSystemFont(ofSize: 12)
        descriptionTextView.delegate = self
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: nil, userInfo: [:]))
    }
    
    public func assignValuesToUI() {
        if roleModel != nil {
            mainHeaderTitleLabel.stringValue = "Edit Role"
            roleNameTextField.stringValue = roleModel?.name ?? ""
            descriptionTextView.string = roleModel?.description ?? ""
        }
    }
    
    @IBAction func createButtonTapped(_ sender: NSButton) {
        
        guard let roleName = roleNameTextField?.stringValue else { return }
        guard let descriptionString = descriptionTextView?.string else { return }
        
        teamLogic?.delegate = delegate
        if self.roleModel != nil {
            teamLogic?.editRole(websiteId: websiteLogic?.websiteDetailsModel?.id, roleId: roleModel?.id, description: descriptionString, roleName: roleName)
        } else {
            if roleName.isEmpty {
                FunctionsExtension.sharedInstance.showValidationAlert(messgae: "Enter Role Name")
            }else{
                teamLogic?.addNewRole(websiteId: self.websiteLogic?.websiteDetailsModel?.id, name: roleName, description: descriptionString)
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

extension AddAndEditRoleView : NSTextViewDelegate {
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let newText = (textView.string as NSString).replacingCharacters(in: affectedCharRange, with: replacementString!)
        let numberOfChars = newText.count
        return numberOfChars <= 250
    }
    
    public func textDidChange(_ notification: Notification) {
        let height = descriptionTextView.attributedString().height(containerWidth: descriptionTextView.frame.size.width)
        descriptionTextViewHeight.constant = height < 300 ? height: 300
    }
}
