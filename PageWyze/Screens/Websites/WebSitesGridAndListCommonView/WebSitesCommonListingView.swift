//
//  WebSitesCommonListingView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 21/12/22.
//

import Cocoa

class WebSitesCommonListingView: NSView {
    
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var createNewWebsiteButton: NSButton!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var dateView: NSView!
    @IBOutlet weak var typeCustomView: NSView!
    @IBOutlet weak var typeImageView: NSImageView!
    @IBOutlet weak var typeTitleLabel: NSTextField!
    @IBOutlet weak var statusCustomView: NSView!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var statusTitleLabel: NSTextField!
    @IBOutlet weak var gridListSegmentController: NSSegmentedControl!
    @IBOutlet weak var websiteGridListChangeView: NSView!
    @IBOutlet weak var dateViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortByMenuView: NSView!
    @IBOutlet weak var sortByLabel: NSTextField!
    @IBOutlet weak var searchBarOutlet: NSSearchField!
    
    public var websiteViewMode = ViewMode.grid {
        didSet {
            changeViewMode()
        }
    }
    public var gridView: WebSitesGridView?
    public var listView: WebSitesListView?
    public let websiteLogic : WebsitesLogic = WebsitesLogic()
    public var typesPopupArray: [PopUpMenuItemModel] = [PopUpMenuItemModel]()
    public var typeId = "none"
    public var selectedStatusFilter = "live"
    public var searchText = ""
    public var sortId = "name"
    public var selectedFromDate = ""
    public var selectedToDate = ""
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
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
        getTypeListFromAPI()
        getWebsitesListFromAPI()
    }
    
    fileprivate func addView() {
        Bundle(for: WebSitesCommonListingView.self).loadNibNamed("WebSitesCommonListingView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func setupUI() {
        parentCustomView.addShadow(color: .lightGray)
        
        createNewWebsiteButton.setStyle(with: StyleSheet.createButtonColor, tintColor: .white, needCircularBorder: false)
        
        typeCustomView.setBorder(color: .lightGray)
        typeTitleLabel.font = .styleSelectionForSubtitle
        
        statusCustomView.setBorder(color: .lightGray)
        statusTitleLabel.font = .styleSelectionForSubtitle
        
        sortByMenuView.setBorder(color: .lightGray)
        dateView.setBorder(color: .lightGray)
        
        setGestureToViews()
    }
    
    @IBAction func createNewWebsiteButtonTapped(_ sender: NSButton) {
        let addEditView = AddAndEditWebsiteView(websiteLogic: websiteLogic, websiteModel: nil, websiteDelegate: self)
        userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    @IBAction func listSearchBarTapped(_ sender: NSSearchField) {
        self.searchText = sender.stringValue
        self.getWebsitesListFromAPI()
    }
    
    @IBAction func websiteGridListSegmentContollerTapped(_ sender: NSSegmentedControl) {
        websiteViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
    
    public func setGestureToViews() {
        typeCustomView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(typeViewTapped)))
        
        statusCustomView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(statusViewTapped)))
        
        dateView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(dateViewTapped)))
        
        sortByMenuView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(sortByViewTapped)))
    }
    
    @objc func typeViewTapped() {
        showPopUpForButtonViews(toLabel: typeTitleLabel, showList: typesPopupArray)
    }
    
    @objc func statusViewTapped() {
        showPopUpForButtonViews(toLabel: statusTitleLabel, showList: statusArray)
    }
    
    @objc func dateViewTapped() {
        showPopupForDate()
    }
    
    @objc func sortByViewTapped() {
        showPopUpForButtonViews(toLabel: sortByLabel, showList: sortArray)
    }
    
    public func changeViewMode() {
        
        websiteGridListChangeView.subviews.removeAll()
        
        switch websiteViewMode {
        
        case .grid:
            if gridView == nil {
                gridView = WebSitesGridView(websiteLogic: websiteLogic)
            }
            gridView?.reloadData()
            gridView?.onItemClick = { [weak self] index in
                guard let _self = self else { return }
                _self.openTabBarView(model: _self.websiteLogic.sortedWebsiteList[index])
            }
            addViewThroughConstraints(for: gridView ?? NSView(), in: websiteGridListChangeView)
            
        case .list:
            if listView == nil {
                listView = WebSitesListView(websiteLogic: websiteLogic)
            }
            listView?.reloadData()
            listView?.onItemClick = { [weak self] index in
                guard let _self = self else { return }
                _self.openTabBarView(model: _self.websiteLogic.sortedWebsiteList[index])
            }
            addViewThroughConstraints(for: listView ?? NSView(), in: websiteGridListChangeView)
        default :
            break
        }
    }
    
    public func openTabBarView(model: WebsiteDetailsDataModel?) {
        websiteLogic.websiteDetailsModel = model
        let tabBarView = WebsiteTabsCommonView(websiteLogic: websiteLogic, websiteDelegate: self)
        self.userIntractionHandlerView.isUserInteractionEnabled = false
        tabBarView.onBackToList = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: tabBarView, in: self)
    }
    
    public func showPopUpForButtonViews(toLabel label: NSTextField , showList itemList: [PopUpMenuItemModel]) {
        
        let menu = PopUpMenuViewController(menuItems: itemList)
        var tableSize = CGSize()
        
        switch label {
        case typeTitleLabel:
            tableSize = CGSize(width: 80, height: 55)
        case statusTitleLabel:
            tableSize = CGSize(width: 105, height: 130)
        case sortByLabel:
            tableSize = CGSize(width: 80, height: 125)
        default:
            break
        }
        
        menu.applyConstraintForCompleteMenu(tableSize: tableSize)
        
        menu.onSelectedItemModel = {  [weak self] selectedItem in
            guard let _self = self else { return }
            
            switch label {
            
            case _self.typeTitleLabel:
                let name = selectedItem.strID == "none" ? "" : selectedItem.itemName
                label.stringValue = name ?? ""
                _self.typeId = selectedItem.strID ?? "none"
                
            case _self.statusTitleLabel:
                label.stringValue = selectedItem.itemName ?? ""
                _self.statusImageView.image = NSImage(named: selectedItem.itemImage ?? "")
                _self.selectedStatusFilter = selectedItem.itemName ?? "live"
                
            case _self.sortByLabel:
                label.stringValue = selectedItem.itemName ?? ""
                _self.sortId = selectedItem.itemName?.lowercased() ?? ""
                
            default:
                break
            }
            
            _self.getWebsitesListFromAPI()
        }
        
        self.window?.contentViewController?.present(menu, asPopoverRelativeTo: .zero, of: label, preferredEdge: .maxY, behavior: .transient)
    }
    
    public func showPopupForDate() {
        let fromToDatePicker = FromToDatePickerController()
        //MARK: Set title to Picker. Show Default values if no date selected otherwise show selected dates in User Format for date by converting it
        setTitleToDatePickerPopup(fromToDatePicker)
        //MARK: Get Selected Date from Popup
        fromToDatePicker.selectedDate = { [weak self] fromDate, toDate in
            //MARK: Dates coming in dd-MMM-yy format
            guard let _self = self else { return }
            let showFromDateToUser = fromDate?.getFormattedStringFromDate(format: "dd-MMM-yy")
            let showToDateToUser = toDate?.getFormattedStringFromDate(format: "dd-MMM-yy")
            DispatchQueue.main.async {
                if fromDate == nil && toDate == nil {
                    //MARK: No Dates will be showed to User
                    _self.dateLabel.stringValue = "Date"
                } else if fromDate == nil {
                    //MARK: Only toDate will be showed to User
                    _self.dateLabel.stringValue = "To - \(showToDateToUser ?? "")"
                } else if toDate == nil {
                    //MARK: Only fromDate will be showed to User
                    _self.dateLabel.stringValue = "Start Date - \(showToDateToUser ?? "")"
                } else {
                    //MARK: All Dates will be showed to User
                    _self.dateLabel.stringValue = "\(showFromDateToUser ?? "") / \(showToDateToUser ?? "")"
                    _self.dateViewWidthConstraint.constant = 200
                }
            }
            
            //MARK: Selected Dates to send to API
            _self.selectedFromDate = fromDate?.getFormattedStringFromDate(format: "yyyy-MM-dd") ?? ""
            _self.selectedToDate = toDate?.getFormattedStringFromDate(format: "yyyy-MM-dd") ?? ""
            _self.getWebsitesListFromAPI()
        }
        self.window?.contentViewController?.present(fromToDatePicker, asPopoverRelativeTo: .init(x: 0, y: 0, width: 150, height: 150), of: dateLabel, preferredEdge: .maxY, behavior: .transient)
    }
    
    public func setTitleToDatePickerPopup(_ controller: FromToDatePickerController) {
        //MARK: Get selected Dates In String from Applied Filter
        let getSelectedFromDateString = selectedFromDate.fetchDateFromString(format: "yyyy-MM-dd").getFormattedStringFromDate(format: "dd-MMM-yy")
        //MARK: Fetch Selected To-date and convert them into dd-MMM-yy format to show to User
        let getSelectedToDateString = selectedToDate.fetchDateFromString(format: "yyyy-MM-dd").getFormattedStringFromDate(format: "dd-MMM-yy")
        //MARK: Dates are converted into dd-MMM-yy format to show to user as selected dates were in yyyy-MM-dd format
        
        if selectedFromDate.isEmpty && selectedToDate.isEmpty {
            //MARK: No Dates will be showed to User
            controller.setTitleToDates(fromDate: "From", toDate: "To")
        } else if selectedFromDate.isEmpty {
            //MARK: Only toDate will be showed to User
            controller.toDate = getSelectedToDateString
        } else if selectedToDate.isEmpty {
            //MARK: Only fromDate will be showed to User
            controller.fromDate = getSelectedFromDateString
        } else {
            //MARK: All Dates will be showed to User
            controller.setTitleToDates(fromDate: getSelectedFromDateString , toDate: getSelectedToDateString)
        }
    }
    
    public func getTypeListFromAPI() {
        userIntractionHandlerView.isUserInteractionEnabled = false
        websiteLogic.delegate = self
        websiteLogic.getTypesList()
    }
    
    public func getWebsitesListFromAPI() {
        userIntractionHandlerView.isUserInteractionEnabled = false
        websiteLogic.delegate = self
        websiteLogic.getWebsitesList(typeId: typeId, status: selectedStatusFilter, text: searchText, fromDate: selectedFromDate, toDate: selectedToDate, sortId: sortId)
    }
}

extension WebSitesCommonListingView : WebsitesLogicDelegate {
    
    func getWebsitesListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            _self.websiteViewMode = _self.gridListSegmentController.selectedSegment == 0 ? .grid : .list
        }
    }
    
    func getTypesListFromResponse() {
        typesPopupArray.removeAll()
        self.userIntractionHandlerView.isUserInteractionEnabled = true
        for type in websiteLogic.typesListArray {
            let obj = type
            let key = obj.key
            let name = obj.name
            typesPopupArray.append(PopUpMenuItemModel(strMenuID: key, menuName: name, menuImage: ""))
        }
    }
    
    func getLanguagesListFromResponse() { }
    
    func getCategoriesListFromResponse() { }
    
    func getVerifyDomainResponse(status: Int?) { }
    
    func addNewWebsiteInQueue() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.addWebsite()
            _self.listView?.addWebsite()
        }
    }
    
    func updateAddWebsiteSuccess(ststus: Int, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedWebsite(index: index)
            _self.listView?.reloadSelectedWebsite(index: index)
        }
    }
    
    func getWebsiteDetailsFromResponse(detailsModel: WebsiteDetailsDataModel?, pagesList: [PageDataModel]?) { }
    
    func getGeneratedFileResponse(status: Int?) { }
    
    func getStatisticListResponse(statisticsDataModel: [StatisticsDataModel]) { }
    
    func updateEditPageDataSuccess(datastatus: String) { }
    
    func editWebsiteInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = false
            _self.gridView?.reloadSelectedWebsite(index: index)
            _self.listView?.reloadSelectedWebsite(index: index)
        }
    }
    
    func updateEditWebsiteSuccess(index: Int, copyRight: String, dataStatus: String) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if _self.selectedStatusFilter == dataStatus || _self.selectedStatusFilter == "live" {
                _self.gridView?.reloadSelectedWebsite(index: index)
                _self.listView?.reloadSelectedWebsite(index: index)
            }else{
                _self.gridView?.removeSelectedWebsite(index: index)
                _self.listView?.removeSelectedWebsite(index: index)
            }
        }
    }
    
    func getFilesListFromResponse() { }
    
    func getGroupsListFromResponse() { }
    
    func updateWebsiteStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            if dataStatus == "complete"{
                _self.gridView?.reloadData()
                _self.listView?.reloadData()
            } else {
                _self.gridView?.reloadSelectedWebsite(index: index)
                _self.listView?.reloadSelectedWebsite(index: index)
            }
        }
    }
    
    func websiteStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedWebsite(index: index)
            _self.listView?.reloadSelectedWebsite(index: index)
        }
    }
    
    func updateDeleteWebsiteSuccess(status: Int, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if status == 1 {
                _self.gridView?.removeSelectedWebsite(index: index)
                _self.listView?.removeSelectedWebsite(index: index)
            } else {
                _self.gridView?.reloadSelectedWebsite(index: index)
                _self.listView?.reloadSelectedWebsite(index: index)
            }
        }
    }
    
    func showPoorInternet() { }
}
