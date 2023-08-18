//
//  EditBrandView.swift
//  EditBrandView
//
//  Created by Nagendar on 19/01/23.
//

import Cocoa

class EditBrandView: NSView {
    
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var selectLogoView: NSView!
    @IBOutlet weak var selectFavIconView: NSView!
    @IBOutlet weak var copyRightNameTextField: NSTextField!
    @IBOutlet weak var editLogoCollectionView: NSCollectionView!
    @IBOutlet weak var editFaviconCollectionView: NSCollectionView!
    @IBOutlet weak var selectedLogoLabel: NSTextField!
    @IBOutlet weak var selectedFaviconLabel: NSTextField!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var submitButton: NSButton!
    
    public var websiteLogic: WebsitesLogic?
    public weak var delegate: WebsitesLogicDelegate?
    public var selectedFaviconString = ""
    public var selectedLogoString = ""
    
    init(websiteLogic: WebsitesLogic?, websiteDelegate: WebsitesLogicDelegate?) {
        self.websiteLogic = websiteLogic
        self.delegate = websiteDelegate
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
        Bundle(for: EditBrandView.self).loadNibNamed("EditBrandView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethod() {
        addView()
        setupUI()
        getFilesFromAPI()
        registerColletionView()
    }
    
    public func setupUI() {
        selectFavIconView.isHidden = true
        selectLogoView.isHidden = true
        copyRightNameTextField.stringValue = websiteLogic?.websiteDetailsModel?.copyright ?? ""
        cancelButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        submitButton.setStyle(with: StyleSheet.cancelButtonColor, tintColor: .white, needCircularBorder: false)
        selectedLogoLabel.stringValue = websiteLogic?.websiteDetailsModel?.logoname ?? ""
        selectedFaviconLabel.stringValue = websiteLogic?.websiteDetailsModel?.faviconname ?? ""
        selectedLogoString = websiteLogic?.websiteDetailsModel?.logo ?? ""//faviconImageString
        selectedFaviconString = websiteLogic?.websiteDetailsModel?.favicon ?? ""
    }
    
    public func getFilesFromAPI() {
        websiteLogic?.delegate = self
        websiteLogic?.getGroupsList()
        websiteLogic?.getFilesList(websiteId: websiteLogic?.websiteDetailsModel?.id ?? "")
    }
    
    public func submitBrandInformationAPI() {
        websiteLogic?.delegate = self
        let copyRight = copyRightNameTextField.stringValue
        websiteLogic?.submitBrandInformationData(websiteId: websiteLogic?.websiteDetailsModel?.id ?? "", favicon: selectedFaviconString, logo: selectedLogoString, copyright: copyRight)
    }
    
    public func registerColletionView() {
        editLogoCollectionView.dataSource = self
        editLogoCollectionView.delegate = self
        editFaviconCollectionView.dataSource = self
        editFaviconCollectionView.delegate = self
    }
    
    @IBAction func selectFaviconButtonTapped(_ sender: Any) {
        selectFavIconView.isHidden = !selectFavIconView.isHidden
        selectLogoView.isHidden = true
    }
    
    @IBAction func selectLogoButtonTapped(_ sender: Any) {
        selectLogoView.isHidden = !selectLogoView.isHidden
        selectFavIconView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        submitBrandInformationAPI()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        removeFromSuperview()
    }
}

extension EditBrandView : NSCollectionViewDataSource{
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return websiteLogic?.filesListArray.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        if collectionView == editLogoCollectionView{
            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SelectFaviconAndLogoGridItem"), for: indexPath)
            guard let cell = item as? SelectFaviconAndLogoGridItem else { return item }
            cell.websiteImageUrl = self.websiteLogic?.websiteDetailsModel?.url ?? ""//self.websiteImageUrl
            cell.directoriesString = self.websiteLogic?.imageDirectoryString ?? "" //self.directoriesArray.first ?? ""
            cell.configureCell(nameString: websiteLogic?.filesListArray[indexPath.item].name, imageString: websiteLogic?.filesListArray[indexPath.item].filename)
            return cell
        }else{
            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SelectFaviconAndLogoGridItem"), for: indexPath)
            guard let cell = item as? SelectFaviconAndLogoGridItem else { return item }
            cell.websiteImageUrl = self.websiteLogic?.websiteDetailsModel?.url ?? "" //self.websiteImageUrl
            cell.directoriesString = self.websiteLogic?.imageDirectoryString ?? ""
            cell.configureCell(nameString: websiteLogic?.filesListArray[indexPath.item].name, imageString: websiteLogic?.filesListArray[indexPath.item].filename)
            return cell
        }
    }
}

extension EditBrandView: NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        if collectionView == editLogoCollectionView{
            selectedLogoLabel.stringValue = websiteLogic?.filesListArray[indexPath].name ?? ""
            selectedLogoString = websiteLogic?.filesListArray[indexPath].id ?? "" //websiteLogic?.websiteDetailsData?.logo ?? ""
        }else{
            selectedFaviconLabel.stringValue = websiteLogic?.filesListArray[indexPath].name ?? ""
            selectedFaviconString = websiteLogic?.filesListArray[indexPath].id ?? ""//websiteLogic?.websiteDetailsData?.favicon ?? ""
        }
    }
}

extension EditBrandView : WebsitesLogicDelegate {
    
    func getWebsitesListFromResponse() { }
    
    func getTypesListFromResponse() { }
    
    func getLanguagesListFromResponse() { }
    
    func getCategoriesListFromResponse() { }
    
    func getVerifyDomainResponse(status: Int?) { }
    
    func addNewWebsiteInQueue() { }
    
    func updateAddWebsiteSuccess(ststus: Int, index: Int) { }
    
    func getWebsiteDetailsFromResponse(detailsModel: WebsiteDetailsDataModel?, pagesList: [PageDataModel]?) { }
    
    func getGeneratedFileResponse(status: Int?) { }
    
    func getStatisticListResponse(statisticsDataModel: [StatisticsDataModel]) { }
    
    func updateEditPageDataSuccess(datastatus: String) { }
    
    func editWebsiteInQueue(index: Int) { }
    
    func updateEditWebsiteSuccess(index: Int, copyRight: String, dataStatus: String) {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.removeFromSuperview()
            _self.delegate?.updateEditWebsiteSuccess(index: index, copyRight: copyRight , dataStatus: dataStatus)
        }
    }
    
    func getFilesListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.editFaviconCollectionView.reloadData()
            _self.editLogoCollectionView.reloadData()
        }
    }
    
    func getGroupsListFromResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.editFaviconCollectionView.reloadData()
            _self.editLogoCollectionView.reloadData()
        }
    }
    
    func updateWebsiteStatusChange(dataStatus: String, index: Int) { }
    
    func websiteStatusChangeForQueue(index: Int) { }
    
    func updateDeleteWebsiteSuccess(status: Int, index: Int) { }
    
    func showPoorInternet() { }
}
