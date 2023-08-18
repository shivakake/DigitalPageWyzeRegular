//
//  TeamDetailsView.swift
//  WebSites
//
//  Created by Nagendar on 04/01/23.
//

import Cocoa

class TeamDetailsView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var informationLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var roleLabel: NSTextField!
    @IBOutlet weak var discriptionDataLabel: NSTextField!
    @IBOutlet weak var moreButton: NSButton!
    
    public var websiteLogic: WebsitesLogic?
    public var teamLogic: TeamsLogic?
    public weak var delegate: TeamsLogicDelegate?
    public var teamDetailsModel: TeamDetailsDataModel?
    public var onBackClick: (() -> Void)?
    public var moreArray: [PopUpMenuItemModel] = []
    
    init(teamlogic: TeamsLogic?, delegate: TeamsLogicDelegate?, websiteLogic: WebsitesLogic?, teamDetailsModel: TeamDetailsDataModel?) {
        self.teamLogic = teamlogic
        self.delegate = delegate
        self.websiteLogic = websiteLogic
        self.teamDetailsModel = teamDetailsModel
        super.init(frame: .zero)
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
        updateData(teamModel: self.teamDetailsModel)
        setStatusAndMenu(for: "live")
    }
    
    fileprivate func addView() {
        Bundle(for: TeamDetailsView.self).loadNibNamed("TeamDetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func textStyling(){
        titleLabel.font = .styleSelectionBoldText
        informationLabel.font = .systemFont(ofSize: 12, weight: .regular)
        roleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        discriptionDataLabel.font = .systemFont(ofSize: 12, weight: .regular)
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
        let addEditView = AddAndEditTeamView(teamLogic: teamLogic, teamDelegate: self, teamModel: self.teamDetailsModel, websiteLogic: websiteLogic)
        userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    public func setStatusAndMenu(for status: String?) {
        
        let editMenu = PopUpMenuItemModel(strMenuID: "edit", menuName: "Edit" , menuImage: "edits")
        
        let deleteMenu = PopUpMenuItemModel(strMenuID: "delete", menuName: "Delete", menuImage: "delete")
        
        switch status?.lowercased() {
        
        case "active", "live":
            moreArray = [editMenu, deleteMenu]
        default:
            break
        }
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    func updateData(teamModel: TeamDetailsDataModel?) {
        nameLabel.stringValue = teamModel?.name ?? ""
        titleLabel.stringValue = teamModel?.title ?? ""
        roleLabel.stringValue = teamModel?.rolename ?? ""
        discriptionDataLabel.stringValue = teamModel?.description ?? ""
    }
}

extension TeamDetailsView : TeamsLogicDelegate {
    
    func editRoleInQueue(index: Int) { }
    
    func updateEditRole(index: Int, dataStatus: String?) { }
    
    func addNewRoleInQueue() { }
    
    func updateAddRoleSuccess(status: Int?, index: Int?) { }
    
    func getTeamsListFromResponse() { }
    
    func getRolesListFromResponse() { }
    
    func addNewTeamMemberInQueue() { }
    
    func updateAddTeamMemberSuccess(status: Int?, index: Int?) { }
    
    func getTeamDetailsFromResponse() { }
    
    func editTeamMemberInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateData(teamModel: _self.teamLogic?.sortedTeamListArray[index])
            _self.delegate?.editTeamMemberInQueue(index: index)
        }
    }
    
    func updateEditTeamMember(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.setStatusAndMenu(for: dataStatus)
            _self.updateData(teamModel: _self.teamLogic?.sortedTeamListArray[index])
            _self.teamDetailsModel = _self.teamLogic?.sortedTeamListArray[index]
            _self.delegate?.updateEditTeamMember(index: index, dataStatus: dataStatus)
        }
    }
    
    func teamMemberStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.teamMemberStatusChangeForQueue(index: index)
        }
    }
    
    func updateDeleteTeamMemberSuccess(status: Int?, index: Int) {
        delegate?.updateDeleteTeamMemberSuccess(status: status, index: index)
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.onBackClick?()
            _self.removeFromSuperview()
        }
    }
    
    func showPoorInternet() { }
}
