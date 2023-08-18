//
//  ComponentDetailsView.swift
//  WebSites
//
//  Created by Nagendar on 04/01/23.
//

import Cocoa

class ComponentDetailsView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userIntractionHandlerCustomView: UIUserInteractionHandler!
    @IBOutlet weak var contentCodeDataLabel: NSTextField!
    @IBOutlet weak var bannerLabel: NSTextField!
    @IBOutlet weak var informationLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var descriptionDataLabel: NSTextField!
    @IBOutlet weak var statusChangeButtonOutlet: NSButton!
    
    public var websiteLogic: WebsitesLogic?
    public var componentLogic: ComponentsLogic?
    public weak var delegate: ComponentsLogicDelegate?
    public var onBackClick: (() -> Void)?
    public var moreArray: [PopUpMenuItemModel] = []
    
    init(componentlogic: ComponentsLogic?, delegate: ComponentsLogicDelegate?, websiteLogic: WebsitesLogic?) {
        self.componentLogic = componentlogic
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
        getComponentDetailsFromAPI()
    }
    
    fileprivate func addView() {
        Bundle(for: ComponentDetailsView.self).loadNibNamed("ComponentDetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func textStyling(){
        titleLabel.font = .styleSelectionBoldText
        informationLabel.font = .systemFont(ofSize: 12, weight: .regular)
        bannerLabel.font = .systemFont(ofSize: 12, weight: .regular)
        contentCodeDataLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    @IBAction func backButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    func updateData(componentDetails: ComponentDetailsDataModel?) {
        contentCodeDataLabel.stringValue = componentDetails?.text ?? ""
        bannerLabel.stringValue = componentDetails?.typename ?? ""
        titleLabel.stringValue = componentDetails?.name ?? ""
        descriptionDataLabel.stringValue = componentDetails?.description ?? ""
        setStatusAndMenu(for: componentDetails?.datastatus ?? "live")
    }
    
    public func getComponentDetailsFromAPI() {
        componentLogic?.delegate = self
        componentLogic?.getComponentDetails(websiteId: self.websiteLogic?.websiteDetailsModel?.id, componentId: self.componentLogic?.componentDetailsData?.id)
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
                _self.componentLogic?.approveComponent(websiteId: _self.websiteLogic?.websiteDetailsModel?.id, componentId: _self.componentLogic?.componentDetailsData?.id)
            } else if selectedItem.strID == "draft"{
                _self.componentLogic?.draftComponent(websiteId: _self.websiteLogic?.websiteDetailsModel?.id, componentId: _self.componentLogic?.componentDetailsData?.id)
            } else if selectedItem.strID == "complete" {
                _self.componentLogic?.completeComponent(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "", componentId: _self.componentLogic?.componentDetailsData?.id ?? "")
            }else{
                _self.componentLogic?.delegate = self
                _self.componentLogic?.deleteComponent(websiteId: _self.websiteLogic?.websiteDetailsModel?.id ?? "", componentId: _self.componentLogic?.componentDetailsData?.id ?? "")
            }
        }
        
        window?.contentViewController?.present(controller, asPopoverRelativeTo: .init(x: 0, y: 0, width: 120, height: height), of: statusChangeButtonOutlet, preferredEdge: .maxY, behavior: .transient)
    }
    
    @objc func onEditOperationTapped() {
        let addEditView = AddAndEditComponentView(componentLogic: componentLogic, componentDelegate: self, componentModel: self.componentLogic?.componentDetailsData, websiteLogic: websiteLogic)
        self.userIntractionHandlerCustomView.isUserInteractionEnabled = false
        addEditView.onBackClick = { [weak self] in
            guard let _self = self else { return }
            _self.userIntractionHandlerCustomView.isUserInteractionEnabled = true
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

extension ComponentDetailsView : ComponentsLogicDelegate {
    
    func getComponentsListFromResponse() { }
    
    func getTypesListFromResponse() { }
    
    func addNewComponentInQueue() { }
    
    func updateAddComponentSuccess(status: Int, index: Int) { }
    
    func getComponentDetailsFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateData(componentDetails: _self.componentLogic?.componentDetailsData)
        }
    }
    
    func editComponentInQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.updateData(componentDetails: _self.componentLogic?.sortedComponentListArray[index])
            _self.delegate?.editComponentInQueue(index: index)
        }
    }
    
    func updateEditComponent(index: Int, dataStatus: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.setStatusAndMenu(for: dataStatus)
            _self.updateData(componentDetails: _self.componentLogic?.sortedComponentListArray[index])
            _self.delegate?.updateEditComponent(index: index, dataStatus: dataStatus)
        }
    }
    
    func componentStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.componentStatusChangeForQueue(index: index)
        }
    }
    
    func updateComponentStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.delegate?.updateComponentStatusChange(dataStatus: dataStatus, index: index)
            if dataStatus == "complete" {
                _self.onBackClick?()
                _self.removeFromSuperview()
            }
            _self.setStatusAndMenu(for: dataStatus)
        }
    }
    
    func updateDeleteComponentSuccess(status: Int, index: Int) {
        delegate?.updateDeleteComponentSuccess(status: status, index: index)
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.onBackClick?()
            _self.removeFromSuperview()
        }
    }
    
    func showPoorInternet() { }
}
