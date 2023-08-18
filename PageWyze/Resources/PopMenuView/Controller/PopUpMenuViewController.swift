//
//  PopUpMenuViewController.swift
//  MenuOnView
//
//  Created by Roushil singla on 11/2/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa

public class PopUpMenuViewController: NSViewController {
    
    @IBOutlet weak var menuItemsTableView: NSTableView!
    @IBOutlet weak var tableWidth: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var menuItemsLoader: NSProgressIndicator!
    @IBOutlet weak var listMenuView: NSScrollView!
    
    public lazy var menuItemModel: [PopUpMenuItemModel] = []
    public var onSelectedItemModel: ((PopUpMenuItemModel) -> Void)?
    public var selectedIndex: ((Int) -> Void)?
    var applyImageConstaint  : Int?
    var tableSize: CGSize?
    //var tableWidthConstant   : Int?
    //var tableHeightConstant  : Int?
    
    public init(menuItems: [PopUpMenuItemModel]) {
        super.init(nibName: "PopUpMenuViewController", bundle: Bundle(for: PopUpMenuViewController.self))
        menuItemModel = menuItems
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        menuItemModel.isEmpty ? showLoader() : hideLoader()
        setUpTable()
        tableWidth.constant  = CGFloat(tableSize?.width ?? 140)
        tableHeight.constant = CGFloat(tableSize?.height ?? 200)
    }
    
    
    public override func viewWillDisappear() {
        super.viewWillDisappear()
        hideLoader()
    }
    
    public func applyConstraintForImage(with constant: Int) {
        applyImageConstaint = constant
    }
    
    public func applyConstraintForCompleteMenu(tableSize: CGSize?) {
        self.tableSize = tableSize
    }
    
    /* Assigning table datasource & delegates and loading the cells */
    private func setUpTable() {
        menuItemsTableView.dataSource               = self
        menuItemsTableView.delegate                 = self
        menuItemsTableView.selectionHighlightStyle  = .none
        menuItemsTableView.register(NSNib(nibNamed: "PopUpMenuItemCell", bundle: Bundle(for: PopUpMenuItemCell.self)), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PopUpMenuItemCell"))
    }
    
    
    //* Hide List and show Spinner
    public func showLoader() {
        listMenuView.isHidden = true
        menuItemsLoader.startAnimation(nil)
    }
    
    //* Hide Spinner and show List
    public func hideLoader() {
        listMenuView.isHidden = false
        menuItemsLoader.stopAnimation(nil)
    }

    
    public func updateMenu(model: [PopUpMenuItemModel]) {
        menuItemModel = model
        menuItemModel.isEmpty ? showLoader() : hideLoader()
        menuItemsTableView.reloadData()
    }
}

extension PopUpMenuViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return menuItemModel.count
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PopUpMenuItemCell"), owner: self) as! PopUpMenuItemCell
        cell.setUpValueForItems                   = menuItemModel[row]
        cell.applyConstraintForImage              = applyImageConstaint
        return cell
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        /* Will Handle Using protocol And Delegates */
        guard let selectedTableView = notification.object as? NSTableView else { return }
        onSelectedItemModel?(menuItemModel[selectedTableView.selectedRow])
        selectedIndex?(selectedTableView.selectedRow)
        dismiss(self)
    }
}
