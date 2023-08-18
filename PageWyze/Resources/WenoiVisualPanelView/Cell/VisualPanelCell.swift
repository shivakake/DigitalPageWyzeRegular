//
//  VisualPanelCell.swift
//  WenoiUI
//
//  Created by Roushil singla on 9/29/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa

public class VisualPanelCell: NSCollectionViewItem {
    
    @IBOutlet weak var imageLogo: NSImageView!
    @IBOutlet weak var titleName: NSTextField!
    @IBOutlet var backGroundView: NSView!
    @IBOutlet weak var statusImage: NSImageView!
    
    public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "VisualPanelCell", bundle: Bundle(for: VisualPanelCell.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "VisualPanelCell", bundle: Bundle(for: VisualPanelCell.self))
    }
    
    var onPanelTapped: (() -> Void)?
    
    var isPanelSelected: Bool? {
        didSet {
            if isPanelSelected == true {
                backGroundView.layer?.borderWidth = 2
            } else {
                backGroundView.layer?.borderWidth = 0
            }
        }
    }
    
   
    
    /* Panel Variable to apply data from Model or Passed Default Value */
    var panelModel: (WenoiVisualPanelModel?, NSImage?) {
        didSet {
            imageLogo.image         = panelModel.1
            titleName.stringValue   = panelModel.0?.strTitle ?? ""
        }
    }
    
    /* Hide and show Status */
    var hideStatus: Bool? {
        didSet{
            statusImage.isHidden = hideStatus ?? true
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Assign Layer to Items */
        backGroundView.wantsLayer           = true
        backGroundView.layer?.borderColor   = StyleSheet.appColor.cgColor
        backGroundView.layer?.cornerRadius  = 5
        backGroundView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(panelTapped)))
    }
    
    
    @objc func panelTapped() {
        onPanelTapped?()
    }
}
