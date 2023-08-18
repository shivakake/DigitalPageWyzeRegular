//
//  WebsiteDetailsView.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 16/02/23.
//

import Cocoa

class WebsiteDetailsView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerCustomView: UIUserInteractionHandler!
    @IBOutlet weak var textFieldView4: NSView!
    @IBOutlet weak var websiteNameLabel: NSTextField!
    @IBOutlet weak var websiteURLLabel: NSTextField!
    @IBOutlet weak var typeNameLabel: NSTextField!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var secureImageView: NSImageView!
    @IBOutlet weak var wwwImageView: NSImageView!
    @IBOutlet weak var categoryNameLabel: NSTextField!
    @IBOutlet weak var languageNameLabel: NSTextField!
    @IBOutlet weak var logoNameLabel: NSTextField!
    @IBOutlet weak var logoImageView: NSImageView!
    @IBOutlet weak var faviconNameLabel: NSTextField!
    @IBOutlet weak var faviconImageView: NSImageView!
    @IBOutlet weak var copyrightsLabel: NSTextField!
    @IBOutlet weak var generateFilesMenu: NSPopUpButton!
    @IBOutlet weak var generatedFileStatusLabel: NSTextField!
    @IBOutlet weak var pageNameTextField: NSTextField!
    @IBOutlet weak var pageKeyTextField: NSTextField!
    @IBOutlet weak var pageLengthTextField: NSTextField!
    @IBOutlet weak var pageDataTabelView: NSTableView!
    @IBOutlet weak var pageTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statisticsTabelView: NSTableView!
    @IBOutlet weak var statisticsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editBrandInfoButtonOutlet: NSButton!
    @IBOutlet weak var statusChangeButtonOutlet: NSButton!
    
    public var websiteLogic: WebsitesLogic?
    public weak var delegate: WebsitesLogicDelegate?
    public var statisticsListArray: [StatisticsDataModel] = [StatisticsDataModel]()
    public var pagesListArray: [PageDataModel] = [PageDataModel]()
    public var editbrandInfoView: EditBrandView?
    public var timer = Timer()
    public var onBackToList: (() -> Void)?
    public var moreArray: [PopUpMenuItemModel] = []
    
    init(logic: WebsitesLogic?, delegate: WebsitesLogicDelegate?) {
        self.websiteLogic = logic
        self.delegate = delegate
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
    
    fileprivate func addView() {
        Bundle(for: WebsiteDetailsView.self).loadNibNamed("WebsiteDetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethod(){
        addView()
        setupUI()
        getWebsiteDetailsFromAPI()
        configureTableView()
    }
    
    public func setupUI() {
        generateFilesMenu.addItems(withTitles: ["none","robots.txt", "sitemap.xml"])
    }
    
    public func getWebsiteDetailsFromAPI() {
        websiteLogic?.delegate = self
        websiteLogic?.getStatisticsList(websiteId: websiteLogic?.websiteDetailsModel?.id)
        websiteLogic?.getWebsiteDetails(websiteId: websiteLogic?.websiteDetailsModel?.id)
    }
    
    @IBAction func editBrandInfoButtonTapped(_ sender: NSButton) {
        if editbrandInfoView == nil {
            editbrandInfoView = EditBrandView(websiteLogic: websiteLogic, websiteDelegate: self)
        }
        addViewThroughConstraints(for: editbrandInfoView ?? NSView(), in: parentCustomView)
    }
    
    @IBAction func addPageToListButtonTapped(_ sender: Any) {
        guard let pageName = pageNameTextField?.stringValue else { return }
        guard let pageKey = pageKeyTextField?.stringValue else { return }
        guard let pageLength = pageLengthTextField?.stringValue else { return }
        pagesListArray.append(PageDataModel(name: pageName, key: pageKey, length: pageLength))
        pageTableViewHeightConstraint.constant = CGFloat((pagesListArray.count * 30) + 10)
        pageDataTabelView.reloadData()
        pageNameTextField.stringValue = ""
        pageKeyTextField.stringValue = ""
        pageLengthTextField.stringValue = ""
    }
    
    @IBAction func statusChangeButtonTapped(_ sender: NSButton) {
        
        let controller = PopUpMenuViewController(menuItems: moreArray)
        controller.applyConstraintForImage(with: 20)
        let height = ((moreArray.count * 30) + 5)
        controller.applyConstraintForCompleteMenu(tableSize: CGSize(width: 120, height: height))
        
        controller.onSelectedItemModel = { [weak self] selectedItem in
            guard let _self = self else { return }
            if selectedItem.strID == "edit" {
                _self.onEditOperationTapped()
            }else if selectedItem.strID == "approve"{
                _self.websiteLogic?.approveWebsite(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "")
            } else if selectedItem.strID == "draft"{
                _self.websiteLogic?.draftWebsite(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "")
            } else if selectedItem.strID == "complete" {
                _self.websiteLogic?.completeWebsite(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "")
            }else{
                _self.websiteLogic?.delegate = self
                _self.websiteLogic?.deleteWebsite(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "")
            }
        }
        
        window?.contentViewController?.present(controller, asPopoverRelativeTo: .init(x: 0, y: 0, width: 120, height: height),
                                               of: statusChangeButtonOutlet,
                                               preferredEdge: .minY,
                                               behavior: .transient)
    }
    
    @IBAction func checkGeneratedFileTapped(_ sender: NSButton) {
        websiteLogic?.delegate = self
        websiteLogic?.checkGeneratedFile(websiteId: websiteLogic?.websiteDetailsModel?.id, fileName: generateFilesMenu.selectedItem?.title)
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        onBackToList?()
    }
    
    @IBAction func pageDataSaveButtonTapped(_ sender: NSButton) {
        let jsonEncoder = JSONEncoder()
        //MARK: Here we have to convert data model to data and then we have to convert data to json
        // Converting model data to data
        do {
            let jsonData = try jsonEncoder.encode(pagesListArray)
            // Converting data to json
            if let jsonParam = FunctionsExtension.sharedInstance.nsdataToJSON(data: jsonData as NSData) {
                let paramDict : [String: Any]
                paramDict = ["pagedata": jsonParam]
                let paramJson = FunctionsExtension.sharedInstance.convertDictToJSONString(objJsonDict: paramDict)//convertDictToJSONString(objJsonDict: paramDict)
                websiteLogic?.delegate = self
                websiteLogic?.savePageData(websiteId: websiteLogic?.websiteDetailsModel?.id, pageData: paramJson)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    public func configureTableView() {
        pageDataTabelView.delegate = self
        pageDataTabelView.dataSource = self
        pageDataTabelView.selectionHighlightStyle = .none
        pageDataTabelView.register(NSNib(nibNamed: "PageDataDeleteCustomCell", bundle: Bundle(for: PageDataDeleteCustomCell.self)), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PageDataDeleteCustomCell"))
        
        statisticsTabelView.delegate = self
        statisticsTabelView.dataSource = self
        statisticsTabelView.selectionHighlightStyle = .none
    }
    
    public func setStatusAndMenu(for status: String?) {
        
        let editMenu = PopUpMenuItemModel(strMenuID: "edit", menuName: "Edit" , menuImage: "edits")
        let draftMenu = PopUpMenuItemModel(strMenuID: "draft" , menuName: "Draft" , menuImage: "drafts")
        let approveMenu = PopUpMenuItemModel(strMenuID: "approve" , menuName: "Approve", menuImage: "approve")
        let deleteMenu = PopUpMenuItemModel(strMenuID: "delete", menuName: "Delete", menuImage: "delete")
        let completeMenu = PopUpMenuItemModel(strMenuID: "complete" , menuName: "Complete", menuImage: "complete")
        
        switch status?.lowercased() {
        
        case "active", "live":
            moreArray = [editMenu, draftMenu, completeMenu , deleteMenu]
        case "draft":
            moreArray = [editMenu, deleteMenu, approveMenu]
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
    
    @objc func onEditOperationTapped() {
        let addEditView = AddAndEditWebsiteView(websiteLogic: websiteLogic, websiteModel: self.websiteLogic?.websiteDetailsModel, websiteDelegate: delegate)
        self.userIntractionHandlerCustomView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerCustomView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
    }
    
    public func updateUI(index: Int) {
        let logourl = websiteLogic?.sortedWebsiteList[index].logourl
        let logoName = logourl?.components(separatedBy: "/")
        logoNameLabel.stringValue = logoName?.last ?? ""
        logoImageView.getImageFormURLString(imageString: websiteLogic?.sortedWebsiteList[index].logourl ?? "")
        
        let faviconurl = websiteLogic?.sortedWebsiteList[index].faviconurl
        let faviconName = faviconurl?.components(separatedBy: "/")
        faviconNameLabel.stringValue = faviconName?.last ?? ""
        faviconImageView.getImageFormURLString(imageString: websiteLogic?.sortedWebsiteList[index].faviconurl ?? "")
        
        copyrightsLabel.stringValue = websiteLogic?.sortedWebsiteList[index].copyright ?? ""
        websiteNameLabel.stringValue = websiteLogic?.sortedWebsiteList[index].name ?? ""
        websiteURLLabel.stringValue = websiteLogic?.sortedWebsiteList[index].url ?? ""
        typeNameLabel.stringValue = websiteLogic?.sortedWebsiteList[index].typename ?? ""
        descriptionLabel.stringValue = websiteLogic?.sortedWebsiteList[index].description ?? ""
        categoryNameLabel.stringValue = websiteLogic?.sortedWebsiteList[index].categoryname ?? ""
        languageNameLabel.stringValue = websiteLogic?.sortedWebsiteList[index].languagename ?? ""
        
        if websiteLogic?.websiteDetailsModel?.www == "Yes" {
            wwwImageView.image = NSImage(named: "tick")
        }else{
            wwwImageView.image = NSImage(named: "cross")
        }
        
        if websiteLogic?.websiteDetailsModel?.secure == "Yes" {
            secureImageView.image = NSImage(named: "tick")
        }else{
            secureImageView.image = NSImage(named: "cross")
        }
    }
}

extension WebsiteDetailsView: NSTableViewDataSource,NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == pageDataTabelView {
            return pagesListArray.count
        } else {
            return statisticsListArray.count
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableView == pageDataTabelView {
            switch tableColumn?.title {
            case "Name":
                let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
                cell?.textField?.stringValue = pagesListArray[row].name ?? ""
                return cell
            case "Key":
                let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
                cell?.textField?.stringValue = pagesListArray[row].key ?? ""
                return cell
            case "Length":
                let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
                cell?.textField?.stringValue = String(format: pagesListArray[row].length ?? "")
                return cell
            case "" :
                guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PageDataDeleteCustomCell"), owner: self) as? PageDataDeleteCustomCell else { return NSView()}
                cell.deletePageCallBack = { [weak self] in
                    guard let _self = self else { return }
                    _self.pagesListArray.remove(at: row)
                    _self.pageTableViewHeightConstraint.constant = CGFloat((_self.pagesListArray.count * 30) + 10)
                    _self.pageDataTabelView.reloadData()
                }
                return cell
            default:
                break
            }
        } else {
            let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
            
            switch tableColumn?.title {
            case "":
                cell?.textField?.stringValue = (statisticsListArray[row].name ?? "") + " " + (statisticsListArray[row].value ?? "")
            default:
                break
            }
            return cell
        }
        return NSView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        if tableView == pageDataTabelView {
            return 30
        } else {
            return 20
        }
    }
    /*
     func tableViewSelectionDidChange(_ notification: Notification) {
     guard let selectedTable = notification.object as? NSTableView else { return }
     let selectedModel = groupArray[selectedTable.selectedRow]
     onListItemClick?(selectedModel)
     }
     */
}

extension WebsiteDetailsView : WebsitesLogicDelegate {
    
    func getWebsitesListFromResponse() { }
    
    func getTypesListFromResponse() { }
    
    func getLanguagesListFromResponse() { }
    
    func getCategoriesListFromResponse() { }
    
    func getVerifyDomainResponse(status: Int?) { }
    
    func addNewWebsiteInQueue() { }
    
    func updateAddWebsiteSuccess(ststus: Int, index: Int) { }
    
    func getWebsiteDetailsFromResponse(detailsModel: WebsiteDetailsDataModel?, pagesList: [PageDataModel]?) {
        self.pagesListArray = pagesList ?? []
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.websiteNameLabel.stringValue = detailsModel?.name ?? ""
            _self.websiteURLLabel.stringValue = detailsModel?.url ?? ""
            _self.typeNameLabel.stringValue = detailsModel?.typename ?? ""
            _self.categoryNameLabel.stringValue = detailsModel?.categoryname ?? ""
            _self.languageNameLabel.stringValue = detailsModel?.languagename ?? ""
            _self.logoNameLabel.stringValue = detailsModel?.logoname ?? ""
            _self.descriptionLabel.stringValue = detailsModel?.description ?? ""
            _self.setStatusAndMenu(for: detailsModel?.datastatus ?? "live")
            
            if detailsModel?.www == "Yes" {
                _self.wwwImageView.image = NSImage(named: "tick")
            }else{
                _self.wwwImageView.image = NSImage(named: "cross")
            }
            
            if detailsModel?.secure == "Yes" {
                _self.secureImageView.image = NSImage(named: "tick")
            }else{
                _self.secureImageView.image = NSImage(named: "cross")
            }
            
            _self.logoImageView.getImageFormURLString(imageString: detailsModel?.logourl ?? "")
            _self.faviconNameLabel.stringValue = detailsModel?.faviconname ?? ""
            _self.faviconImageView.getImageFormURLString(imageString: detailsModel?.faviconurl ?? "")
            _self.copyrightsLabel.stringValue = detailsModel?.copyright ?? ""
            _self.pagesListArray = pagesList ?? []
            _self.pageTableViewHeightConstraint.constant = CGFloat((_self.pagesListArray.count * 30) + 10)
            _self.pageDataTabelView.reloadData()
        }
    }
    
    func getGeneratedFileResponse(status: Int?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            if status == 1 {
                _self.generatedFileStatusLabel.isHidden = false
                _self.generatedFileStatusLabel.textColor = .systemGreen
                _self.generatedFileStatusLabel.stringValue = "Completed!"
                _self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self as Any, selector: #selector(_self.hideGenerateComplete), userInfo: nil, repeats: false)
            }else{
                _self.generatedFileStatusLabel.isHidden = false
                _self.generatedFileStatusLabel.textColor = .red
                _self.generatedFileStatusLabel.stringValue = "Oops! Not completed"
                _self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self as Any, selector: #selector(_self.hideGenerateComplete), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func hideGenerateComplete() {
        generatedFileStatusLabel.isHidden = true
    }
    
    func getStatisticListResponse(statisticsDataModel: [StatisticsDataModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.statisticsListArray = statisticsDataModel
            _self.statisticsTableViewHeightConstraint.constant = CGFloat((_self.statisticsListArray.count * 20))
            _self.statisticsTabelView.reloadData()
        }
    }
    
    func updateEditPageDataSuccess(datastatus: String) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.websiteLogic?.websitesPagesListArray = _self.pagesListArray
            //            _self.pagesListArray = _self.websiteLogic?.pagesListArray ?? []
            _self.pageTableViewHeightConstraint.constant = CGFloat((_self.pagesListArray.count * 30) + 10)
            _self.pageDataTabelView.reloadData()
        }
    }
    
    func editWebsiteInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateUI(index: index)
            _self.delegate?.editWebsiteInQueue(index: index)
        }
    }
    
    func updateEditWebsiteSuccess(index: Int, copyRight: String, dataStatus: String) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.setStatusAndMenu(for: dataStatus)
            _self.updateUI(index: index)
            _self.delegate?.updateEditWebsiteSuccess(index: index, copyRight: copyRight, dataStatus: dataStatus)
        }
    }
    
    func getFilesListFromResponse() { }
    
    func getGroupsListFromResponse() { }
    
    func updateWebsiteStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.updateWebsiteStatusChange(dataStatus: dataStatus, index: index)
            _self.setStatusAndMenu(for: dataStatus)
            if dataStatus == "complete" {
                _self.onBackToList?()
                _self.removeFromSuperview()
            }
        }
    }
    
    func websiteStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.websiteStatusChangeForQueue(index: index)
        }
    }
    
    func updateDeleteWebsiteSuccess(status: Int, index: Int) {
        delegate?.updateDeleteWebsiteSuccess(status: status, index: index)
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.onBackToList?()
            _self.removeFromSuperview()
        }
    }
    
    func showPoorInternet() { }
}
