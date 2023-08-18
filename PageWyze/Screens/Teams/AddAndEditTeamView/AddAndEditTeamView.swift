//
//  AddAndEditTeamView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 13/01/23.
//

import Cocoa

class AddAndEditTeamView: NSView {
    
    @IBOutlet weak var userInteractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var mainHeaderTitleLabel: NSTextField!
    
    @IBOutlet weak var emailOrMobileView: NSView!
    @IBOutlet weak var emailOrMobileTextField: NSTextField!
    
    @IBOutlet weak var titleView: NSView!
    @IBOutlet weak var titleTextField: NSTextField!
    
    @IBOutlet weak var roleTextView: NSView!
    @IBOutlet weak var roleTitleTextField: NSTextField!
    @IBOutlet weak var rolesPanelView: WenoiVisualPanelView!
    
    @IBOutlet weak var descriptionTitleLabel: NSTextField!
    @IBOutlet weak var descriptionView: NSView!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var createButton: NSButton!
    
    public var onBackClick: (() -> Void)?
    public var websiteLogic: WebsitesLogic?
    public var teamLogic: TeamsLogic?
    public var teamModel: TeamDetailsDataModel?
    public weak var delegate: TeamsLogicDelegate?
    public var roleList: [WenoiVisualPanelModel] = [WenoiVisualPanelModel]()
    public var userSelectedRoleId: String?
    
    init(teamLogic: TeamsLogic?, teamDelegate: TeamsLogicDelegate?, teamModel: TeamDetailsDataModel?, websiteLogic: WebsitesLogic?) {
        super.init(frame: .zero)
        self.teamLogic = teamLogic
        self.delegate = teamDelegate
        self.teamModel = teamModel
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
        Bundle(for: AddAndEditTeamView.self).loadNibNamed("AddAndEditTeamView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        setupUI()
        descriptionTextView.delegate = self
    }
    
    public func getRoleListFromAPI() {
        userInteractionHandlerView.isUserInteractionEnabled = false
        teamLogic?.delegate = self
        teamLogic?.getTeamsRolesList(websiteId: websiteLogic?.websiteDetailsModel?.id)
    }
    
    public func setupUI() {
        
        getRoleListFromAPI()
        mainHeaderTitleLabel.font = .styleSelectionForLargeTitle
        mainHeaderTitleLabel.textColor = StyleSheet.addHeaderTitleColor
        
        emailOrMobileView.setBorder(color: .lightGray)
        titleView.setBorder(color: .lightGray)
        rolesPanelView.setBorder(color: .lightGray)
        roleTextView.setBorder(color: .lightGray)
        rolesPanelView.isHidden = true
        descriptionView.setBorder(color: .lightGray)
        
        cancelButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        createButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        cancelButton.font = .boldSystemFont(ofSize: 12)
        createButton.font = .boldSystemFont(ofSize: 12)
        
        roleTitleTextField.isEditable = false
        
        roleTitleTextField.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(roleTextFieldTapped)))
        
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: nil, userInfo: [:]))
        
        assignValuesToUI()
    }
    
    @objc func roleTextFieldTapped() {
        rolesPanelView.isHidden = !rolesPanelView.isHidden
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    @IBAction func createButtonTapped(_ sender: NSButton) {
        
        guard let email = emailOrMobileTextField?.stringValue else { return }
        guard let title = titleTextField?.stringValue else { return }
        guard let descriptionString = descriptionTextView?.string else { return }
        guard let roleName = roleTitleTextField?.stringValue else { return }
        
        teamLogic?.delegate = delegate
        if self.teamModel != nil {
            // we cant edit email by this api, need to check this
            teamLogic?.editTeamMember(websiteId: self.websiteLogic?.websiteDetailsModel?.id, teamMemberId: self.teamModel?.id, title: title, roleId: userSelectedRoleId, description: descriptionString, roleName: roleName)
        } else {
            if email.isEmpty {
                FunctionsExtension.sharedInstance.showValidationAlert(messgae: "Enter Email")
            }else{
                teamLogic?.addNewTeamMember(websiteId: self.websiteLogic?.websiteDetailsModel?.id, signedUpEmail: email, title: title, role: userSelectedRoleId, description: descriptionString)
            }
        }
        onBackClick?()
        self.removeFromSuperview()
    }
    
    fileprivate func assignValuesToCollection() {
        self.rolesPanelView.setUpCollectionView(with: self.roleList.map({ WenoiVisualPanelModel(language: ($0.strTitle ?? "", $0.strId ?? ""))}), defaultImage: NSImage(named: "type") ?? NSImage(), hideStatus: true, hideSearchBar: true)
        rolesPanelView.fetchedCountryOrLanguage = { [weak self] selectedID, selectedValue in
            guard let _self = self else { return }
            _self.userSelectedRoleId = selectedID ?? ""
            _self.roleTitleTextField.stringValue = selectedValue ?? "none"
            _self.typeTapped()
        }
    }
    
    public func typeTapped() {
        rolesPanelView.isHidden = true
    }
    
    public func assignValuesToUI() {
        if teamModel != nil {
            mainHeaderTitleLabel.stringValue = "Edit Team"
            titleTextField.stringValue = teamModel?.title ?? ""
            descriptionTextView.string = teamModel?.description ?? ""
            roleTitleTextField.stringValue = teamModel?.rolename ?? ""
            emailOrMobileTextField.stringValue = teamModel?.name ?? ""
            userSelectedRoleId = teamModel?.role
        }
    }
}

extension AddAndEditTeamView : NSTextViewDelegate {
    
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

extension AddAndEditTeamView : TeamsLogicDelegate {
    
    func editRoleInQueue(index: Int) { }
    
    func updateEditRole(index: Int, dataStatus: String?) { }
    
    func addNewRoleInQueue() { }
    
    func updateAddRoleSuccess(status: Int?, index: Int?) { }
    
    func getRolesListFromResponse() {
        for role in teamLogic?.rolesListArray ?? []{
            let newRole = WenoiVisualPanelModel(language: (role.name ?? "", role.id ?? ""))
            roleList.append(newRole)
        }
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userInteractionHandlerView.isUserInteractionEnabled = true
            _self.assignValuesToCollection()
        }
    }
    
    func getTeamsListFromResponse() { }
    
    func getTypesListFromResponse() { }
    
    func addNewTeamMemberInQueue() { }
    
    func updateAddTeamMemberSuccess(status: Int?, index: Int?) { }
    
    func getTeamDetailsFromResponse() { }
    
    func editTeamMemberInQueue(index: Int) { }
    
    func updateEditTeamMember(index: Int, dataStatus: String?) { }
    
    func teamMemberStatusChangeForQueue(index: Int) { }
    
    func updateDeleteTeamMemberSuccess(status: Int?, index: Int) { }
    
    func showPoorInternet() { }
}
