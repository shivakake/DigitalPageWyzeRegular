//
//  ComponentGridAndListCommonView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Cocoa

class ComponentGridAndListCommonView: NSView {
    
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var createNewComponentButton: NSButton!
    @IBOutlet weak var typeCustomView: NSView!
    @IBOutlet weak var typeImageView: NSImageView!
    @IBOutlet weak var typeTitleLabel: NSTextField!
    @IBOutlet weak var statusCustomView: NSView!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var statusTitleLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var dateView: NSView!
    @IBOutlet weak var dateViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var gridListSegmentController: NSSegmentedControl!
    @IBOutlet weak var componentGridListChangeView: NSView!
    @IBOutlet weak var sortByMenuView: NSView!
    @IBOutlet weak var sortByMenuLabel: NSTextField!
    
    public var componentViewMode = ViewMode.grid {
        didSet {
            changeViewMode()
        }
    }
    public var gridView: ComponentGridView?
    public var listView: ComponentListView?
    public var componentLogic: ComponentsLogic = ComponentsLogic()
    public var websiteLogic: WebsitesLogic?
    public var typesPopupArray: [PopUpMenuItemModel] = [PopUpMenuItemModel]()
    public var onHideDetailsTab: ((Bool) -> Void)?
    public var typeId = "none"
    public var selectedStatusFilter = "live"
    public var searchText = ""
    public var sortId = "name"
    public var selectedFromDate = ""
    public var selectedToDate = ""
    
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
        Bundle(for: ComponentGridAndListCommonView.self).loadNibNamed("ComponentGridAndListCommonView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func setupUI() {
        parentCustomView.wantsLayer = true
        parentCustomView.addShadow(color: .lightGray)
        
        createNewComponentButton.setStyle(with: StyleSheet.createButtonColor, tintColor: .white, needCircularBorder: false)
        
        typeCustomView.setBorder(color: .lightGray)
        typeCustomView.layer?.backgroundColor = .white
        typeTitleLabel.font = .styleSelectionForSubtitle
        
        statusCustomView.setBorder(color: .lightGray)
        statusCustomView.layer?.backgroundColor = .white
        statusTitleLabel.font = .styleSelectionForSubtitle
        
        sortByMenuView.setBorder(color: .lightGray)
        dateView.setBorder(color: .lightGray)
        setGestureToViews()
        
        getTypeListFromAPI()
        getComponentsListFromAPI(typeID: typeId, filterStatus: selectedStatusFilter, searchText: searchText, fromDate: selectedFromDate, toDate: selectedToDate, sortID: sortId)
    }
    
    public func getTypeListFromAPI() {
        userIntractionHandlerView.isUserInteractionEnabled = false
        componentLogic.delegate = self
        componentLogic.getComponentsTypesList()
    }
    
    public func getComponentsListFromAPI(typeID: String, filterStatus: String, searchText: String, fromDate: String, toDate: String, sortID: String) {
        userIntractionHandlerView.isUserInteractionEnabled = false
        componentLogic.delegate = self
        componentLogic.getComponentsList(websiteId: self.websiteLogic?.websiteDetailsModel?.id, typeId: typeID, status: filterStatus, searchText: searchText, fromDate: fromDate, toDate: toDate, sortId: sortID)
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
        showPopUpForButtonViews(toLabel: sortByMenuLabel, showList: componentSortArray)
    }
    
    public func firstIndexofSegment() {
        gridListSegmentController.selectedSegment = 0
        componentViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
    
    public func changeViewMode() {
        componentGridListChangeView.subviews.removeAll()
        
        switch componentViewMode {
        case .grid:
            if gridView == nil {
                gridView = ComponentGridView(componentLogic: componentLogic)
            }
            gridView?.reloadData()
            gridView?.onGridItemSelection = {[weak self] index in
                guard let _self = self else { return }
                _self.openComponentDetailsView(model: _self.componentLogic.sortedComponentListArray[index])
            }
            addViewThroughConstraints(for: gridView ?? NSView(), in: componentGridListChangeView)
        case .list:
            if listView == nil {
                listView = ComponentListView(componentLogic: componentLogic)
            }
            listView?.reloadData()
            listView?.onListItemSelection = { [weak self] index in
                guard let _self = self else { return }
                _self.openComponentDetailsView(model: _self.componentLogic.sortedComponentListArray[index])
            }
            addViewThroughConstraints(for: listView ?? NSView(), in: componentGridListChangeView)
            
        default:
            break
        }
    }
    
    public func openComponentDetailsView(model: ComponentDetailsDataModel?) {
        componentLogic.componentDetailsData = model
        let componentDetailsView = ComponentDetailsView(componentlogic: componentLogic, delegate: self, websiteLogic: websiteLogic)
        self.userIntractionHandlerView.isUserInteractionEnabled = false
        componentDetailsView.onBackClick = {
            self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: componentDetailsView, in: self)
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
                    let date = FunctionsExtension.sharedInstance.getCurrentDate()
                    _self.dateLabel.stringValue = date
                    _self.selectedFromDate = ""
                    _self.selectedToDate = ""
                } else if fromDate == nil {
                    //MARK: Only toDate will be showed to User
                    _self.dateLabel.stringValue = "To - \(showToDateToUser ?? "")"
                    _self.selectedFromDate = ""
                    _self.selectedToDate = FunctionsExtension.sharedInstance.dateToString(incomingDate: fromDate ?? Date())
                } else if toDate == nil {
                    //MARK: Only fromDate will be showed to User
                    _self.dateLabel.stringValue = "Start Date - \(showToDateToUser ?? "")"
                    _self.selectedFromDate = FunctionsExtension.sharedInstance.dateToString(incomingDate: toDate ?? Date())
                    _self.selectedToDate = ""
                } else {
                    _self.selectedFromDate = FunctionsExtension.sharedInstance.dateToString(incomingDate: fromDate ?? Date())
                    _self.selectedToDate = FunctionsExtension.sharedInstance.dateToString(incomingDate: toDate ?? Date())
                    //MARK: All Dates will be showed to User
                    _self.dateLabel.stringValue = "\(showFromDateToUser ?? "") / \(showToDateToUser ?? "")"
                    _self.dateViewWidthConstraint.constant = 200
                }
            }
            //MARK: Selected Dates to send to API
            //            let fromDateInString = fromDate?.getFormattedStringFromDate(format: "yyyy-MM-dd")
            //            let toDateInString = toDate?.getFormattedStringFromDate(format: "yyyy-MM-dd")
            //MARK: Get Listing API
        }
        self.window?.contentViewController?.present(fromToDatePicker, asPopoverRelativeTo: .init(x: 0, y: 0, width: 150, height: 150), of: dateLabel, preferredEdge: .maxY, behavior: .transient)
    }
    
    private func setTitleToDatePickerPopup(_ controller: FromToDatePickerController) {
        let fromDate = Date()
        let toDate = Date()
        //MARK: Get selected Dates In String from Applied Filter
        let getSelectedFromDateString = fromDate.getFormattedStringFromDate(format: "dd-MMM-yy")
        //MARK: Fetch Selected To-date and convert them into dd-MMM-yy format to show to User
        let getSelectedToDateString = toDate.getFormattedStringFromDate(format: "dd-MMM-yy")
        //MARK: Dates are converted into dd-MMM-yy format to show to user as selected dates were in yyyy-MM-dd format
        if selectedFromDate == nil && selectedToDate == nil {
            //MARK: No Dates will be showed to User
            controller.setTitleToDates(fromDate: "From", toDate: "To")
        } else if selectedFromDate == nil {
            //MARK: Only toDate will be showed to User
            controller.toDate = getSelectedToDateString
        } else if selectedToDate == nil {
            //MARK: Only fromDate will be showed to User
            controller.fromDate = getSelectedFromDateString
        } else {
            //MARK: All Dates will be showed to User
            controller.setTitleToDates(fromDate: getSelectedFromDateString , toDate: getSelectedToDateString )
        }
    }
    
    public func showPopUpForButtonViews(toLabel label: NSTextField , showList itemList: [PopUpMenuItemModel]) {
        let menu = PopUpMenuViewController(menuItems: itemList)
        
        if label == typeTitleLabel {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 100, height: 125))
            menu.onSelectedItemModel = { [weak self] selectedTypeItem in
                guard let _self = self else { return }
                label.stringValue = selectedTypeItem.itemName ?? ""
                //                                _self.typeId = selectedTypeItem.strID ?? "none"
                ///// present we pass type none for now. when we get option to get data with type then we pass typeid
                _self.getComponentsListFromAPI(typeID: _self.typeId, filterStatus: _self.selectedStatusFilter, searchText: _self.searchText, fromDate: _self.selectedFromDate, toDate: _self.selectedToDate, sortID: _self.sortId)
            }
        } else if label == statusTitleLabel {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 80, height: 130))
            menu.onSelectedItemModel = {  [weak self]  selectedStatusItem in
                guard let _self = self else { return }
                
                label.stringValue = selectedStatusItem.itemName ?? ""
                _self.statusImageView.image = NSImage(named: selectedStatusItem.itemImage ?? "")
                _self.selectedStatusFilter = selectedStatusItem.itemName ?? "live"
                _self.getComponentsListFromAPI(typeID: _self.typeId, filterStatus: _self.selectedStatusFilter, searchText: _self.searchText, fromDate: _self.selectedFromDate, toDate: _self.selectedToDate, sortID: _self.sortId)
            }
        } else {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 80, height: 105))
            menu.onSelectedItemModel = { [weak self]  selectedSortItem in
                guard let _self = self else { return }
                label.stringValue = selectedSortItem.itemName ?? ""
                _self.sortId = selectedSortItem.itemName?.lowercased() ?? ""
                _self.getComponentsListFromAPI(typeID: _self.typeId, filterStatus: _self.selectedStatusFilter, searchText: _self.searchText, fromDate: _self.selectedFromDate, toDate: _self.selectedToDate, sortID: _self.sortId)
            }
        }
        self.window?.contentViewController?.present(menu, asPopoverRelativeTo: .zero, of: label, preferredEdge: .maxY, behavior: .transient)
    }
    
    @IBAction func createNewComponentButtonTapped(_ sender: NSButton) {
        let addEditView = AddAndEditComponentView(componentLogic: componentLogic, componentDelegate: self, componentModel: nil, websiteLogic: websiteLogic)
        userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    @IBAction func listSearchBarTapped(_ sender: NSSearchField) {
        self.searchText = sender.stringValue
        componentLogic.delegate = self
        componentLogic.getComponentsList(websiteId: self.websiteLogic?.websiteDetailsModel?.id, typeId: typeId, status: selectedStatusFilter, searchText: searchText, fromDate: selectedFromDate, toDate: selectedToDate, sortId: sortId)
    }
    
    @IBAction func componentGridListSegmentContollerTapped(_ sender: NSSegmentedControl) {
        componentViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
}

extension ComponentGridAndListCommonView : ComponentsLogicDelegate {
    
    func getComponentsListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            _self.componentViewMode = _self.gridListSegmentController.selectedSegment == 0 ? .grid : .list
        }
    }
    
    func getTypesListFromResponse() {
        typesPopupArray.removeAll()
        self.userIntractionHandlerView.isUserInteractionEnabled = true
        for type in componentLogic.typesListArray {
            let obj = type
            let key = obj.key
            let name = obj.name
            typesPopupArray.append(PopUpMenuItemModel(strMenuID: key, menuName: name, menuImage: ""))
        }
    }
    
    func addNewComponentInQueue() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.addComponent()
            _self.listView?.addComponent()
        }
    }
    
    func updateAddComponentSuccess(status: Int, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedComponent(index: index)
            _self.listView?.reloadSelectedComponent(index: index)
        }
    }
    
    func getComponentDetailsFromResponse() { }
    
    func editComponentInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = false
            _self.gridView?.reloadSelectedComponent(index: index)
            _self.listView?.reloadSelectedComponent(index: index)
        }
    }
    
    func updateEditComponent(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if _self.selectedStatusFilter == dataStatus || _self.selectedStatusFilter == "live" {
                _self.gridView?.reloadSelectedComponent(index: index)
                _self.listView?.reloadSelectedComponent(index: index)
            }else{
                _self.gridView?.removeSelectedComponent(index: index)
                _self.listView?.removeSelectedComponent(index: index)
            }
        }
    }
    
    func componentStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.gridView?.reloadSelectedComponent(index: index)
            _self.listView?.reloadSelectedComponent(index: index)
        }
    }
    
    func updateComponentStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            if dataStatus == "complete"{
                _self.gridView?.reloadData()
                _self.listView?.reloadData()
            } else {
                _self.gridView?.reloadSelectedComponent(index: index)
                _self.listView?.reloadSelectedComponent(index: index)
            }
        }
    }
    
    func updateDeleteComponentSuccess(status: Int, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
            if status == 1 {
                _self.gridView?.removeSelectedComponent(index: index)
                _self.listView?.removeSelectedComponent(index: index)
            } else {
                _self.gridView?.reloadSelectedComponent(index: index)
                _self.listView?.reloadSelectedComponent(index: index)
            }
        }
    }
    
    func showPoorInternet() { }
}
