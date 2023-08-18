//
//  AddAndEditPageView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 13/01/23.
//

import Cocoa

class AddAndEditPageView: NSView {
    
    @IBOutlet weak var userInteractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var mainHeaderTitleLabel: NSTextField!
    @IBOutlet weak var nameTitleLabel: NSTextField!
    @IBOutlet weak var nameView: NSView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var urlTitleLabel: NSTextField!
    @IBOutlet weak var urlView: NSView!
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var urlMatchLabel: NSTextField!
    @IBOutlet weak var typeTitleLabel: NSTextField!
    @IBOutlet weak var typeView: NSView!
    @IBOutlet weak var typeTextField: NSTextField!
    @IBOutlet weak var descriptionTitleLabel: NSTextField!
    @IBOutlet weak var descriptionView: NSView!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var metaTitleLabel: NSTextField!
    @IBOutlet weak var metaView: NSView!
    @IBOutlet weak var metaTextField: NSTextField!
    @IBOutlet weak var metaDescriptionTitleLabel: NSTextField!
    @IBOutlet weak var metaDescriptionView: NSView!
    @IBOutlet var metaDescriptionTextView: NSTextView!
    @IBOutlet weak var metaDescriptionTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var canonicalTitleLabel: NSTextField!
    @IBOutlet weak var canonicalView: NSView!
    @IBOutlet weak var canonicalTextField: NSTextField!
    @IBOutlet weak var headTitleLabel: NSTextField!
    @IBOutlet weak var headView: NSView!
    @IBOutlet weak var headTextField: NSTextField!
    @IBOutlet weak var contentAndCodeTtitleLabel: NSTextField!
    @IBOutlet weak var contentAndCodeView: NSView!
    @IBOutlet var contentAndCodeTextView: NSTextView!
    @IBOutlet weak var contentAndCodeTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var verifyPageURLButton: NSButton!
    @IBOutlet weak var websiteURLLabel: NSTextField!
    @IBOutlet weak var nameStackView: NSStackView!
    @IBOutlet weak var urlStackView: NSStackView!
    @IBOutlet weak var typeStackView: NSStackView!
    @IBOutlet weak var descriptionStackView: NSStackView!
    @IBOutlet weak var metaTitleStackView: NSStackView!
    @IBOutlet weak var metaDescriptionStackView: NSStackView!
    @IBOutlet weak var canonicalStackView: NSStackView!
    @IBOutlet weak var headStackView: NSStackView!
    @IBOutlet weak var contentAndCodeStackView: NSStackView!
    @IBOutlet weak var typePanelView: WenoiVisualPanelView!
    
    public var backToListCallBack: (() -> Void)?
    public var websiteLogic: WebsitesLogic?
    public var pageLogic: PagesLogic?
    public weak var delegate: PagesLogicDelegate?
    public var userSelectedDomain = "pagewyze.com"
    public var userSelectedTypeId: String?
    public var userSelectedCategoryId: String?
    public var userSelectedLanguageId: String?
    public var isSecureSelecte = "no"
    public var isWWWSelecte = "no"
    public var typeList: [WenoiVisualPanelModel] = [WenoiVisualPanelModel]()
    public var editFrom: String?
    
    init(pageLogic: PagesLogic?, pageDelegate: PagesLogicDelegate?, websiteLogic: WebsitesLogic?, editComingFrom: String?) {
        super.init(frame: .zero)
        self.pageLogic = pageLogic
        self.delegate = pageDelegate
        self.editFrom = editComingFrom
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
        Bundle(for: AddAndEditPageView.self).loadNibNamed("AddAndEditPageView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func commonMethods() {
        addView()
        setupUI()
    }
    
    public func setupUI() {
        pageLogic?.delegate = self
        pageLogic?.getPagesTypesList()
        stylingUI()
        configureTextView()
        assignValuesToUI(pageDetails: pageLogic?.pageDetailsData ?? PageDetailsDataModel(canonical: "", components: "", created: "", data: nil, datastatus: "", description: "", head: "", id: "", key: "", messages: "", metadescription: "", metatitle: "", name: "", status: "", text: "", type: "", typename: "", updated: "", url: ""))
        typePanelView.isHidden = true
        typeTextField.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(typeTextFieldTapped)))
        handlingHideView(comingFrom: editFrom ?? "")
    }
    
    @objc func typeTextFieldTapped() {
        typePanelView.isHidden = !typePanelView.isHidden
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
    
    func handlingHideView(comingFrom: String) {
        if comingFrom == "Information" {
            mainHeaderTitleLabel.stringValue = "Edit Page Infromation"
            metaTitleStackView.isHidden = true
            metaDescriptionStackView.isHidden = true
            canonicalStackView.isHidden = true
            headStackView.isHidden = true
            contentAndCodeStackView.isHidden = true
        } else if comingFrom == "Seo" {
            mainHeaderTitleLabel.stringValue = "Edit SEO Infromation"
            nameStackView.isHidden = true
            urlStackView.isHidden = true
            typeStackView.isHidden = true
            descriptionStackView.isHidden = true
            headStackView.isHidden = true
            contentAndCodeStackView.isHidden = true
            
        } else if comingFrom == "Content" {
            mainHeaderTitleLabel.stringValue = "Edit Content and Code"
            nameStackView.isHidden = true
            urlStackView.isHidden = true
            typeStackView.isHidden = true
            descriptionStackView.isHidden = true
            headStackView.isHidden = true
            metaTitleStackView.isHidden = true
            metaDescriptionStackView.isHidden = true
            canonicalStackView.isHidden = true
            
        } else if comingFrom == "Head" {
            mainHeaderTitleLabel.stringValue = "Edit Head"
            nameStackView.isHidden = true
            urlStackView.isHidden = true
            typeStackView.isHidden = true
            descriptionStackView.isHidden = true
            contentAndCodeStackView.isHidden = true
            canonicalStackView.isHidden = true
            metaTitleStackView.isHidden = true
            metaDescriptionStackView.isHidden = true
        } else {
        }
    }
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        backToListCallBack?()
        self.removeFromSuperview()
    }
    
    @IBAction func createButtonTapped(_ sender: NSButton) {
        
        guard let name = nameTextField?.stringValue else { return }
        guard let urlString = urlTextField?.stringValue else { return }
        guard let descriptionString = descriptionTextView?.string else { return }
        guard let metaString = metaTextField?.stringValue else { return }
        guard let metaDescriptionString = metaDescriptionTextView?.string else { return }
        guard let canonicalString = canonicalTextField?.stringValue else { return }
        guard let headString = headTextField?.stringValue else { return }
        guard let contentAndCodeString = contentAndCodeTextView?.string else { return }
        
        pageLogic?.delegate = delegate
        if pageLogic?.pageDetailsData != nil {
            guard let typeString = pageLogic?.pageDetailsData?.type else { return }
            if editFrom == "Information" {
                pageLogic?.editPageInfromation(websiteId: self.websiteLogic?.websiteDetailsModel?.id, ref: self.pageLogic?.pageDetailsData?.id, name: name, type: typeString, url: urlString, description: descriptionString)
            } else if editFrom == "Seo" {
                pageLogic?.editSeoInfromation(websiteId: self.websiteLogic?.websiteDetailsModel?.id, ref: self.pageLogic?.pageDetailsData?.id, metaTitle: metaString, metaDescription: metaDescriptionString, canonical: canonicalString)
            } else if editFrom == "Content" {
                //Content and code
                pageLogic?.editContentAndCode(websiteId: self.websiteLogic?.websiteDetailsModel?.id, ref: self.pageLogic?.pageDetailsData?.id, contentAndCode: contentAndCodeString)
            } else {
                //Head
                pageLogic?.editPageHead(websiteId: self.websiteLogic?.websiteDetailsModel?.id, ref: self.pageLogic?.pageDetailsData?.id, head: headString)
            }
            
        } else {
            if name.isEmpty {
                FunctionsExtension.sharedInstance.showValidationAlert(messgae: "Enter Page Name")
            }else{
                pageLogic?.addNewPage(websiteId: self.websiteLogic?.websiteDetailsModel?.id, name: name, text: contentAndCodeString, type: self.userSelectedTypeId, url: urlString, metatitle: metaString, metadescription: metaDescriptionString, description: descriptionString, canonical: canonicalString, head: headString)
            }
        }
        backToListCallBack?()
        self.removeFromSuperview()
    }
    
    @IBAction func verifyPageURLTapped(_ sender: NSButton) {
        pageLogic?.delegate = self
        guard let urlString = urlTextField?.stringValue else { return }
        pageLogic?.verifyNewPageURL(websiteId: websiteLogic?.websiteDetailsModel?.id, urlString: urlString)
    }
    
    public func stylingUI() {
        
        mainHeaderTitleLabel.font = .styleSelectionForLargeTitle
        mainHeaderTitleLabel.textColor = StyleSheet.addHeaderTitleColor
        nameTitleLabel.font = .styleSelectionForSubtitle
        nameView.setBorder(color: .lightGray)
        urlTitleLabel.font = .styleSelectionForSubtitle
        urlView.setBorder(color: .lightGray)
        urlMatchLabel.font = .styleSelectionMeta
        urlMatchLabel.isHidden = true
        websiteURLLabel.stringValue = self.websiteLogic?.websiteDetailsModel?.url ?? ""
        typeTitleLabel.font = .styleSelectionForSubtitle
        typeView.setBorder(color: .lightGray)
        typePanelView.setBorder(color: .lightGray)
        descriptionTitleLabel.font = .styleSelectionForSubtitle
        descriptionView.setBorder(color: .lightGray)
        metaTitleLabel.font = .styleSelectionForSubtitle
        metaView.setBorder(color: .lightGray)
        metaDescriptionTitleLabel.font = .styleSelectionForSubtitle
        metaDescriptionView.setBorder(color: .lightGray)
        canonicalTitleLabel.font = .styleSelectionForSubtitle
        canonicalView.setBorder(color: .lightGray)
        headTitleLabel.font = .styleSelectionForSubtitle
        headView.setBorder(color: .lightGray)
        contentAndCodeTtitleLabel.font = .styleSelectionForSubtitle
        contentAndCodeView.setBorder(color: .lightGray)
        cancelButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        createButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        verifyPageURLButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
    }
    
    public func configureTextView() {
        
        descriptionTextView.delegate = self
        metaDescriptionTextView.delegate = self
        contentAndCodeTextView.delegate = self
        
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: descriptionTextView, userInfo: [:]))
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: metaDescriptionTextView, userInfo: [:]))
        textDidChange(Notification(name: Notification.Name(NSText.didChangeNotification.rawValue), object: contentAndCodeTextView, userInfo: [:]))
    }
    
    public func assignValuesToUI(pageDetails: PageDetailsDataModel) {
        if pageLogic?.pageDetailsData == nil {
            //Add New Page
        } else {
            if editFrom == "Information" {
                self.nameTextField.stringValue = pageDetails.name ?? ""
                self.urlTextField.stringValue = pageDetails.url ?? ""
                self.typeTextField.stringValue = pageDetails.typename ?? ""
                self.descriptionTextView.string = pageDetails.description ?? ""
            } else if editFrom == "Seo" {
                self.metaTextField.stringValue = pageDetails.metatitle ?? ""
                self.metaDescriptionTextView.string = pageDetails.metadescription ?? ""
                self.canonicalTextField.stringValue = pageDetails.canonical ?? ""
            } else if editFrom == "Content" {
                self.contentAndCodeTextView.string = pageDetails.text?.withoutHtml ?? ""
                self.contentAndCodeTextViewHeight.constant = 100
            } else {
                self.headTextField.stringValue = pageDetails.head ?? ""
            }
        }
    }
}

extension AddAndEditPageView : PagesLogicDelegate {
    
    func getPagesListFromResponse() { }
    
    func getTypesListFromResponse() {
        for type in pageLogic?.typesListArray ?? []{
            let newType = WenoiVisualPanelModel(language: (type.name ?? "", type.id ?? ""))
            typeList.append(newType)
        }
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.assignValuesToCollection()
        }
    }
    
    func verifyPageURLSuccess(status: Int?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            if status == 1 {
                _self.urlMatchLabel.isHidden = false
                _self.urlMatchLabel.textColor = .systemGreen
                _self.urlMatchLabel.stringValue = "Congratulations! Your page url is available!"
            } else {
                _self.urlMatchLabel.isHidden = false
                _self.urlMatchLabel.textColor = .red
                _self.urlMatchLabel.stringValue = "Oops! This page url is not available. Try another!"
            }
        }
    }
    
    func addNewPageInQueue() { }
    
    func updateAddPageSuccess(ststus: Int, index: Int) { }
    
    func getPageDetailsFromResponse() { }
    
    func editPageInformationInQueue(index: Int) { }
    
    func updateEditPageInformation(index: Int, dataStatus: String?) { }
    
    func pageStatusChangeForQueue(index: Int) { }
    
    func updatePageStatusChange(dataStatus: String, index: Int) { }
    
    func updateDeletePageSuccess(status: Int, index: Int) { }
    
    func getPageComponentsListFromResponse() { }
    
    func showPoorInternet() { }
}

extension AddAndEditPageView : NSTextViewDelegate {
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        let newText = (textView.string as NSString).replacingCharacters(in: affectedCharRange, with: replacementString!)
        let numberOfChars = newText.count
        return numberOfChars <= 250
    }
    
    public func textDidChange(_ notification: Notification) {
        switch notification.object as? NSTextView{
        case descriptionTextView :
            let height = descriptionTextView.attributedString().height(containerWidth: descriptionTextView.frame.size.width)
            descriptionTextViewHeight.constant = height < 300 ? height: 300
        case metaDescriptionTextView :
            let height = metaDescriptionTextView.attributedString().height(containerWidth: metaDescriptionTextView.frame.size.width)
            metaDescriptionTextViewHeight.constant = height < 300 ? height: 300
        case contentAndCodeTextView :
            let height = contentAndCodeTextView.attributedString().height(containerWidth: descriptionTextView.frame.size.width)
            contentAndCodeTextViewHeight.constant = height < 300 ? height: 300
        default:
            break
        }
    }
}
