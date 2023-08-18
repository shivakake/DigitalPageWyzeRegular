//
//  Theme.swift
//
//  Created by Roushil singla on 10/7/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import Cocoa

// MARK: - Define all the cases for which you want the style to be implemented
//For Ex. You want to give a particular font size/type /style to a title is every UI , mention case "title"
public class Style {
    
    public enum TextStyle {
        //case navigationBar
        case largeTitle     // Large Title
        case title          // Title
        case subtitle       // Small Titles and Descriptions
        case button         // Button i.e all types of button
        case titleButton    // Button with Title Size
        case meta           // Date in small Size
        case bold           // Regular Label in bold
    }
    
    // MARK: - Define all the attributes you want specific for Text
    struct TextAttributes {
        let font: NSFont    // Eg. Systemfont, Helvetica
        let color: NSColor  // Eg. Red Green
        
        // MARK: - Convenient initializer
        init(font: NSFont, color: NSColor) {
            self.font = font
            self.color = color
        }
    }
    
    // Variable is used to acess enum
    let attributesForStyle: (_ style: TextStyle) -> TextAttributes
    
    init(attributesForStyle: @escaping (_ style: TextStyle) -> TextAttributes) {
        self.attributesForStyle = attributesForStyle
    }
    
    // MARK: - Define style for Label and Textfield
    public func apply(textStyle: TextStyle, to label: NSTextField, withColor: NSColor? = nil) {
        let attributes = attributesForStyle(textStyle)
        label.font = attributes.font
        withColor != nil ? (label.textColor = withColor) : (label.textColor = attributes.color)
    }
    
    // MARK: - Define style for Button
    public func apply(textStyle: TextStyle, to button: NSButton, withColor: NSColor? = nil) {
        let attributes = attributesForStyle(textStyle)
        button.font = attributes.font
        if #available(OSX 10.14, *) {
            withColor != nil ? (button.contentTintColor = withColor) : (button.contentTintColor = attributes.color)
        } else {
            button.attributedTitle = NSAttributedString(string: button.title, attributes: [NSAttributedString.Key.foregroundColor : withColor != nil ? (withColor ?? .white) : attributes.color])
        }
        button.isBordered ? print("***Remove -isBordered- from Button and Color will reflect***") : ()
    }
    
    // MARK: - Define style for TextView
    public func apply(textStyle: TextStyle, to textView: NSTextView, withColor: NSColor? = nil) {
        let attributes = attributesForStyle(textStyle)
        textView.font = attributes.font
        withColor != nil ? (textView.textColor = withColor) : (textView.textColor = attributes.color)
    }
    
    // MARK: - Define style for Search Field
    public func apply(textStyle: TextStyle, to searchField: NSSearchField, withColor: NSColor? = nil) {
        let attributes = attributesForStyle(textStyle)
        searchField.font = attributes.font
        withColor != nil ? (searchField.textColor = withColor) : (searchField.textColor = attributes.color)
    }
}
