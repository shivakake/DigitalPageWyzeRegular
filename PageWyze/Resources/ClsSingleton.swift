//
//  ClsSingleton.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 18/01/23.
//

import Foundation
import NixelQueue

class ClsSingleton {
    
    private static var sharedInstance: ClsSingleton?
    
    class var shared: ClsSingleton {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = ClsSingleton()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func destroySingletonInstance() {
        sharedInstance = nil
    }
    
    let strPathUrl = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    let strAppName = "PageWyze"
    var strAppDirPath = ""
    var memberIdDirPath = ""
    var baseURL = "http://api.pagewyze.com"
    
    public func createDirs(memberID: String) {
        
        strAppDirPath = strAppName
        memberIdDirPath = strAppDirPath + "/" + memberID
        
        let strAppDirPathFull =
            strPathUrl.appendingPathComponent(strAppDirPath)
        
        if(!fileCheckAtPath(strFilePath: strAppDirPathFull)) {
            // create the directory
            createFolder(strDirPath: strAppDirPathFull)
        }
        
        let strMemberDirPathFull =
            strPathUrl.appendingPathComponent(memberIdDirPath)
        
        if(!fileCheckAtPath(strFilePath: strMemberDirPathFull)){
            // if 'QueueUpload' directory does not exist
            // create the directory
            createFolder(strDirPath: strMemberDirPathFull)
        }
    }
    
    public func fileCheckAtPath(strFilePath:String) -> Bool {
        return FileManager.default.fileExists(atPath: strFilePath)
    }
    
    public func createFolder(strDirPath: String) {
        do {
            // create directory at given path
            try FileManager.default.createDirectory(atPath: strDirPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setUpValuesForNixelQueueLibrary() {
        let session = "sqqqjbikykqdlkaakmromrmorurpwratlnkuyqdgvahnrxdb"
        let memberId = ""
        ClsQueueManager.shared.setInternetValue(value: 1)
        ClsSingleton.shared.createDirs(memberID: memberId)
        ClsQueueManager.shared.initializeQueueLogic(strPathUrl: ClsSingleton.shared.strPathUrl, strMemberIdDirPath: ClsSingleton.shared.memberIdDirPath, strBaseUrl: ClsSingleton.shared.baseURL, strSessionId: session)
    }
}
//xwaiygwwadpbddukxfwqwqwpwrrojfwrdodtndskkksigsre
