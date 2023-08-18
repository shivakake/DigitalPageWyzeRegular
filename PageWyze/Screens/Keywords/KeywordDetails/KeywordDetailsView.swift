//
//  KeywordDetailsView.swift
//  WebSites
//
//  Created by Nagendar on 04/01/23.
//

import Cocoa

class KeywordDetailsView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var pagaDataLabel: NSTextField!
    @IBOutlet weak var informationLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var statusChangeButtonOutlet: NSButton!
    
    public var websiteLogic: WebsitesLogic?
    public var keywordLogic: KeywordLogic?
    public weak var delegate: KeywordLogicDelegate?
    public var onBackClick: (() -> Void)?
    public var moreArray: [PopUpMenuItemModel] = []
    
    public var typeId = "none"
    public var selectedStatusFilter = "live"
    public var searchText = ""
    public var sortId = "name"
    public var selectedFromDate = ""
    public var selectedToDate = ""
    
    init(keywordLogic: KeywordLogic?, delegate: KeywordLogicDelegate?, websiteLogic: WebsitesLogic?) {
        self.keywordLogic = keywordLogic
        self.delegate = delegate
        self.websiteLogic = websiteLogic
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
        getKeywordDetailsFromAPI()
    }
    
    fileprivate func addView() {
        Bundle(for: KeywordDetailsView.self).loadNibNamed("KeywordDetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func textStyling(){
        titleLabel.font = .styleSelectionBoldText
        informationLabel.font = .systemFont(ofSize: 12, weight: .regular)
        pagaDataLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    func updateData(keywordDetails: KeywordDetailsDataModel?) {
        titleLabel.stringValue = keywordDetails?.name ?? ""
        pagaDataLabel.stringValue = keywordDetails?.description ?? ""
        setStatusAndMenu(for: keywordDetails?.datastatus)
    }
    
    public func getKeywordDetailsFromAPI() {
        keywordLogic?.delegate = self
        keywordLogic?.getKeywordDetails(websiteId: self.websiteLogic?.websiteDetailsModel?.id, keywordId: self.keywordLogic?.keywordDetailsData?.id, pageId: "none")
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    @IBAction func statusChangeButtonTapped(_ sender: NSButton) {
        
        let controller = PopUpMenuViewController(menuItems: moreArray)
        controller.applyConstraintForImage(with: 20)
        let height = ((moreArray.count * 30) + 5)
        controller.applyConstraintForCompleteMenu(tableSize: CGSize(width: 120, height: height))
        
        controller.onSelectedItemModel = { [weak self] selectedItem in
            guard let _self = self else { return }
            if selectedItem.strID == "edit"{
                _self.onEditOperationTapped()
            } else if selectedItem.strID == "approve"{
                _self.keywordLogic?.approveKeyword(websiteId: _self.websiteLogic?.websiteDetailsModel?.id, keywordId: _self.keywordLogic?.keywordDetailsData?.id, pageId: "none")
            } else if selectedItem.strID == "draft"{
                _self.keywordLogic?.draftKeyword(websiteId: _self.websiteLogic?.websiteDetailsModel?.id, keywordId: _self.keywordLogic?.keywordDetailsData?.id, pageId: "none")
            } else if selectedItem.strID == "complete" {
                _self.keywordLogic?.completeKeyword(websiteId: _self.websiteLogic?.websiteDetailsModel?.id, keywordId: _self.keywordLogic?.keywordDetailsData?.id, pageId: "none")
            } else {
                _self.keywordLogic?.delegate = self
                _self.keywordLogic?.deleteKeyword(websiteId: _self.websiteLogic?.websiteDetailsModel?.id, keywordId: _self.keywordLogic?.keywordDetailsData?.id, pageId: "none")
            }
        }
        
        window?.contentViewController?.present(controller, asPopoverRelativeTo: .init(x: 0, y: 0, width: 120, height: height), of: statusChangeButtonOutlet, preferredEdge: .maxY, behavior: .transient)
    }
    
    @objc func onEditOperationTapped() {
        let addEditView = AddAndEditKeywordView(keywordLogic: keywordLogic, keywordDelegate: self, keywordModel: keywordLogic?.keywordDetailsData, websiteLogic: websiteLogic)
        self.userIntractionHandlerView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerView.isUserInteractionEnabled = true
        }
        addViewThroughConstraints(for: addEditView, in: parentCustomView)
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
}

extension KeywordDetailsView: KeywordLogicDelegate {
    
    func getKeywordsListFromResponse() { }
    
    func updateKeywordStatusChange(dataStatus: String?, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.updateKeywordStatusChange(dataStatus: dataStatus, index: index)
            if dataStatus == "complete" {
                _self.onBackClick?()
                _self.removeFromSuperview()
            }
            _self.setStatusAndMenu(for: dataStatus)
        }
    }
    
    func addNewKeywordInQueue() { }
    
    func updateAddKeywordSuccess(status: Int?, index: Int?) { }
    
    func getKeywordDetailsFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateData(keywordDetails: _self.keywordLogic?.keywordDetailsData)
        }
    }
    
    func editKeywordInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateData(keywordDetails: _self.keywordLogic?.sortedKeywordListArray[index])
            _self.delegate?.editKeywordInQueue(index: index)
        }
    }
    
    func updateEditKeyword(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.setStatusAndMenu(for: dataStatus)
            _self.updateData(keywordDetails: _self.keywordLogic?.sortedKeywordListArray[index])
            _self.delegate?.updateEditKeyword(index: index, dataStatus: dataStatus)
        }
    }
    
    func keywordStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.keywordStatusChangeForQueue(index: index)
        }
    }
    
    func updateDeleteKeywordSuccess(status: Int?, index: Int) {
        delegate?.updateDeleteKeywordSuccess(status: status, index: index)
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.onBackClick?()
            _self.removeFromSuperview()
        }
    }
    
    func showPoorInternet() { }
}
