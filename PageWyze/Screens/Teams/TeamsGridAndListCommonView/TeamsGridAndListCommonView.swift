//
//  TeamsGridAndListCommonView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class TeamsGridAndListCommonView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var addNewMemberButton: NSButton!
    @IBOutlet weak var rolesButton: NSButton!
    @IBOutlet weak var gridListSegmentController: NSSegmentedControl!
    @IBOutlet weak var teamGridListChangeView: NSView!
    @IBOutlet weak var sortByMenuView: NSView!
    @IBOutlet weak var sortByMenuLabel: NSTextField!
    
    public var teamViewMode = ViewMode.grid {
        didSet {
            changeViewMode()
        }
    }
    public var gridView: TeamsGridView?
    public var listView: TeamsListView?
    public var teamLogic: TeamsLogic = TeamsLogic()
    public var websiteLogic: WebsitesLogic?
    public var typesPopupArray: [PopUpMenuItemModel] = [PopUpMenuItemModel]()
    public var onHideDetailsTab: ((Bool) -> Void)?
    public var roleView: RolesGridAndListCommonView?
    public var sortId = "name"
    public var selectedStatusFilter = "live"
    
    init(websiteLogic: WebsitesLogic?) {
        self.websiteLogic = websiteLogic
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
        Bundle(for: TeamsGridAndListCommonView.self).loadNibNamed("TeamsGridAndListCommonView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func setupUI() {
        parentCustomView.wantsLayer = true
        parentCustomView.addShadow(color: .lightGray)
        
        addNewMemberButton.setStyle(with: StyleSheet.createButtonColor, tintColor: .white, needCircularBorder: false)
        
        rolesButton.setStyle(with: StyleSheet.createButtonColor, tintColor: .white, needCircularBorder: false)
        
        sortByMenuView.setBorder(color: .lightGray)
        sortByMenuView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(sortByViewTapped)))
        
        getTeamsListFromAPI(sortID: self.sortId)
    }
    
    @objc func sortByViewTapped() {
        showPopUpForButtonViews(toLabel: sortByMenuLabel, showList: teamSortArray)
    }
    
    public func firstIndexofSegment() {
        gridListSegmentController.selectedSegment = 0
        teamViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
    
    public func changeViewMode() {
        teamGridListChangeView.subviews.removeAll()
        
        switch teamViewMode {
        case .grid:
            if gridView == nil {
                gridView = TeamsGridView(teamLogic: teamLogic)
            }
            
            gridView?.reloadData()
            gridView?.onGridItemSelection = {[weak self] index in
                guard let _self = self else { return }
                _self.openTeamMemberDetailsView(model: _self.teamLogic.sortedTeamListArray[index])
            }
            addViewThroughConstraints(for: gridView ?? NSView(), in: teamGridListChangeView)
            
        case .list:
            if listView == nil {
                listView = TeamsListView(teamLogic: self.teamLogic)
            }
            listView?.reloadData()
            listView?.onListItemSelection = { [weak self] index in
                guard let _self = self else { return }
                _self.openTeamMemberDetailsView(model: _self.teamLogic.sortedTeamListArray[index])
            }
            addViewThroughConstraints(for: listView ?? NSView(), in: teamGridListChangeView)
            
        default:
            break
        }
    }
    
    public func openTeamMemberDetailsView(model: TeamDetailsDataModel?) {
        teamLogic.teamMemberDetailsData = model
        let teamDetailsView = TeamDetailsView(teamlogic: teamLogic, delegate: self, websiteLogic: websiteLogic, teamDetailsModel: model)
        self.userIntractionHandlerView.isUserInteractionEnabled = false
        teamDetailsView.onBackClick = {
            self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: teamDetailsView, in: self)
    }
    
    public func showPopUpForButtonViews(toLabel label: NSTextField , showList itemList: [PopUpMenuItemModel]) {
        let menu = PopUpMenuViewController(menuItems: itemList)
        menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 80, height: 105))
        menu.onSelectedItemModel = { [weak self]  selectedSortItem in
            guard let _self = self else { return }
            label.stringValue = selectedSortItem.itemName ?? ""
            _self.sortId = selectedSortItem.itemName?.lowercased() ?? ""
            _self.getTeamsListFromAPI(sortID: _self.sortId)
        }
        self.window?.contentViewController?.present(menu, asPopoverRelativeTo: .zero, of: label, preferredEdge: .maxY, behavior: .transient)
    }
    
    @IBAction func addNewMemberButtonTapped(_ sender: NSButton) {
        let addEditView = AddAndEditTeamView(teamLogic: teamLogic, teamDelegate: self, teamModel: nil, websiteLogic: websiteLogic)
        userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    @IBAction func roleButtonTapped(_ sender: NSButton) {
        let roleView = RolesGridAndListCommonView(websiteLogic: self.websiteLogic, teamLogic: self.teamLogic)
        userIntractionHandlerView.isUserInteractionEnabled = false
        roleView.onBackClick = {[weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: roleView, in: parentCustomView)
    }
    
    @IBAction func teamGridListSegmentContollerTapped(_ sender: NSSegmentedControl) {
        teamViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
    
    public func getTeamsListFromAPI(sortID: String) {
        userIntractionHandlerView.isUserInteractionEnabled = false
        teamLogic.delegate = self
        teamLogic.getTeamsList(websiteId: self.websiteLogic?.websiteDetailsModel?.id, sortId: sortID)
    }
}

extension TeamsGridAndListCommonView : TeamsLogicDelegate {
    
    func editRoleInQueue(index: Int) { }
    
    func updateEditRole(index: Int, dataStatus: String?) { }
    
    func addNewRoleInQueue() { }
    
    func updateAddRoleSuccess(status: Int?, index: Int?) { }
    
    func getTeamsListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            _self.teamViewMode = _self.gridListSegmentController.selectedSegment == 0 ? .grid : .list
        }
    }
    
    func getRolesListFromResponse() { }
    
    func getTypesListFromResponse() { }
    
    func addNewTeamMemberInQueue() { }
    
    func updateAddTeamMemberSuccess(status: Int?, index: Int?) { }
    
    func getTeamDetailsFromResponse() { }
    
    func editTeamMemberInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = false
            _self.gridView?.reloadSelectedTeamMember(index: index)
            _self.listView?.reloadSelectedTeamMember(index: index)
        }
    }
    
    func updateEditTeamMember(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if _self.selectedStatusFilter == dataStatus || _self.selectedStatusFilter == "live" {
                _self.gridView?.reloadSelectedTeamMember(index: index)
                _self.listView?.reloadSelectedTeamMember(index: index)
            }else{
                _self.gridView?.removeSelectedTeamMember(index: index)
                _self.listView?.removeSelectedTeamMember(index: index)
            }
        }
    }
    
    func teamMemberStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedTeamMember(index: index)
            _self.listView?.reloadSelectedTeamMember(index: index)
        }
    }
    
    func updateDeleteTeamMemberSuccess(status: Int?, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if status == 1 {
                _self.gridView?.removeSelectedTeamMember(index: index)
                _self.listView?.removeSelectedTeamMember(index: index)
            } else {
                _self.gridView?.reloadSelectedTeamMember(index: index)
                _self.listView?.reloadSelectedTeamMember(index: index)
            }
        }
    }
    
    func showPoorInternet() { }
}
