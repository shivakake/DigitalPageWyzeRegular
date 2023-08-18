//
//  KeywordsGridAndListCommonView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 03/01/23.
//

import Cocoa

class KeywordsGridAndListCommonView: NSView {
    
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var addKeyworkButton: NSButton!
    @IBOutlet weak var typeView: NSView!
    @IBOutlet weak var typeTitleLabel: NSTextField!
    @IBOutlet weak var statusView: NSView!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var statusTitleLabel: NSTextField!
    @IBOutlet weak var searchBarField: NSSearchField!
    @IBOutlet weak var sortByTitleLabel: NSTextField!
    @IBOutlet weak var sortByView: NSView!
    @IBOutlet weak var sortByLabel: NSTextField!
    @IBOutlet weak var gridListSegmentController: NSSegmentedControl!
    @IBOutlet weak var keyworkGridListChangeView: NSView!
    @IBOutlet weak var searchBarOutlet: NSSearchField!
    
    public var keywordViewMode = ViewMode.grid {
        didSet {
            changeViewMode()
        }
    }
    public var gridView: KeywordGridView?
    public var listView: KeywordListView?
    public var keywordLogic: KeywordLogic = KeywordLogic()
    public var websiteLogic: WebsitesLogic?
    public var typeArray: [PopUpMenuItemModel] = [PopUpMenuItemModel(strMenuID: "page", menuName: "Page", menuImage: "page"),PopUpMenuItemModel(strMenuID: "home", menuName: "Home", menuImage: "home")]
    public var onHideDetailsTab: ((Bool) -> Void)?
    public var typeId = "none"
    public var selectedStatusFilter = "live"
    public var searchText = ""
    public var sortId = "name"
    
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
        Bundle(for: KeywordsGridAndListCommonView.self).loadNibNamed("KeywordsGridAndListCommonView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    fileprivate func setupUI() {
        stylingUI()
        setGestureToViews()
        getKeywordListFromAPI(typeID: typeId, filterStatus: selectedStatusFilter, searchText: searchText, sortID: sortId)
    }
    
    fileprivate func stylingUI() {
        
        parentCustomView.wantsLayer = true
        parentCustomView.addShadow(color: .lightGray)
        
        typeView.setBorder(color: .lightGray)
        typeView.layer?.backgroundColor = .white
        typeTitleLabel.font = .styleSelectionForSubtitle
        
        statusView.setBorder(color: .lightGray)
        statusView.layer?.backgroundColor = .white
        statusTitleLabel.font = .styleSelectionForSubtitle
        
        sortByView.setBorder(color: .lightGray)
        sortByView.layer?.backgroundColor = .white
        sortByTitleLabel.font = .styleSelectionForSubtitle
        
        addKeyworkButton.setStyle(with: StyleSheet.createButtonColor, tintColor: .white, needCircularBorder: false)
    }
    
    public func getKeywordListFromAPI(typeID: String, filterStatus: String, searchText: String, sortID: String) {
        userIntractionHandlerView.isUserInteractionEnabled = false
        keywordLogic.delegate = self
        keywordLogic.getKeywordsList(websiteId: self.websiteLogic?.websiteDetailsModel?.id, pageId: "none", searchText: searchText, status: filterStatus, sortId: sortID)
    }
    
    fileprivate func setGestureToViews() {
        typeView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(typeViewTapped)))
        statusView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(statusViewTapped)))
        sortByView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(sortByViewTapped)))
    }
    
    @objc func typeViewTapped() {
        showPopUpForButtonViews(toLabel: typeTitleLabel, showList: typeArray)
    }
    
    @objc func statusViewTapped() {
        showPopUpForButtonViews(toLabel: statusTitleLabel, showList: statusArray)
    }
    
    @objc func sortByViewTapped() {
        showPopUpForButtonViews(toLabel: sortByLabel, showList: keywordSortArray)
    }
    
    public func firstIndexofSegment() {
        gridListSegmentController.selectedSegment = 0
        keywordViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
    
    public func changeViewMode() {
        keyworkGridListChangeView.subviews.removeAll()
        
        switch keywordViewMode {
        case .grid:
            if gridView == nil {
                gridView = KeywordGridView(keywordLogic: keywordLogic)
            }
            gridView?.reloadData()
            gridView?.onGridItemSelection = {[weak self] index in
                guard let _self = self else { return }
                _self.openKeywordDetailsView(model: _self.keywordLogic.sortedKeywordListArray[index])
            }
            addViewThroughConstraints(for: gridView ?? NSView(), in: keyworkGridListChangeView)
        case .list:
            if listView == nil {
                listView = KeywordListView(keywordLogic: keywordLogic)
            }
            listView?.reloadData()
            listView?.onListItemSelection = { [weak self] index in
                guard let _self = self else { return }
                _self.openKeywordDetailsView(model: _self.keywordLogic.sortedKeywordListArray[index])
            }
            addViewThroughConstraints(for: listView ?? NSView(), in: keyworkGridListChangeView)
        default:
            break
        }
    }
    
    public func openKeywordDetailsView(model: KeywordDetailsDataModel?) {
        keywordLogic.keywordDetailsData = model
        let keywordDetailsView = KeywordDetailsView(keywordLogic: keywordLogic, delegate: self, websiteLogic: self.websiteLogic)
        self.userIntractionHandlerView.isUserInteractionEnabled = false
        keywordDetailsView.onBackClick = {
            self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: keywordDetailsView, in: self)
    }
    
    public func showPopUpForButtonViews(toLabel label: NSTextField , showList itemList: [PopUpMenuItemModel]) {
        let menu = PopUpMenuViewController(menuItems: itemList)
        
        if label == typeTitleLabel {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 100, height: 50))
            menu.onSelectedItemModel = { [weak self] selectedTypeItem in
                guard let _self = self else { return }
                label.stringValue = selectedTypeItem.itemName ?? ""
                //                                _self.typeId = selectedTypeItem.strID ?? "none"
                //MARK:- present we pass type none for now. when we get option to get data with type then we pass typeid
                _self.getKeywordListFromAPI(typeID: _self.typeId, filterStatus: _self.selectedStatusFilter, searchText: _self.searchText, sortID: _self.sortId)
            }
        } else if label == statusTitleLabel {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 100, height: 130))
            menu.onSelectedItemModel = {  [weak self]  selectedStatusItem in
                guard let _self = self else { return }
                
                label.stringValue = selectedStatusItem.itemName ?? ""
                _self.statusImageView.image = NSImage(named: selectedStatusItem.itemImage ?? "")
                _self.selectedStatusFilter = selectedStatusItem.itemName ?? "live"
                _self.getKeywordListFromAPI(typeID: _self.typeId, filterStatus: _self.selectedStatusFilter, searchText: _self.searchText, sortID: _self.sortId)
            }
        } else {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 80, height: 80))
            menu.onSelectedItemModel = { [weak self]  selectedSortItem in
                guard let _self = self else { return }
                label.stringValue = selectedSortItem.itemName ?? ""
                _self.sortId = selectedSortItem.itemName?.lowercased() ?? ""
                _self.getKeywordListFromAPI(typeID: _self.typeId, filterStatus: _self.selectedStatusFilter, searchText: _self.searchText, sortID: _self.sortId)
            }
        }
        self.window?.contentViewController?.present(menu, asPopoverRelativeTo: .zero, of: label, preferredEdge: .maxY, behavior: .transient)
    }
    
    
    @IBAction func addKeywordButtonTapped(_ sender: NSButton) {
        let addEditView = AddAndEditKeywordView(keywordLogic: keywordLogic, keywordDelegate: self, keywordModel: nil, websiteLogic: websiteLogic)
        userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    @IBAction func listSearchBarTapped(_ sender: NSSearchField) {
        self.searchText = sender.stringValue
        keywordLogic.delegate = self
        keywordLogic.getKeywordsList(websiteId: self.websiteLogic?.websiteDetailsModel?.id, pageId: "none", searchText: self.searchText, status: selectedStatusFilter, sortId: sortId)
    }
    
    @IBAction func keywordGridListSegmentContollerTapped(_ sender: NSSegmentedControl) {
        keywordViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
}

extension KeywordsGridAndListCommonView : KeywordLogicDelegate {
    
    func getKeywordsListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            _self.keywordViewMode = _self.gridListSegmentController.selectedSegment == 0 ? .grid : .list
        }
    }
    
    func updateKeywordStatusChange(dataStatus: String?, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            if dataStatus == "complete"{
                _self.gridView?.reloadData()
                _self.listView?.reloadData()
            } else {
                _self.gridView?.reloadSelectedKeyword(index: index)
                _self.listView?.reloadSelectedKeyword(index: index)
            }
        }
    }
    
    func addNewKeywordInQueue() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.addKeyword()
            _self.listView?.addKeyword()
        }
    }
    
    func updateAddKeywordSuccess(status: Int?, index: Int?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedKeyword(index: index ?? 0)
            _self.listView?.reloadSelectedKeyword(index: index ?? 0)
        }
    }
    
    func getKeywordDetailsFromResponse() { }
    
    func editKeywordInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = false
            _self.gridView?.reloadSelectedKeyword(index: index)
            _self.listView?.reloadSelectedKeyword(index: index)
        }
    }
    
    func updateEditKeyword(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if _self.selectedStatusFilter == dataStatus || _self.selectedStatusFilter == "live" {
                _self.gridView?.reloadSelectedKeyword(index: index)
                _self.listView?.reloadSelectedKeyword(index: index)
            }else{
                _self.gridView?.removeSelectedKeyword(index: index)
                _self.listView?.removeSelectedKeyword(index: index)
            }
        }
    }
    
    func keywordStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedKeyword(index: index)
            _self.listView?.reloadSelectedKeyword(index: index)
        }
    }
    
    func updateDeleteKeywordSuccess(status: Int?, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if status == 1 {
                _self.gridView?.removeSelectedKeyword(index: index)
                _self.listView?.removeSelectedKeyword(index: index)
            } else {
                _self.gridView?.reloadSelectedKeyword(index: index)
                _self.listView?.reloadSelectedKeyword(index: index)
            }
        }
    }
    
    func showPoorInternet() { }
}
