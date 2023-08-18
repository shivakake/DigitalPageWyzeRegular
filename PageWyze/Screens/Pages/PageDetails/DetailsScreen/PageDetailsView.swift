//
//  PageDetailsView.swift
//  WebSites
//
//  Created by Nagendar on 28/12/22.
//

import Cocoa

class PageDetailsView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var descriptionStringLabel: NSTextField!
    @IBOutlet weak var typeStringLabel: NSTextField!
    @IBOutlet weak var urlStringLabel: NSTextField!
    @IBOutlet weak var metaTitleLabel: NSTextField!
    @IBOutlet weak var metaDescriptionLabel: NSTextField!
    @IBOutlet weak var canonicalLabel: NSTextField!
    @IBOutlet weak var contentAndCoadLabel: NSTextField!
    @IBOutlet weak var contentAndCodeHideButton: NSButton!
    @IBOutlet weak var pageDataHideButton: NSButton!
    @IBOutlet weak var pageComponentHideButton: NSButton!
    @IBOutlet weak var headHideButton: NSButton!
    @IBOutlet weak var headStringLabel: NSTextField!
    @IBOutlet weak var componentsTableView: NSTableView!
    @IBOutlet weak var pageDataRightButton: NSButton!
    @IBOutlet weak var pageComponentRightButton: NSButton!
    @IBOutlet weak var pageDataCustomView: NSView!
    @IBOutlet weak var pageComponentsconvertCustomView: NSView!
    @IBOutlet weak var pageComponentsView2: NSView!
    @IBOutlet weak var detailsTitleLabel: NSTextField!
    @IBOutlet weak var pageDataTableView: NSTableView!
    @IBOutlet weak var statusChangeButtonOutlet: NSButton!
    
    @IBOutlet weak var componentListCustomView: NSView!
    @IBOutlet weak var componentTypesListCustomView: NSView!
    @IBOutlet weak var componentListTitleLabel: NSTextField!
    @IBOutlet weak var componentTypeListTitleLabel: NSTextField!
    
    public var collectionOfPageDataCell = [PageDataCustomCell]()
    public var content = false
    public var websiteLogic: WebsitesLogic?
    public var pageLogic: PagesLogic?
    public var pageId: String?
    public weak var delegate: PagesLogicDelegate?
    public var onBackClick: (() -> Void)?
    public var keys: [String] = [String]()
    public var values: [String] = [String]()
    public var keysAndValuesDictArray: [[String:Any]] = []
    public var moreArray: [PopUpMenuItemModel] = []
    public var selectedPageComponents = ""
    
    fileprivate var tablePageComponents: [PageComponentDetailsModel] = []
    fileprivate var componentTitleListArray: [PopUpMenuItemModel] = []
    fileprivate var typeValuesPageComponents: [PopUpMenuItemModel] = []
    fileprivate var selectedComponentHeaderID = "none"
    fileprivate var selectedComponentValueID = "none"
    
    init(pagelogic: PagesLogic?, delegate: PagesLogicDelegate?, pageId: String?, websiteLogic: WebsitesLogic?) {
        self.pageLogic = pagelogic
        self.delegate = delegate
        self.websiteLogic = websiteLogic
        self.pageId = pageId
        super.init(frame: .zero)
        commonMethod()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethod()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public func commonMethod(){
        addView()
        systemTextStyle()
        handleHideViews()
        getPageDetailsFromAPI()
        configureTableView()
        configureCustomViews()
    }
    
    fileprivate func addView() {
        Bundle(for: PageDetailsView.self).loadNibNamed("PageDetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func configureCustomViews() {
        componentListCustomView.setBorder(color: .lightGray)
        componentListTitleLabel.font = .styleSelectionForSubtitle
        
        componentListCustomView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(componentListViewTapped)))
        
        componentTypesListCustomView.setBorder(color: .lightGray)
        componentTypeListTitleLabel.font = .styleSelectionForSubtitle
        
        componentTypesListCustomView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(componentTypeListViewTapped)))
        
    }
    
    @objc func componentListViewTapped() {
        if (content == false){
            pageComponentHideButton.image = NSImage.init(named: "NSTouchBarGoUpTemplate")
            content = true
        } else {
            pageComponentHideButton.image = NSImage.init(named: "NSTouchBarGoDownTemplate")
            content = false
        }
        if !componentTitleListArray.isEmpty {
            self.showPopUpForButtonViews(toLabel: componentListTitleLabel, showList: componentTitleListArray)
        }
        
    }
    
    @objc func componentTypeListViewTapped() {
        if !typeValuesPageComponents.isEmpty {
            self.showPopUpForButtonViews(toLabel: componentTypeListTitleLabel, showList: self.typeValuesPageComponents)
        }
    }
    
    public func getPageDetailsFromAPI() {
        pageLogic?.delegate = self
        pageLogic?.getComponentsTypesList()
        pageLogic?.getPageComponentsList(websiteId: websiteLogic?.websiteDetailsModel?.id)
        pageLogic?.getPageDetails(websiteId: self.websiteLogic?.websiteDetailsModel?.id, pageId: pageLogic?.pageDetailsData?.id)
    }
    
    @IBAction func contentCodeHideButtonTapped(_ sender: NSButton) {
        if (content == false) {
            contentAndCodeHideButton.image = NSImage.init(named: "NSTouchBarGoUpTemplate")
            content = true
        } else   {
            contentAndCodeHideButton.image = NSImage.init(named: "NSTouchBarGoDownTemplate")
            content = false
        }
        contentAndCoadLabel.isHidden = !contentAndCoadLabel.isHidden
    }
    
    @IBAction func headHideButtonTapped(_ sender: NSButton) {
        if (content == false) {
            headHideButton.image = NSImage.init(named: "NSTouchBarGoUpTemplate")
            content = true
        } else {
            headHideButton.image = NSImage.init(named: "NSTouchBarGoDownTemplate")
            content = false
        }
        headStringLabel!.isHidden = !headStringLabel.isHidden
    }
    
    @IBAction func pageDataHideButtonTapped(_ sender: NSButton) {
        if (content == false){
            pageDataHideButton.image = NSImage.init(named: "NSTouchBarGoUpTemplate")
            content = true
        } else {
            pageDataHideButton.image = NSImage.init(named: "NSTouchBarGoDownTemplate")
            content = false
        }
        
        pageDataCustomView!.isHidden = !pageDataCustomView.isHidden
    }
    
    @IBAction func pageComponentHideButtonTapped(_ sender: NSButton) {
        pageComponentsView2!.isHidden = !pageComponentsView2.isHidden
    }
    
    @IBAction func addComponentButtonTapped(_ sender: NSButton) {
        
        if let firstIndex = componentTitleListArray.firstIndex(where: { $0.strID == selectedComponentHeaderID}) {
            componentTitleListArray.remove(at: firstIndex)
        }
        
        if let model = pageLogic?.pageComponentsListArray.first(where: { $0.id == selectedComponentHeaderID}){
            tablePageComponents.append(model)
        }
        
        selectedComponentHeaderID = "None"
        componentListTitleLabel.stringValue = ""
        componentTypeListTitleLabel.stringValue = ""
        componentsTableView.reloadData()
    }
    
    @IBAction func saveComponentDataButtonTapped(_ sender: NSButton) {
        var componentsValueIds = [String]()
        for item in tablePageComponents {
            componentsValueIds.append(item.selectedId ?? "none")
        }
        let finalString = componentsValueIds.joined(separator: ",")
        pageLogic?.delegate = self
        pageLogic?.editPageComponent(websiteId: self.websiteLogic?.websiteDetailsModel?.id, ref: pageId, components: finalString)
    }
    
    @IBAction func editPageInformationButtonTapped(_ sender: Any) {
        let addAndEditPage = AddAndEditPageView(pageLogic: pageLogic, pageDelegate: self, websiteLogic: self.websiteLogic, editComingFrom: "Information")
        addViewThroughConstraints(for: addAndEditPage, in: parentCustomView)
    }
    
    @IBAction func editSeoInformationButtonTapped(_ sender: Any) {
        let addAndEditPage = AddAndEditPageView(pageLogic: pageLogic, pageDelegate: self, websiteLogic: self.websiteLogic, editComingFrom: "Seo")
        addViewThroughConstraints(for: addAndEditPage, in: parentCustomView)
    }
    
    @IBAction func editContentAndCodeButtonTapped(_ sender: NSButton) {
        let addAndEditPage = AddAndEditPageView(pageLogic: pageLogic, pageDelegate: self, websiteLogic: self.websiteLogic, editComingFrom: "Content")
        addViewThroughConstraints(for: addAndEditPage, in: parentCustomView)
    }
    
    @IBAction func editHeadButtonTapped(_ sender: NSButton) {
        let addAndEditPage = AddAndEditPageView(pageLogic: pageLogic, pageDelegate: self, websiteLogic: self.websiteLogic, editComingFrom: "Head")
        addViewThroughConstraints(for: addAndEditPage, in: parentCustomView)
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        onBackClick?()
    }
    
    @IBAction func statusChangeButtonTapped(_ sender: NSButton) {
        
        let controller = PopUpMenuViewController(menuItems: moreArray)
        controller.applyConstraintForImage(with: 20)
        let height = ((moreArray.count * 30) + 5)
        controller.applyConstraintForCompleteMenu(tableSize: CGSize(width: 120, height: height))
        
        controller.onSelectedItemModel = { [weak self] selectedItem in
            guard let _self = self else { return }
            if selectedItem.strID == "approve"{
                _self.pageLogic?.approvePage(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "", pageId: _self.pageId ?? "")
            } else if selectedItem.strID == "draft"{
                _self.pageLogic?.draftPage(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "", pageId: _self.pageId ?? "")
            } else if selectedItem.strID == "complete" {
                _self.pageLogic?.completePage(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "", pageId: _self.pageId ?? "")
            }else{
                _self.pageLogic?.delegate = self
                _self.pageLogic?.deletePage(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "", pageId: _self.pageId ?? "")
            }
        }
        
        window?.contentViewController?.present(controller, asPopoverRelativeTo: .init(x: 0, y: 0, width: 120, height: height), of: statusChangeButtonOutlet, preferredEdge: .maxY, behavior: .transient)
    }
    
    public func setStatusAndMenu(for status: String?) {
        
        let draftMenu = PopUpMenuItemModel(strMenuID: "draft" , menuName: "Draft" , menuImage: "drafts")
        let approveMenu = PopUpMenuItemModel(strMenuID: "approve" , menuName: "Approve", menuImage: "approve")
        let deleteMenu = PopUpMenuItemModel(strMenuID: "delete", menuName: "Delete", menuImage: "delete")
        let completeMenu = PopUpMenuItemModel(strMenuID: "complete" , menuName: "Complete", menuImage: "complete")
        
        switch status?.lowercased() {
        
        case "active", "live":
            moreArray = [draftMenu, completeMenu , deleteMenu]
        case "draft":
            moreArray = [deleteMenu, approveMenu]
        case "complete" :
            moreArray = [deleteMenu]
        case "inactive" :
            break
        case "error":
            break
        case "queue" :
            break
        default:
            break
        }
    }
    
    @IBAction func pageDataSaveButtonTapped(_ sender: NSButton) {
        for key in pageLogic?.pagesDataListArray ?? [] {
            keys.append(key.keyString ?? "")
            values.append(key.valueString ?? "")
        }
        for (keyIndex, key) in keys.enumerated() {
            for (valueIndex, val) in values.enumerated() {
                var dict: [String:Any] = [:]
                if keyIndex == valueIndex{
                    dict[key] = val
                    keysAndValuesDictArray.append(dict)
                    break
                }else{
                    //                    break
                }
            }
        }
        
        let paramDict : [String: Any]
        paramDict = ["data": keysAndValuesDictArray]
        let paramJson = FunctionsExtension.sharedInstance.convertDictToJSONString(objJsonDict: paramDict)
        pageLogic?.delegate = self
        pageLogic?.savePageData(websiteId: self.websiteLogic?.websiteDetailsModel?.id, ref: self.pageLogic?.pageDetailsData?.id, data: paramJson)
    }
    
    public func systemTextStyle(){
        urlStringLabel.font = .systemFont(ofSize: 14, weight: .regular)
        typeStringLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionStringLabel.font = .systemFont(ofSize: 14, weight: .regular)
        metaTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        metaDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        canonicalLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    public func handleHideViews() {
        contentAndCoadLabel.isHidden = true
        headStringLabel.isHidden = true
        pageComponentsView2.isHidden = true
        pageDataCustomView.isHidden = true
        typeStringLabel.translatesAutoresizingMaskIntoConstraints = false
        pageComponentRightButton.isHidden = true
        pageDataRightButton.isHidden = true
    }
    
    public func configureTableView() {
        componentsTableView.dataSource = self
        componentsTableView.delegate = self
        
        componentsTableView.selectionHighlightStyle = .none
        componentsTableView.register(NSNib(nibNamed: "ComponentsCustomCell" , bundle: Bundle(for: ComponentsCustomCell.self)), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ComponentsCustomCell"))
        
        pageDataTableView.delegate = self
        pageDataTableView.dataSource = self
        
        pageDataTableView.register(NSNib(nibNamed: "PageDataCustomCell", bundle: Bundle(for: PageDataCustomCell.self)), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PageDataCustomCell"))
    }
    
    public func updateUI(pageDetails: PageDetailsDataModel?) {
        urlStringLabel.stringValue = pageDetails?.url ?? ""
        typeStringLabel.stringValue = pageDetails?.typename ?? ""
        metaTitleLabel.stringValue = pageDetails?.metatitle ?? ""
        metaDescriptionLabel.stringValue = pageDetails?.metadescription ?? ""
        canonicalLabel.stringValue = pageDetails?.canonical ?? ""
        descriptionStringLabel.stringValue = pageDetails?.description ?? ""
        contentAndCoadLabel.stringValue = pageDetails?.text?.withoutHtml ?? ""
        headStringLabel.stringValue = pageDetails?.head ?? ""
        setStatusAndMenu(for: pageDetails?.datastatus ?? "live")
    }
    
    public func reloadPageData(table: NSTableView) {
        if table == componentsTableView{
            componentsTableView.reloadData()
        }else{
            pageDataTableView.reloadData()
        }
    }
    
    public func reloadSelectedPage(table: NSTableView, index: Int) {
        if table == componentsTableView{
            componentsTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
        }else{
            pageDataTableView.reloadData(forRowIndexes: [index], columnIndexes: [0])
        }
    }
    
    public func removeSelectedPage(table: NSTableView, index: Int) {
        if table == componentsTableView{
            componentsTableView.removeRows(at: [index])
        }else{
            pageDataTableView.removeRows(at: [index])
        }
    }
    
    public func addPageData(table: NSTableView) {
        if table == componentsTableView{
            componentsTableView.beginUpdates()
            componentsTableView.insertRows(at: [0])
            componentsTableView.endUpdates()
        }else{
            pageDataTableView.beginUpdates()
            pageDataTableView.insertRows(at: [0])
            pageDataTableView.endUpdates()
        }
    }
    
    public func showPopUpForButtonViews(toLabel label: NSTextField , showList itemList: [PopUpMenuItemModel]) {
        let menu = PopUpMenuViewController(menuItems: itemList)
        menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 125, height: 120))
        menu.onSelectedItemModel = { [weak self] selectedTypeItem in
            guard let _self = self else { return }
            
            if label == _self.componentListTitleLabel {
                _self.selectedComponentHeaderID = selectedTypeItem.strID ?? "none"
                if let componentModel = _self.pageLogic?.pageComponentsListArray.first(where: { $0.id == selectedTypeItem.strID }) {
                    _self.typeValuesPageComponents.removeAll()
                    _self.typeValuesPageComponents = (componentModel.items ?? []).map({ PopUpMenuItemModel(strMenuID: $0.id, menuName: $0.name, menuImage: "") })
                    if componentModel.items?.count == 0 {
                        _self.componentTypeListTitleLabel.stringValue = "None"
                        _self.selectedComponentValueID = "none"
                    }else{
                        _self.componentTypeListTitleLabel.stringValue = componentModel.items?.first?.name ?? ""
                        _self.selectedComponentValueID = componentModel.items?.first?.id ?? ""
                    }
                }
            } else {
                _self.selectedComponentValueID = selectedTypeItem.strID ?? "none"
            }
            
            label.stringValue = selectedTypeItem.itemName ?? ""
        }
        self.window?.contentViewController?.present(menu, asPopoverRelativeTo: .zero, of: label, preferredEdge: .maxX, behavior: .transient)
    }
}

extension PageDetailsView: NSTableViewDataSource,NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == componentsTableView{
            //            return constantPageComponentsArray.count //pageLogic?.componentsListArray.count ?? 0
            return tablePageComponents.count //pageLogic?.pageComponentsListArray.count ?? 0
        } else {
            return pageLogic?.pagesDataListArray.count ?? 0
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableView == componentsTableView {
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ComponentsCustomCell"), owner: self) as? ComponentsCustomCell else { return NSView() }
            cell.componentModel = tablePageComponents[row] //pageLogic?.pageComponentsListArray[row]
            cell.deleteComponentCallBack = { [weak self] componentId in
                if let firstIndex = self?.tablePageComponents.firstIndex(where: { $0.id == componentId}) {
                    self?.tablePageComponents.remove(at: firstIndex)
                    self?.componentsTableView.removeRows(at: [firstIndex], withAnimation: .effectFade)
                }
                
                if let model = self?.pageLogic?.pageComponentsListArray.first(where: { $0.id == componentId}){
                    self?.componentTitleListArray.append(PopUpMenuItemModel(strMenuID: model.id, menuName: model.name, menuImage: ""))
                }
            }
            return cell
        } else {
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PageDataCustomCell"), owner: self) as? PageDataCustomCell else { return NSView() }
            collectionOfPageDataCell.append(cell)
            cell.configureCell(pageDataModel: pageLogic?.pagesDataListArray[row], websiteDataModel: websiteLogic?.websitesPagesListArray[row])
            cell.valusCallBack = { [weak self] value in
                guard let _self = self else { return }
                _self.pageLogic?.pagesDataListArray[row].valueString = value
            }
            return cell
        }
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        //        print(tableView.selectedRow)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if tableView == componentsTableView {
            return 35
        } else {
            return 75
        }
    }
}

extension PageDetailsView : PagesLogicDelegate {
    
    func getPagesListFromResponse() { }
    
    func getTypesListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.reloadPageData(table: _self.componentsTableView)
        }
    }
    
    func verifyPageURLSuccess(status: Int?) { }
    
    func addNewPageInQueue() { }
    
    func updateAddPageSuccess(ststus: Int, index: Int) { }
    
    func getPageDetailsFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateUI(pageDetails: _self.pageLogic?.pageDetailsData)
            _self.reloadPageData(table: _self.pageDataTableView)
            _self.reloadPageData(table: _self.componentsTableView)
        }
    }
    
    func editPageInformationInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateUI(pageDetails: _self.pageLogic?.sortedPageListArray[index])
            _self.delegate?.editPageInformationInQueue(index: index)
        }
    }
    
    func updateEditPageInformation(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            //            _self.setStatusAndMenu(for: dataStatus)
            _self.updateUI(pageDetails: _self.pageLogic?.sortedPageListArray[index])
            _self.reloadPageData(table: _self.componentsTableView)
            _self.delegate?.updateEditPageInformation(index: index, dataStatus: dataStatus)
        }
    }
    
    func pageStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.pageStatusChangeForQueue(index: index)
        }
    }
    
    func updatePageStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.updatePageStatusChange(dataStatus: dataStatus, index: index)
            _self.setStatusAndMenu(for: dataStatus)
            if dataStatus == "complete" {
                _self.onBackClick?()
                _self.removeFromSuperview()
            }
        }
    }
    
    func updateDeletePageSuccess(status: Int, index: Int) {
        delegate?.updateDeletePageSuccess(status: status, index: index)
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.onBackClick?()
            _self.removeFromSuperview()
        }
    }
    
    func getPageComponentsListFromResponse() {
        tablePageComponents.removeAll()
        componentTitleListArray.removeAll()
        
        for component in pageLogic?.pageComponentsListArray ?? [] {
            if component.name == "Stylesheet" || component.name == "Header" || component.name == "Head" || component.name == "Footer" {
                tablePageComponents.append(component)
            } else {
                componentTitleListArray.append(PopUpMenuItemModel(strMenuID: component.id ?? "", menuName: component.name ?? "", menuImage: ""))
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.reloadPageData(table: _self.componentsTableView)
        }
    }
    
    func showPoorInternet() { }
}
