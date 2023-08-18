//
//  StyleExtensions.swift
//
//  Created by Roushil singla on 10/7/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import Cocoa

public extension NSImage {
    
    /* Return Same Image with color applied on it */
    func imageWithColor(tintColor: NSColor) -> NSImage {
        guard isTemplate else { return self }
        guard let copiedImage = self.copy() as? NSImage else { return self }
        copiedImage.lockFocus()
        tintColor.set()
        let imageBounds = NSMakeRect(0, 0, copiedImage.size.width, copiedImage.size.height)
        imageBounds.fill(using: .sourceAtop)
        copiedImage.unlockFocus()
        copiedImage.isTemplate = false
        return copiedImage
    }
}

extension NSButton {
    
    /* Applying background to Button with color */
    public func setStyle(with bgColor: NSColor?, tintColor: NSColor? = .white , needCircularBorder: Bool) {
        
        self.bezelStyle             = .texturedSquare
        self.wantsLayer             = true
        self.layer?.backgroundColor = bgColor?.cgColor
        if #available(OSX 10.14, *) {
            self.contentTintColor       = tintColor
        } else {
            // Fallback on earlier versions
            self.attributedTitle = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.foregroundColor : tintColor ?? .clear])
        }
        if needCircularBorder {
            self.layer?.cornerRadius    = self.frame.height/2
        }else {
            self.layer?.cornerRadius = 5
        }
    }
    
    /* Applying background to Button with color */
    public func setBorder(with bgColor: NSColor?) {
        
        self.wantsLayer          = true
        self.layer?.borderWidth  = 1
        self.layer?.borderColor  = bgColor?.cgColor
        self.layer?.cornerRadius = 5
    }
}

public extension NSView {
    
    /* Applying Border to View */
    func setBorder(color: NSColor?) {
        self.wantsLayer             = true
        self.layer?.cornerRadius    = 5
        self.layer?.borderWidth     = 1
        self.layer?.borderColor     = color == nil ? NSColor.darkGray.cgColor : color?.cgColor
    }
    
    func setCircularBorder(cornerRadius: CGFloat? = nil, color: NSColor? = .darkGray) {
        self.wantsLayer             = true
        self.layer?.cornerRadius    = cornerRadius == nil ? self.frame.height/2 : (cornerRadius ?? 5)
        self.layer?.borderColor     = color == nil ? NSColor.darkGray.cgColor : color?.cgColor
        self.layer?.borderWidth     = 1
    }
    
    func setSquareBorder() {
        self.wantsLayer             = true
        self.layer?.borderColor     = NSColor.darkGray.cgColor
        self.layer?.borderWidth     = 0.5
    }
    
    func addShadow(color: NSColor) {
        self.wantsLayer = true
        self.layer?.backgroundColor = effectiveAppearance.name == .darkAqua ? .black : .white
        self.shadow = NSShadow()
        self.layer?.shadowOpacity = 0.5
        self.layer?.shadowColor = color.cgColor
        self.layer?.shadowOffset = NSMakeSize(2 , -2)
        self.layer?.shadowRadius = 2
    }
    
    func addViewThroughConstraints(for childView: NSView, in parentView: NSView) {
        parentView.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}

public extension NSProgressIndicator {
    
    func set(tintColor: NSColor) {
        guard let adjustedTintColor = tintColor.usingColorSpace(.deviceRGB) else {
            contentFilters = []
            return
        }
        
        let tintColorRedComponent = adjustedTintColor.redComponent
        let tintColorGreenComponent = adjustedTintColor.greenComponent
        let tintColorBlueComponent = adjustedTintColor.blueComponent
        
        let tintColorMinComponentsVector = CIVector(x: tintColorRedComponent, y: tintColorGreenComponent, z: tintColorBlueComponent, w: 0.0)
        let tintColorMaxComponentsVector = CIVector(x: tintColorRedComponent, y: tintColorGreenComponent, z: tintColorBlueComponent, w: 1.0)
        
        let colorClampFilter = CIFilter(name: "CIColorClamp")
        colorClampFilter?.setDefaults()
        colorClampFilter?.setValue(tintColorMinComponentsVector, forKey: "inputMinComponents")
        colorClampFilter?.setValue(tintColorMaxComponentsVector, forKey: "inputMaxComponents")
        
        contentFilters = [colorClampFilter!]
    }
}

public extension String {
    
    var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        return attributedString.string
    }
}

public extension NSAttributedString {
    
    func height(containerWidth: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }
    
    func width(containerHeight: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.width)
    }
}

public extension NSImageView {
    
    func getImageFormURLString(imageString: String) {
        let urlString = imageString.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { /// execute on main thread
                    self.image = NSImage(data: data)
                }
            }
            task.resume()
        }
    }
    
    func setStatusImage(status: String?) {
        switch status?.lowercased() {
        case "live":
            self.image = NSImage(named: "live")
        case "draft":
            self.image = NSImage(named: "drafts")
        case "active":
            self.image = NSImage(named: "active")
        case "complete":
            self.image = NSImage(named: "completes")
        case "inactive":
            self.image = NSImage(named: "inactive")
        default:
            break
        }
    }
}

extension URL {
    
    var sanitise: URL {
        if var components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if components.scheme == nil {
                components.scheme = "https"
            }
            return components.url ?? self
        }
        return self
    }
}
