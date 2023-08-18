//
//  AddAndEditWebsiteView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 13/01/23.
//

import Cocoa

class AddAndEditWebsiteView: NSView {
    
    @IBOutlet weak var userInteractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var mainHeaderTitleLabel: NSTextField!
    @IBOutlet weak var nameView: NSView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var pagewyzeButton: NSButton!
    @IBOutlet weak var ownDomainButton: NSButton!
    @IBOutlet weak var domainView: NSView!
    @IBOutlet weak var domainTextField: NSTextField!
    @IBOutlet weak var pagewyzeLabel: NSTextField!
    @IBOutlet weak var typeView: NSView!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var categoryView: NSView!
    @IBOutlet weak var categoryTextField: NSTextField!
    @IBOutlet weak var languagesView: NSView!
    @IBOutlet weak var languageTextField: NSTextField!
    @IBOutlet weak var securityButton: NSButton!
    @IBOutlet weak var wwwButton: NSButton!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var descriptionView: NSView!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var verifyDomainButton: NSButton!
    @IBOutlet weak var verifyDomainLabel: NSTextField!
    @IBOutlet weak var verifyDomainWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var typePanelView: WenoiVisualPanelView!
    @IBOutlet weak var categoryPanelView: WenoiVisualPanelView!
    @IBOutlet weak var languagePanelView: WenoiVisualPanelView!
    
    public var onBackClick: (() -> Void)?
    public var websiteLogic: WebsitesLogic?
    public var websiteModel: WebsiteDetailsDataModel?
    public weak var delegate: WebsitesLogicDelegate?
    public var userSelectedDomain = "pagewyze.com"
    public var userSelectedTypeId: String?
    public var userSelectedCategoryId: String?
    public var userSelectedLanguageId: String?
    public var isSecureSelecte = "no"
    public var isWWWSelecte = "no"
    public var typeList: [WenoiVisualPanelModel] = [WenoiVisualPanelModel]()
    public var categoryList: [WenoiVisualPanelModel] = [WenoiVisualPanelModel]()
    public var languagesList: [WenoiVisualPanelModel] = [WenoiVisualPanelModel]()
    
    
    init(websiteLogic: WebsitesLogic?, websiteModel: WebsiteDetailsDataModel? , websiteDelegate: WebsitesLogicDelegate?) {
        super.init(frame: .zero)
        self.websiteLogic = websiteLogic
        self.websiteModel = websiteModel
        self.delegate = websiteDelegate
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
        Bundle(for: AddAndEditWebsiteView.self).loadNibNamed("AddAndEditWebsiteView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        setupUI()
    }
    
    public func setupUI() {
        stylingUI()
        handlingHidingUI()
        setActionToTextFields()
        assignDataToUI()
        
        mainHeaderTitleLabel.font = .styleSelectionForLargeTitle
        mainHeaderTitleLabel.textColor = StyleSheet.addHeaderTitleColor
        
        descriptionTextView.delegate = self
        
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: nil, userInfo: [:]))
        getAllListsFromAPI()
    }
    
    public func getAllListsFromAPI() {
        
        websiteLogic?.delegate = self
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.websiteLogic?.getTypesList()
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.websiteLogic?.getCategoriesList()
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.websiteLogic?.getLanguagesList()
        }
    }
    
    fileprivate func assignValuesToCollection(incomingTextField: NSTextField) {
        if incomingTextField == languageTextField {
            self.languagePanelView.setUpCollectionView(with: self.languagesList.map({ WenoiVisualPanelModel(language: ($0.strTitle ?? "", $0.strId ?? ""))}), defaultImage: NSImage(named: "language") ?? NSImage(), hideStatus: true, hideSearchBar: true)
            languagePanelView.fetchedCountryOrLanguage = { [weak self] selectedID, selectedValue in
                guard let _self = self else { return }
                _self.userSelectedLanguageId = selectedID ?? ""
                _self.languageTextField.stringValue = selectedValue ?? "none"
                _self.languageTapped()
            }
        } else if incomingTextField == categoryTextField {
            self.categoryPanelView.setUpCollectionView(with: self.categoryList.map({ WenoiVisualPanelModel(language: ($0.strTitle ?? "", $0.strId ?? ""))}), defaultImage: NSImage(named: "category") ?? NSImage(), hideStatus: true, hideSearchBar: true)
            categoryPanelView.fetchedCountryOrLanguage = { [weak self] selectedID, selectedValue in
                guard let _self = self else { return }
                _self.userSelectedCategoryId = selectedID ?? ""
                _self.categoryTextField.stringValue = selectedValue ?? "none"
                _self.categoryTapped()
            }
        }else{
            self.typePanelView.setUpCollectionView(with: self.typeList.map({ WenoiVisualPanelModel(language: ($0.strTitle ?? "", $0.strId ?? ""))}), defaultImage: NSImage(named: "type") ?? NSImage(), hideStatus: true, hideSearchBar: true)
            typePanelView.fetchedCountryOrLanguage = { [weak self] selectedID, selectedValue in
                guard let _self = self else { return }
                _self.userSelectedTypeId = selectedID ?? ""
                _self.typeTextField.stringValue = selectedValue ?? "none"
                _self.typeTapped()
            }
        }
    }
    
    public func typeTapped() {
        typePanelView.isHidden = true
    }
    
    public func categoryTapped() {
        categoryPanelView.isHidden = true
    }
    
    public func languageTapped() {
        languagePanelView.isHidden = true
    }
    
    @IBAction func pagewyzeButtonTapped(_ sender: NSButton) {
        self.userSelectedDomain = "pagewyze.com"
        pagewyzeButton.state = .on
        ownDomainButton.state = .off
        securityButton.state = .off
        wwwButton.state = .off
        pagewyzeLabel.isHidden = false
        wwwButton.isEnabled = false
    }
    
    @IBAction func ownDomainButtonTapped(_ sender: NSButton) {
        self.userSelectedDomain = "own"
        ownDomainButton.state = .on
        pagewyzeButton.state = .off
        securityButton.state = .off
        pagewyzeLabel.isHidden = true
        wwwButton.isEnabled = true
    }
    
    @IBAction func secureButtonTapped(_ sender: NSButton) {
        if sender.state == .on{
            self.isSecureSelecte = "yes"
        }else{
            self.isSecureSelecte = "no"
        }
    }
    
    @IBAction func wwwButtonTapped(_ sender: NSButton) {
        if sender.state == .on{
            self.isWWWSelecte = "yes"
        }else{
            self.isWWWSelecte = "no"
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        goBack()
    }
    
    func goBack() {
        onBackClick?()
        self.removeFromSuperview()
    }
    
    @IBAction func createButtonTapped(_ sender: NSButton) {
        
        guard let name = nameTextField?.stringValue else { return }
        guard let descriptionString = descriptionTextView?.string else { return }
        guard let urlString = domainTextField?.stringValue else { return }
        
        websiteLogic?.delegate = delegate
        
        if websiteModel != nil {
            websiteModel?.name = name
            websiteModel?.description = descriptionString
            websiteModel?.url = urlString
            websiteModel?.datastatus = "queue"
            websiteModel?.type = userSelectedTypeId
            websiteModel?.category = userSelectedCategoryId
            websiteModel?.language = userSelectedLanguageId
            websiteModel?.domain = userSelectedDomain
            websiteModel?.secure = isSecureSelecte
            websiteModel?.www = isWWWSelecte
            
            websiteLogic?.editWebsite(model: websiteModel)
            
        } else {
            
            if name.isEmpty {
                FunctionsExtension.sharedInstance.showValidationAlert(messgae: "Enter Website Name")
            }else{                
                websiteLogic?.addNewWebsite(name: name, url: urlString, type: userSelectedTypeId, category: userSelectedCategoryId, language: userSelectedLanguageId, domain: userSelectedDomain, secure: isSecureSelecte, www: isWWWSelecte, description: descriptionString)
            }
        }
        goBack()
    }
    
    @IBAction func verifyDomainButtonTapped(_ sender: NSButton) {
        websiteLogic?.delegate = self
        websiteLogic?.verifyNewWebsiteURL(typeId: userSelectedDomain, urlString: domainTextField.stringValue)
    }
    
    public func assignDataToUI() {
        if websiteModel != nil {
            mainHeaderTitleLabel.stringValue = "Edit Website"
            nameTextField.stringValue = websiteModel?.name ?? ""
            domainTextField.stringValue = websiteModel?.url ?? ""
            typeTextField.stringValue = websiteModel?.typename ?? ""
            categoryTextField.stringValue = websiteModel?.categoryname ?? ""
            languageTextField.stringValue = websiteModel?.languagename ?? ""
            descriptionTextView.string = websiteModel?.description ?? ""
            
            isSecureSelecte = websiteModel?.secure ?? ""
            userSelectedDomain = websiteModel?.domain ?? ""
            isWWWSelecte = websiteModel?.www ?? ""
            userSelectedTypeId = websiteModel?.type
            userSelectedLanguageId = websiteModel?.language
            userSelectedCategoryId = websiteModel?.category
            
            if websiteModel?.secure == "Yes" {
                securityButton.state = .on
            } else {
                securityButton.state = .off
            }
            
            if websiteModel?.domainname == "pagewyze.com" {
                pagewyzeLabel.isHidden = false
                pagewyzeButton.state = .on
                ownDomainButton.state = .off
            } else {
                pagewyzeLabel.isHidden = true
                pagewyzeButton.state = .off
                ownDomainButton.state = .on
            }
        }
    }
    
    public func stylingUI() {
        nameView.setBorder(color: .lightGray)
        domainView.setBorder(color: .lightGray)
        typeView.setBorder(color: .lightGray)
        categoryView.setBorder(color: .lightGray)
        languagesView.setBorder(color: .lightGray)
        descriptionView.setBorder(color: .lightGray)
        typePanelView.setBorder(color: .lightGray)
        categoryPanelView.setBorder(color: .lightGray)
        languagePanelView.setBorder(color: .lightGray)
        cancelButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        createButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        verifyDomainButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
    }
    
    public  func handlingHidingUI() {
        typePanelView.isHidden = true
        categoryPanelView.isHidden = true
        languagePanelView.isHidden = true
        verifyDomainLabel.isHidden = true
        
        wwwButton.isEnabled = false
        wwwButton.state = .off
        securityButton.state = .off
    }
    
    public func setActionToTextFields() {
        typeTextField.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(typeTextFieldTapped)))
        
        categoryTextField.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(categoryTextFieldTapped)))
        
        languageTextField.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(languageTextFieldTapped)))
    }
    
    @objc func typeTextFieldTapped() {
        typePanelView.isHidden = !typePanelView.isHidden
        categoryPanelView.isHidden = true
        languagePanelView.isHidden = true
    }
    
    @objc func categoryTextFieldTapped() {
        categoryPanelView.isHidden = !categoryPanelView.isHidden
        typePanelView.isHidden = true
        languagePanelView.isHidden = true
    }
    
    @objc func languageTextFieldTapped() {
        languagePanelView.isHidden = !languagePanelView.isHidden
        typePanelView.isHidden = true
        categoryPanelView.isHidden = true
    }
    
    public func showAlert(title: String?, description: String) {
        AlertSheetModel(title: title, descInfo: description, image: nil).handleActions { [weak self] (alert) in
            guard let _self = self else { return }
            alert.addButton(withTitle: "OK" )
            alert.buttons[0].target = self
            alert.buttons[0].action = #selector(_self.okTapped)
            alert.runModal()
        }
    }
    
    @objc private func okTapped() {
        NSApplication.shared.abortModal()
    }
}

extension AddAndEditWebsiteView : NSTextViewDelegate {
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let newText = (textView.string as NSString).replacingCharacters(in: affectedCharRange, with: replacementString!)
        let numberOfChars = newText.count
        return numberOfChars <= 250
    }
    
    public func textDidChange(_ notification: Notification) {
        descriptionLabel.isHidden = !descriptionTextView.string.isEmpty
        
        var height = descriptionTextView.attributedString().height(containerWidth: descriptionTextView.frame.size.width)
        if height < 300 {
            if height <= 100 {
                height = 100
            }
        }else{
            height = 300
        }
        descriptionTextViewHeightConstraint.constant = height
    }
}

extension AddAndEditWebsiteView: WebsitesLogicDelegate{
    
    func getWebsitesListFromResponse() { }
    
    func getTypesListFromResponse() {
        for type in websiteLogic?.typesListArray ?? []{
            let newType = WenoiVisualPanelModel(language: (type.name ?? "", type.id ?? ""))
            typeList.append(newType)
        }
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.assignValuesToCollection(incomingTextField: _self.typeTextField)
        }
    }
    
    func getLanguagesListFromResponse() {
        for language in websiteLogic?.languageListArray ?? []{
            let newLanguage = WenoiVisualPanelModel(language: (language.name ?? "", language.id ?? ""))
            languagesList.append(newLanguage)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.assignValuesToCollection(incomingTextField: _self.languageTextField)
        }
    }
    
    func getCategoriesListFromResponse() {
        for category in websiteLogic?.categoriesListArray ?? []{
            let newCategory = WenoiVisualPanelModel(language: (category.name ?? "", category.id ?? ""))
            categoryList.append(newCategory)
        }
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.assignValuesToCollection(incomingTextField: _self.categoryTextField)
        }
    }
    
    func getVerifyDomainResponse(status: Int?) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            if status == 1 {
                _self.verifyDomainLabel.isHidden = false
                _self.verifyDomainLabel.textColor = .systemGreen
                _self.verifyDomainLabel.stringValue = "Congratulations! Your domain name is available!"
            } else {
                _self.verifyDomainLabel.isHidden = false
                _self.verifyDomainLabel.textColor = .red
                _self.verifyDomainLabel.stringValue = "Oops! This domain name is not available. Try another!"
            }
        }
    }
    
    func addNewWebsiteInQueue() { }
    
    func updateAddWebsiteSuccess(ststus: Int, index: Int) { }
    
    func getWebsiteDetailsFromResponse(detailsModel: WebsiteDetailsDataModel?, pagesList: [PageDataModel]?) { }
    
    func getGeneratedFileResponse(status: Int?) { }
    
    func getStatisticListResponse(statisticsDataModel: [StatisticsDataModel]) { }
    
    func updateEditPageDataSuccess(datastatus: String) { }
    
    func editWebsiteInQueue(index: Int) { }
    
    func updateEditWebsiteSuccess(index: Int, copyRight: String, dataStatus: String) { }
    
    func getFilesListFromResponse() { }
    
    func getGroupsListFromResponse() { }
    
    func updateWebsiteStatusChange(dataStatus: String, index: Int) { }
    
    func websiteStatusChangeForQueue(index: Int) { }
    
    func updateDeleteWebsiteSuccess(status: Int, index: Int) { }
    
    func showPoorInternet() { }
}


