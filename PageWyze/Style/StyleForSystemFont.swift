//
//  StyleForSystemFont.swift
//
//  Created by Roushil singla on 10/7/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import Cocoa

extension Style {
    static var projectStyle: Style {
        /* Provide defined attributes */
        return Style( attributesForStyle: { $0.fontStylingAttributes } )
    }
}

//MARK: Define all font specification we need to provide
extension NSFont {
    
    /* Font Style for Large Title label */
    static var styleSelectionForLargeTitle: NSFont {
        return .systemFont(ofSize: 26, weight: .medium)
    }
    
    /* Font Style for Title label */
    static var styleSelectionForTitle: NSFont {
        return .systemFont(ofSize: 18, weight: .regular)
    }
    
    /* Font Style for Subtitle Label */
    static var styleSelectionForSubtitle: NSFont {
        return .systemFont(ofSize: 13, weight: .regular)
    }
    
    /* Font Style for Bold Label */
    static var styleSelectionBoldText: NSFont {
        return .systemFont(ofSize: 15, weight: .bold)
    }
    
    /* Font Style for Meta/Date */
    static var styleSelectionMeta: NSFont {
        return .systemFont(ofSize: 10, weight: .regular)
    }
    
    /* Font Style for Large Title Button */
    static var styleSelectionForLargeButton: NSFont {
        return .systemFont(ofSize: 18, weight: .medium)
    }
    
    /* Font Style for Normal Button */
    static var styleSelectionForButton: NSFont {
        return .systemFont(ofSize: 15, weight: .regular)
    }
    
}

//If you require to change font for TextStyle (Eg. title, sublitle) go to above font extension Eg. styleSelectionForTitle  and change
private extension Style.TextStyle {
    
    var fontStylingAttributes: Style.TextAttributes {
        
        switch self {
        
        /* Return Large title font */
        case .largeTitle:
            return Style.TextAttributes(font: .styleSelectionForLargeTitle, color: .labelColor)
            
        /* Return title font */
        case .title:
            return Style.TextAttributes(font: .styleSelectionForTitle, color: .labelColor )
            
        /* Return subtitle font */
        case .subtitle:
            return Style.TextAttributes(font: .styleSelectionForSubtitle, color: .labelColor)
            
        /* Return Button font */
        case .button:
            return Style.TextAttributes(font: .styleSelectionForButton, color: .labelColor)
            
        /* Return Title Button font */
        case .titleButton:
            return Style.TextAttributes(font: .styleSelectionForLargeButton, color: .labelColor)
            
        /* Return Meta Date font */
        case .meta:
            return Style.TextAttributes (font: .styleSelectionMeta, color: .systemGray)
            
        /* Return Bold Label font */
        case .bold:
            return Style.TextAttributes(font: .styleSelectionBoldText, color: .labelColor)
        }
    }
}
