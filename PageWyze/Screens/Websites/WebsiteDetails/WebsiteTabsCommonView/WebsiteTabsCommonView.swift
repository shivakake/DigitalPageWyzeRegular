//
//  WebsiteTabsCommonView.swift
//  WebSites
//
//  Created by Nagendar on 21/12/22.
//

import Cocoa

class WebsiteTabsCommonView: NSView {
    
    @IBOutlet weak var userInractionHandlerView: UIUserInteractionHandler!
    @IBOutlet weak var tabCollectionView: NSCollectionView!
    @IBOutlet weak var convertCustomView: NSView!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var tabsScrollView: NSScrollView!
    
    public var websiteDetailsTabsListArray = [TabNameModel(name: "Details"),TabNameModel(name: "Pages"),TabNameModel(name: "Components"),TabNameModel(name: "Files"),TabNameModel(name: "Notes"),TabNameModel(name: "Schedule"),TabNameModel(name: "Responses"),TabNameModel(name: "Teams"),TabNameModel(name: "KeyWords"),TabNameModel(name: "Library"),TabNameModel(name: "Analytics")]
    
    public var websiteDetailsView: WebsiteDetailsView?
    public var editBrandView: EditBrandView?
    public var editbrandInfoView: EditBrandView?
    public var pagesGridAndListCommonView: PagesGridAndListCommonView?
    public var componentsGridAndListCommonView: ComponentGridAndListCommonView?
    public var teamsGridAndListCommonView: TeamsGridAndListCommonView?
    public var keywordsGridAndListCommonView: KeywordsGridAndListCommonView?
    public var analyticsListView: AnalyticsListView?
    public var openMenu: NSMenu!
    public var websiteLogic: WebsitesLogic?
    public weak var delegate: WebsitesLogicDelegate?
    public var onBackToList: (() -> Void)?
    
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
        Bundle(for: WebsiteTabsCommonView.self).loadNibNamed("WebsiteTabsCommonView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        parentCustomView.frame = contentFrame
        addSubview(parentCustomView)
    }
    
    public func commonMethod() {
        addView()
        registerColletionView()
        handleTabSelection(name: "Details")
    }
    
    public func registerColletionView() {
        tabCollectionView.dataSource = self
        tabCollectionView.delegate = self
    }
    
    @IBAction func moreButton(_ sender: Any) { }
    
    public func handleTabSelection(name: String) {
        
        convertCustomView.subviews.removeAll()
        
        switch name {
        
        case "Details" :
            if websiteDetailsView == nil {
                websiteDetailsView = WebsiteDetailsView(logic: websiteLogic, delegate: delegate)
                websiteDetailsView?.onBackToList = { [weak self] in
                    self?.onBackToList?()
                    self?.removeFromSuperview()
                }
            }
            addViewThroughConstraints(for: websiteDetailsView ?? NSView(), in: convertCustomView)
        case "Pages" :
            if pagesGridAndListCommonView == nil {
                pagesGridAndListCommonView = PagesGridAndListCommonView(websiteLogic: self.websiteLogic)
                pagesGridAndListCommonView?.onHideDetailsTab = { [weak self] hideTab in
                    guard let _self = self else { return }
                    _self.tabsScrollView.isHidden = hideTab
                }
            }
            addViewThroughConstraints(for: pagesGridAndListCommonView ?? NSView() , in: convertCustomView)
            
        case "Components" :
            if componentsGridAndListCommonView == nil {
                componentsGridAndListCommonView = ComponentGridAndListCommonView(websiteLogic: self.websiteLogic)
                componentsGridAndListCommonView?.onHideDetailsTab = { [weak self] hideTab in
                    guard let _self = self else { return }
                    _self.tabsScrollView.isHidden = hideTab
                }
            }
            addViewThroughConstraints(for: componentsGridAndListCommonView ?? NSView() , in: convertCustomView)
            
        case "Files" :
            print("File")
            
        case "Notes" :
            print("Notes")
            
        case "Schedule" :
            print("Schedule")
            
        case "Responses" :
            print("Responses")
            
        case "Teams" :
            if teamsGridAndListCommonView == nil {
                teamsGridAndListCommonView = TeamsGridAndListCommonView(websiteLogic: self.websiteLogic)
                teamsGridAndListCommonView?.onHideDetailsTab = { [weak self] hideTab in
                    guard let _self = self else { return }
                    _self.tabsScrollView.isHidden = hideTab
                }
            }
            addViewThroughConstraints(for: teamsGridAndListCommonView ?? NSView() , in: convertCustomView)
            
        case "KeyWords" :
            if keywordsGridAndListCommonView == nil {
                keywordsGridAndListCommonView = KeywordsGridAndListCommonView(websiteLogic: self.websiteLogic)
                keywordsGridAndListCommonView?.onHideDetailsTab = { [weak self] hideTab in
                    guard let _self = self else { return }
                    _self.tabsScrollView.isHidden = hideTab
                }
            }
            addViewThroughConstraints(for: keywordsGridAndListCommonView ?? NSView() , in: convertCustomView)
            
        case "Library" :
            print("Library")
            
        case "Analytics" :
            
            if analyticsListView == nil {
                analyticsListView = AnalyticsListView(websiteLogic: self.websiteLogic)
                //                analyticsListView?.onHideDetailsTab = { [weak self] hideTab in
                //                    guard let _self = self else { return }
                //                    _self.tabsScrollView.isHidden = hideTab
                //                }
            }
            addViewThroughConstraints(for: analyticsListView ?? NSView() , in: convertCustomView)
            
        default:
            break
        }
    }
}

extension WebsiteTabsCommonView : NSCollectionViewDataSource{
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return websiteDetailsTabsListArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TabGridItem"), for: indexPath)
        guard let cell = item as? TabGridItem else { return item }
        cell.nameLabel?.stringValue = websiteDetailsTabsListArray[indexPath.item].name ?? ""
        return cell
    }
}

extension WebsiteTabsCommonView: NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        handleTabSelection(name: websiteDetailsTabsListArray[indexPath].name ?? "")
    }
}

struct TabNameModel {
    var name: String?
    var id: Int?
}
