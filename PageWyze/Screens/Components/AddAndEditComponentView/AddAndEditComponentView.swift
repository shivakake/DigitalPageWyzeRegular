//
//  AddAndEditComponentView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 13/01/23.
//

import Cocoa

class AddAndEditComponentView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var userInteractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var mainHeaderTitleLabel: NSTextField!
    @IBOutlet weak var nameView: NSView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var typeView: NSView!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var typeSelectView: NSView!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var descriptionView: NSView!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentAndCodeLabel: NSTextField!
    @IBOutlet weak var contentAndCodeView: NSView!
    @IBOutlet var contentAndCodeTextView: NSTextView!
    @IBOutlet weak var contentAndCodeTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var typePanelView: WenoiVisualPanelView!
    
    public var onBackClick: (() -> Void)?
    public var websiteLogic: WebsitesLogic?
    public var componentLogic: ComponentsLogic?
    public var componentModel: ComponentDetailsDataModel?
    public weak var delegate: ComponentsLogicDelegate?
    public var typeList: [WenoiVisualPanelModel] = [WenoiVisualPanelModel]()
    public var userSelectedTypeId: String?
    
    init(componentLogic: ComponentsLogic?, componentDelegate: ComponentsLogicDelegate?, componentModel: ComponentDetailsDataModel?, websiteLogic: WebsitesLogic?) {
        super.init(frame: .zero)
        self.componentLogic = componentLogic
        self.delegate = componentDelegate
        self.componentModel = componentModel
        self.websiteLogic = websiteLogic
        commonMethods()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethods()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    fileprivate func addView() {
        Bundle(for: AddAndEditComponentView.self).loadNibNamed("AddAndEditComponentView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        setupUI()
    }
    
    public func setupUI() {
        for type in componentLogic?.typesListArray ?? []{
            let newType = WenoiVisualPanelModel(language: (type.name ?? "", type.id ?? ""))
            typeList.append(newType)
        }
        assignValuesToCollection()
        stylingUI()
        configureTextViews()
        assignValuesToUI()
        typePanelView.isHidden = true
    }
    
    @objc func typeTextFieldTapped() {
        typeSelectView.isHidden = !typeSelectView.isHidden
    }
    
    func configureTextViews() {
        descriptionTextView.delegate = self
        contentAndCodeTextView.delegate = self
        
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: descriptionTextView, userInfo: [:]))
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: contentAndCodeTextView, userInfo: [:]))
        
        typeTextField.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(typeTextFieldTapped)))
    }
    
    func stylingUI() {
        mainHeaderTitleLabel.font = .styleSelectionForLargeTitle
        mainHeaderTitleLabel.textColor = StyleSheet.addHeaderTitleColor
        nameView.setBorder(color: .lightGray)
        typeView.setBorder(color: .lightGray)
        typeSelectView.setBorder(color: .lightGray)
        typeSelectView.isHidden = true
        typeTextField.isEditable = false
        descriptionView.setBorder(color: .lightGray)
        contentAndCodeView.setBorder(color: .lightGray)
        
        cancelButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        createButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        cancelButton.font = .boldSystemFont(ofSize: 12)
        createButton.font = .boldSystemFont(ofSize: 12)
        
    }
    
    fileprivate func assignValuesToCollection() {
        
        self.typePanelView.setUpCollectionView(with: self.typeList.map({ WenoiVisualPanelModel(language: ($0.strTitle ?? "", $0.strId ?? ""))}), defaultImage: NSImage(named: "type") ?? NSImage(), hideStatus: true, hideSearchBar: true)
        
        typePanelView.fetchedCountryOrLanguage = { [weak self] selectedID, selectedValue in
            guard let _self = self else { return }
            _self.userSelectedTypeId = selectedID ?? ""
            _self.typeTextField.stringValue = selectedValue ?? "none"
            _self.typeTapped()
        }
    }
    
    public func typeTapped() {
        typePanelView.isHidden = true
    }
    
    public func assignValuesToUI() {
        if componentModel != nil {
            mainHeaderTitleLabel.stringValue = "Edit Component"
            self.nameTextField.stringValue = componentModel?.name ?? ""
            self.descriptionTextView.string = componentModel?.description ?? ""
            self.contentAndCodeTextView.string = componentModel?.text ?? ""
            self.typeTextField.stringValue = componentModel?.typename ?? ""
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    @IBAction func createButtonTapped(_ sender: NSButton) {
        
        guard let name = nameTextField?.stringValue else { return }
        guard let descriptionString = descriptionTextView?.string else { return }
        guard let contentAndCodeString = contentAndCodeTextView?.string else { return }
        
        componentLogic?.delegate = delegate
        
        if componentLogic?.componentDetailsData != nil {
            guard let typeName = typeTextField?.stringValue else { return }
            componentLogic?.editComponent(websiteId: websiteLogic?.websiteDetailsModel?.id, ref: componentLogic?.componentDetailsData?.id, name: name, text: contentAndCodeString, type: self.userSelectedTypeId, description: descriptionString, typeName: typeName)
        } else {
            if name.isEmpty {
                FunctionsExtension.sharedInstance.showValidationAlert(messgae: "Enter Page Name")
            }else{
                componentLogic?.addNewComponent(websiteId: self.websiteLogic?.websiteDetailsModel?.id, name: name, text: contentAndCodeString, type: self.userSelectedTypeId, description: descriptionString)
            }
        }
        onBackClick?()
        self.removeFromSuperview()
    }
}

extension AddAndEditComponentView : NSTextViewDelegate {
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let newText = (textView.string as NSString).replacingCharacters(in: affectedCharRange, with: replacementString!)
        let numberOfChars = newText.count
        return numberOfChars <= 250
    }
    
    public func textDidChange(_ notification: Notification) {
        switch notification.object as? NSTextView{
        case descriptionTextView :
            let height = descriptionTextView.attributedString().height(containerWidth: descriptionTextView.frame.size.width)
            descriptionTextViewHeightConstraint.constant = height < 300 ? height: 300
        case contentAndCodeTextView :
            let height = contentAndCodeTextView.attributedString().height(containerWidth: descriptionTextView.frame.size.width)
            contentAndCodeTextViewHeightConstraint.constant = height < 300 ? height: 300
        default:
            break
        }
    }
}

extension AddAndEditComponentView : ComponentsLogicDelegate {
    
    func getComponentsListFromResponse() { }
    
    func getTypesListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.assignValuesToCollection()
        }
    }
    
    func addNewComponentInQueue() { }
    
    func updateAddComponentSuccess(status: Int, index: Int) { }
    
    func getComponentDetailsFromResponse() { }
    
    func editComponentInQueue(index: Int) { }
    
    func updateEditComponent(index: Int, dataStatus: String?) { }
    
    func componentStatusChangeForQueue(index: Int) { }
    
    func updateComponentStatusChange(dataStatus: String, index: Int) { }
    
    func updateDeleteComponentSuccess(status: Int, index: Int) { }
    
    func showPoorInternet() { }
}
