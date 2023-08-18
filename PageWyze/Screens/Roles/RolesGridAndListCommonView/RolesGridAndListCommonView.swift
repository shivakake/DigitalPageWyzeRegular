//
//  RolesGridAndListCommonView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 31/12/22.
//

import Cocoa

class RolesGridAndListCommonView: NSView {
    
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var addNewRoleButton: NSButton!
    @IBOutlet weak var gridListSegmentController: NSSegmentedControl!
    @IBOutlet weak var rolesGridListChangeView: NSView!
    
    public var roleViewMode = ViewMode.grid {
        didSet {
            changeViewMode()
        }
    }
    public var gridView: RolesGridView?
    public var listView: RolesListView?
    public var websiteLogic: WebsitesLogic?
    public var teamLogic: TeamsLogic?
    public var onBackClick: (() -> Void)?
    public var roleList: [WenoiVisualPanelModel] = [WenoiVisualPanelModel]()
    public var userSelectedRoleId: String?
    public var selectedStatusFilter = "live"
    
    init(websiteLogic: WebsitesLogic?, teamLogic: TeamsLogic?) {
        self.websiteLogic = websiteLogic
        self.teamLogic = teamLogic
        super.init(frame: .zero)
        commonMethodes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethodes()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public func commonMethodes() {
        addView()
        setupUI()
        firstIndexofSegment()
    }
    
    fileprivate func addView() {
        Bundle(for: RolesGridAndListCommonView.self).loadNibNamed("RolesGridAndListCommonView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func setupUI() {
        getRoleListFromAPI()
        addNewRoleButton.setStyle(with: StyleSheet.createButtonColor, tintColor: .white, needCircularBorder: false)
        self.parentCustomView.wantsLayer = true
        parentCustomView.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    public func firstIndexofSegment() {
        gridListSegmentController.selectedSegment = 0
        roleViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
    
    public func getRoleListFromAPI() {
        userIntractionHandlerView.isUserInteractionEnabled = false
        teamLogic?.delegate = self
        teamLogic?.getTeamsRolesList(websiteId: websiteLogic?.websiteDetailsModel?.id)
    }
    
    public func changeViewMode() {
        rolesGridListChangeView.subviews.removeAll()
        
        switch roleViewMode {
        case .grid:
            if gridView == nil {
                gridView = RolesGridView(teamLogic: self.teamLogic)
            }
            gridView?.reloadData()
            gridView?.onGridItemSelection = {  [weak self] index in
                guard let _self = self else { return }
                _self.openRoleDetailsView(model: _self.teamLogic?.rolesListArray[index])
            }
            addViewThroughConstraints(for: gridView ?? NSView(), in: rolesGridListChangeView)
        case .list:
            if listView == nil {
                listView = RolesListView(teamLogic: self.teamLogic)
            }
            listView?.reloadData()
            listView?.onListItemSelection = {  [weak self] index in
                guard let _self = self else { return }
                _self.openRoleDetailsView(model: _self.teamLogic?.rolesListArray[index])
            }
            addViewThroughConstraints(for: listView ?? NSView(), in: rolesGridListChangeView)
        default:
            break
        }
    }
    
   fileprivate func openRoleDetailsView(model: RoleDataModel?) {
        let roleDetails = RolesDetailsView(teamlogic: self.teamLogic, delegate: self, websiteLogic: self.websiteLogic, roleDetails: model)
        self.userIntractionHandlerView.isUserInteractionEnabled = false
        roleDetails.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        self.addViewThroughConstraints(for: roleDetails, in: self.parentCustomView)
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    @IBAction func addNewRoleButtonTapped(_ sender: NSButton) {
        let addEditView = AddAndEditRoleView(teamLogic: self.teamLogic, teamDelegate: self, roleModel: nil, websiteLogic: websiteLogic)
        userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    @IBAction func rolesGridListSegmentContollerTapped(_ sender: NSSegmentedControl) {
        roleViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
}

extension RolesGridAndListCommonView : TeamsLogicDelegate {
    
    func editRoleInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = false
            _self.gridView?.reloadSelectedRole(index: index)
            _self.listView?.reloadSelectedRole(index: index)
        }
    }
    
    func updateEditRole(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if _self.selectedStatusFilter == dataStatus || _self.selectedStatusFilter == "live" {
                _self.gridView?.reloadSelectedRole(index: index)
                _self.listView?.reloadSelectedRole(index: index)
            }else{
                _self.gridView?.removeSelectedRole(index: index)
                _self.listView?.removeSelectedRole(index: index)
            }
        }
    }
    
    func addNewRoleInQueue() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.addRole()
            _self.listView?.addRole()
        }
    }
    
    func updateAddRoleSuccess(status: Int?, index: Int?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedRole(index: index ?? 0)
            _self.listView?.reloadSelectedRole(index: index ?? 0)
        }
    }
    
    func getTeamsListFromResponse() { }
    
    func getRolesListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            _self.roleViewMode = _self.gridListSegmentController.selectedSegment == 0 ? .grid : .list
        }
    }
    
    func addNewTeamMemberInQueue() { }
    
    func updateAddTeamMemberSuccess(status: Int?, index: Int?) { }
    
    func getTeamDetailsFromResponse() { }
    
    func editTeamMemberInQueue(index: Int) { }
    
    func updateEditTeamMember(index: Int, dataStatus: String?) { }
    
    func teamMemberStatusChangeForQueue(index: Int) { }
    
    func updateDeleteTeamMemberSuccess(status: Int?, index: Int) { }
    
    func showPoorInternet() { }
}
