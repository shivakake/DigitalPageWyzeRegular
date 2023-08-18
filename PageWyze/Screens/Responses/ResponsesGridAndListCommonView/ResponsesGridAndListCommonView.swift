//
//  ResponsesGridAndListCommonView.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 04/01/23.
//

import Cocoa

class ResponsesGridAndListCommonView: NSView {
    
    @IBOutlet weak var userIntractionHandlerView: UIUserInteractionHandler!
    @IBOutlet var parentCustomView: NSView!
    @IBOutlet weak var statusCustomView: NSView!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var statusTitleLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var dateView: NSView!
    @IBOutlet weak var dateViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var gridListSegmentController: NSSegmentedControl!
    @IBOutlet weak var responsesGridListChangeView: NSView!
    
    var responsesViewMode = ViewMode.grid {
        didSet {
            changeViewMode()
        }
    }
    var gridView: ResponsesGridView?
    var listView: ResponsesListView?
    var selectedFromDate: Date?
    var selectedToDate: Date?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonMethodes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonMethodes()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public func commonMethodes() {
        addView()
        setupUI()
        firstIndexofSegment()
    }
    
    fileprivate func addView() {
        Bundle(for: ResponsesGridAndListCommonView.self).loadNibNamed("ResponsesGridAndListCommonView", owner: self, topLevelObjects: nil)
        parentCustomView.frame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        addSubview(parentCustomView)
    }
    
    public func setupUI() {
        parentCustomView.wantsLayer = true
        parentCustomView.addShadow(color: .lightGray)
        
        statusCustomView.setBorder(color: .lightGray)
        statusCustomView.layer?.backgroundColor = .white
        statusTitleLabel.font = .styleSelectionForSubtitle
        
        dateView.setBorder(color: .lightGray)
        
        setGestureToViews()
    }
    
    public func setGestureToViews() {
        
        statusCustomView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(statusViewTapped)))
        
        dateView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(dateViewTapped)))
    }
    
    @objc func statusViewTapped() {
        showPopUpForButtonViews(toLabel: statusTitleLabel, showList: statusArray)
    }
    
    @objc func dateViewTapped() {
        showPopupForDate()
    }
    
    public func firstIndexofSegment() {
        gridListSegmentController.selectedSegment = 0
        responsesViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
    
    public func changeViewMode() {
        responsesGridListChangeView.subviews.removeAll()
        
        switch responsesViewMode {
        case .grid:
            if gridView == nil {
                gridView = ResponsesGridView()
            }
//            gridView?.responsesDetailsCallBack = { [weak self] model in
//                guard let wealSelf = self else { return }
//                let responsesDetails = ResponsesDetailsView()
//                wealSelf.userIntractionHandlerView.isUserInteractionEnabled = false
//                responsesDetails.navCallBack = { [weak self] in
//                    guard let _self = self else { return }
//                    _self.userIntractionHandlerView.isUserInteractionEnabled = true
//                }
//                _self.addViewThroughConstraints(for: responsesDetails, in: wealSelf.parentView)
//            }
            addViewThroughConstraints(for: gridView ?? NSView(), in: responsesGridListChangeView)
        case .list:
            if listView == nil {
                listView = ResponsesListView()
            }
//            listView?.responsesDetailsCallBack = { [weak self] model in
//                guard let wealSelf = self else { return }
//                let responsesDetails = ResponsesDetailsView()
//                wealSelf.userIntractionHandlerView.isUserInteractionEnabled = false
//                responsesDetails.navCallBack = { [weak self] in
//                    guard let _self = self else { return }
//                    _self.userIntractionHandlerView.isUserInteractionEnabled = true
//                }
//                _self.addViewThroughConstraints(for: responsesDetails, in: wealSelf.parentView)
//            }
            addViewThroughConstraints(for: listView ?? NSView(), in: responsesGridListChangeView)
        default:
            break
        }
    }
    
    public func showPopupForDate() {
        let fromToDatePicker = FromToDatePickerController()
        //MARK: Set title to Picker. Show Default values if no date selected otherwise show selected dates in User Format for date by converting it
        setTitleToDatePickerPopup(fromToDatePicker)
        //MARK: Get Selected Date from Popup
        fromToDatePicker.selectedDate = { [weak self] fromDate, toDate in
            //MARK: Dates coming in dd-MMM-yy format
            guard let _self = self else { return }
            let showFromDateToUser = fromDate?.getFormattedStringFromDate(format: "dd-MMM-yy")
            let showToDateToUser = toDate?.getFormattedStringFromDate(format: "dd-MMM-yy")
            DispatchQueue.main.async {
                if fromDate == nil && toDate == nil {
                    //MARK: No Dates will be showed to User
                    let date = FunctionsExtension.sharedInstance.getCurrentDate()
                    _self.dateLabel.stringValue = date
                    _self.selectedFromDate = nil
                    _self.selectedToDate = nil
                } else if fromDate == nil {
                    //MARK: Only toDate will be showed to User
                    _self.dateLabel.stringValue = "To - \(showToDateToUser ?? "")"
                    _self.selectedFromDate = nil
                    _self.selectedToDate = toDate
                } else if toDate == nil {
                    //MARK: Only fromDate will be showed to User
                    _self.dateLabel.stringValue = "Start Date - \(showToDateToUser ?? "")"
                    _self.selectedFromDate = fromDate
                    _self.selectedToDate = nil
                } else {
                    _self.selectedFromDate = fromDate
                    _self.selectedToDate = toDate
                    //MARK: All Dates will be showed to User
                    _self.dateLabel.stringValue = "\(showFromDateToUser ?? "") / \(showToDateToUser ?? "")"
                    _self.dateViewWidthConstraint.constant = 200
                }
            }
            //MARK: Selected Dates to send to API
            //            let fromDateInString = fromDate?.getFormattedStringFromDate(format: "yyyy-MM-dd")
            //            let toDateInString = toDate?.getFormattedStringFromDate(format: "yyyy-MM-dd")
            //MARK: Get Listing API
        }
        self.window?.contentViewController?.present(fromToDatePicker, asPopoverRelativeTo: .init(x: 0, y: 0, width: 150, height: 150), of: dateLabel, preferredEdge: .maxY, behavior: .transient)
    }
    
    private func setTitleToDatePickerPopup(_ controller: FromToDatePickerController) {
        //MARK: Get selected Dates In String from Applied Filter
        let getSelectedFromDateString = selectedFromDate?.getFormattedStringFromDate(format: "dd-MMM-yy")
        //MARK: Fetch Selected To-date and convert them into dd-MMM-yy format to show to User
        let getSelectedToDateString = selectedToDate?.getFormattedStringFromDate(format: "dd-MMM-yy")
        //MARK: Dates are converted into dd-MMM-yy format to show to user as selected dates were in yyyy-MM-dd format
        if selectedFromDate == nil && selectedToDate == nil {
            //MARK: No Dates will be showed to User
            controller.setTitleToDates(fromDate: "From", toDate: "To")
        } else if selectedFromDate == nil {
            //MARK: Only toDate will be showed to User
            controller.toDate = getSelectedToDateString ?? ""
        } else if selectedToDate == nil {
            //MARK: Only fromDate will be showed to User
            controller.fromDate = getSelectedFromDateString ?? ""
        } else {
            //MARK: All Dates will be showed to User
            controller.setTitleToDates(fromDate: getSelectedFromDateString ?? "", toDate: getSelectedToDateString ?? "")
        }
    }
    
    public func showPopUpForButtonViews(toLabel label: NSTextField , showList itemList: [PopUpMenuItemModel]) {
        let menu = PopUpMenuViewController(menuItems: itemList)
        
        if label == statusTitleLabel {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 80, height: 130))
            menu.onSelectedItemModel = { selectedSortItem in
                if let name = selectedSortItem.itemName {
                    label.stringValue = name
                }
            }
        } else {
            menu.applyConstraintForCompleteMenu(tableSize: CGSize(width: 80, height: 105))
            menu.onSelectedItemModel = { selectedSortItem in
                if let name = selectedSortItem.itemName {
                    label.stringValue = name
                }
            }
        }
        self.window?.contentViewController?.present(menu, asPopoverRelativeTo: .zero, of: label, preferredEdge: .maxY, behavior: .transient)
    }
    
    @IBAction func fileGridListFileSegmentContollerTapped(_ sender: NSSegmentedControl) {
        responsesViewMode = gridListSegmentController.selectedSegment == 0 ? .grid : .list
    }
}
