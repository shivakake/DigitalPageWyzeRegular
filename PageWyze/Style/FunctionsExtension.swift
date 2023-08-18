//
//  FunctionsExtension.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 23/12/22.
//

import Foundation
import Cocoa

public class FunctionsExtension {
    
    static let sharedInstance : FunctionsExtension = FunctionsExtension()
    private init () { }
    
    let formatter = DateFormatter()
    
    public func getCurrentDate()-> String {
        let date = Date()
        formatter.dateFormat = "dd-MMM-yyyy"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    public func dateToString(incomingDate: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: incomingDate)
        return currentDate
    }
    
    public func showValidationAlert(messgae: String) {
        let alert = NSAlert()
        alert.messageText = messgae
        alert.informativeText = "Are you sure"
        alert.addButton(withTitle: "OK")
        
        let window = NSApplication.shared.windows.first!
        alert.beginSheetModal(for: window) { response in
            if response == .alertFirstButtonReturn {
            } else {
            }
        }
    }
    
    func convertDictToJSONString(objJsonDict: [String: Any]) -> String {
        var strJson = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: objJsonDict, options: [])
            
            strJson = String(decoding: jsonData, as: UTF8.self)
        } catch {
            print(error.localizedDescription)
            strJson = ""
        }
        return strJson
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
