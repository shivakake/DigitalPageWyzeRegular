//
//  RolesDetailsView.swift
//  WebSites
//
//  Created by Nagendar on 04/01/23.
//

import Cocoa

class RolesDetailsView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var discriptionLabel: NSTextField!
    @IBOutlet weak var informationLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var moreButton: NSButton!
    
    public var websiteLogic: WebsitesLogic?
    public var teamLogic: TeamsLogic?
    public weak var delegate: TeamsLogicDelegate?
    public var roleDetailsModel: RoleDataModel?
    public var onBackClick: (() -> Void)?
    public var moreArray: [PopUpMenuItemModel] = []
    
    init(teamlogic: TeamsLogic?, delegate: TeamsLogicDelegate?, websiteLogic: WebsitesLogic?, roleDetails: RoleDataModel?) {
        self.teamLogic = teamlogic
        self.delegate = delegate
        self.websiteLogic = websiteLogic
        self.roleDetailsModel = roleDetails
        super.init(frame: .zero)
        commonMethods()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethods()
    }
    
    public func commonMethods() {
        addView()
        textStyling()
        updateData(roleModel: roleDetailsModel)
        setStatusAndMenu(for: "live")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    fileprivate func addView() {
        Bundle(for: RolesDetailsView.self).loadNibNamed("RolesDetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func textStyling(){
        titleLabel.font = .styleSelectionBoldText
        informationLabel.font = .systemFont(ofSize: 12, weight: .regular)
        discriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    @IBAction func moreButtonTapped(_ sender: NSButton) {
        
        let controller = PopUpMenuViewController(menuItems: moreArray)
        controller.applyConstraintForImage(with: 20)
        let height = ((moreArray.count * 30) + 5)
        controller.applyConstraintForCompleteMenu(tableSize: CGSize(width: 120, height: height))
        
        controller.onSelectedItemModel = { [weak self] selectedItem in
            guard let _self = self else { return }
            if selectedItem.strID == "edit"{
                _self.onEditOperationTapped()
            } else{
                _self.teamLogic?.delegate = self
                _self.teamLogic?.deleteTeamMember(websiteId: _self.websiteLogic?.websiteDetailsModel?.id, teamMemberId: _self.teamLogic?.teamMemberDetailsData?.id)
            }
        }
        
        window?.contentViewController?.present(controller, asPopoverRelativeTo: .init(x: 0, y: 0, width: 120, height: height), of: moreButton, preferredEdge: .maxY, behavior: .transient)
    }
    
    @objc func onEditOperationTapped() {
        let addEditView = AddAndEditRoleView(teamLogic: teamLogic, teamDelegate: self, roleModel: roleDetailsModel, websiteLogic: websiteLogic)
        userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    public func setStatusAndMenu(for status: String?) {
        
        let editMenu = PopUpMenuItemModel(strMenuID: "edit", menuName: "Edit" , menuImage: "edits")
        
        switch status?.lowercased() {
        
        case "active", "live":
            moreArray = [editMenu]
        default:
            break
        }
    }
    
    func updateData(roleModel: RoleDataModel?) {
        titleLabel.stringValue = roleModel?.name ?? ""
        discriptionLabel.stringValue = roleModel?.description ?? ""
    }
}

extension RolesDetailsView : TeamsLogicDelegate {
    
    func editRoleInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateData(roleModel: _self.teamLogic?.rolesListArray[index])
            _self.delegate?.editRoleInQueue(index: index)
        }
    }
    
    func updateEditRole(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.setStatusAndMenu(for: dataStatus)
            _self.updateData(roleModel: _self.teamLogic?.rolesListArray[index])
            _self.delegate?.updateEditRole(index: index, dataStatus: dataStatus)
        }
    }
    
    func getTeamsListFromResponse() { }
    
    func getRolesListFromResponse() { }
    
    func addNewTeamMemberInQueue() { }
    
    func updateAddTeamMemberSuccess(status: Int?, index: Int?) { }
    
    func getTeamDetailsFromResponse() { }
    
    func editTeamMemberInQueue(index: Int) { }
    
    func updateEditTeamMember(index: Int, dataStatus: String?) { }
    
    func teamMemberStatusChangeForQueue(index: Int) { }
    
    func updateDeleteTeamMemberSuccess(status: Int?, index: Int) { }
    
    func addNewRoleInQueue() { }
    
    func updateAddRoleSuccess(status: Int?, index: Int?) { }
    
    func showPoorInternet() { }
}
