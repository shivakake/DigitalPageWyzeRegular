//
//  PageTabsCommonView.swift
//  WebSites
//
//  Created by Nagendar on 27/12/22.
//

import Cocoa

class PageTabsCommonView: NSView {
    
    @IBOutlet weak var convertCustomView: NSView!
    @IBOutlet weak var tabsCollectionView: NSCollectionView!
    @IBOutlet var parentCustomView: NSView!
    
    public var pageDetailsTabsListArray = [TabNameModel(name: "Details"),TabNameModel(name: "KeyWords"),TabNameModel(name: "Notes"),TabNameModel(name: "Schedule")]
    public var pageLogic: PagesLogic?
    public var pageId: String?
    public weak var pagedelegate: PagesLogicDelegate?
    public var websiteLogic: WebsitesLogic?
    public var onBackClick: (() -> Void)?
    public var detailsView: PageDetailsView?
    
    init(pageLogic: PagesLogic?, pageDelegate: PagesLogicDelegate?, pageId: String?, websiteLogic: WebsitesLogic?) {
        self.pageLogic = pageLogic
        self.pagedelegate = pageDelegate
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
    
    fileprivate func addView() {
        Bundle(for: PageTabsCommonView.self).loadNibNamed("PageTabsCommonView", owner: self, topLevelObjects: nil)
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
        tabsCollectionView.dataSource = self
        tabsCollectionView.delegate = self
    }
    
    public func handleTabSelection(name: String) {
        
        convertCustomView.subviews.removeAll()
        
        switch name {
        
        case "Details" :
            if detailsView == nil {
                detailsView = PageDetailsView(pagelogic: self.pageLogic, delegate: self.pagedelegate, pageId: self.pageId, websiteLogic: self.websiteLogic)
                detailsView?.onBackClick = { [weak self] in
                    self?.onBackClick?()
                    self?.removeFromSuperview()
                }
            }
            
            addViewThroughConstraints(for: detailsView ?? NSView(), in: convertCustomView)
            
        case "Keywords" :
            print("Keywords")
            
        case "Notes" :
            print("Notes")
            
        case "Schedule" :
            print("Schedule")
            
        default:
            break
        }
    }
}

extension PageTabsCommonView : NSCollectionViewDataSource{
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageDetailsTabsListArray.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TabGridItem"), for: indexPath)
        guard let cell = item as? TabGridItem else { return item }
        cell.nameLabel?.stringValue = pageDetailsTabsListArray[indexPath.item].name ?? ""
        return cell
    }
}

extension PageTabsCommonView: NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first?.item else { return }
        handleTabSelection(name: pageDetailsTabsListArray[indexPath].name ?? "")
    }
}
