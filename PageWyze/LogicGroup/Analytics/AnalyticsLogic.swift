//
//  AnalyticsLogic.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 07/04/23.
//

import Foundation
import NixelQueue

enum AnalyticsAPINames: String {
    case analyticsListAPI = "pageviews"
}

protocol AnalyticsLogicDelegate: AnyObject {
    
    func getAnalyticsListFromResponse()
    func showPoorInternet()
}

public class AnalyticsLogic {
    
    public init() { }
    
    weak var delegate: AnalyticsLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    public var analyticsListArray: [AnalyticDetailsDataModel] = [AnalyticDetailsDataModel]()
    
    //MARK:- Analytics API Calls
    
    public func getAnalyticsList(websiteId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "analytics", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: AnalyticsAPINames.analyticsListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
}

extension AnalyticsLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case AnalyticsAPINames.analyticsListAPI.rawValue:
            handleResponseForAnalyticsList(responseDict: objResponseDict)
            
        default:
            break
        }
    }
    
    //MARK:- API's response
    
    func handleResponseForAnalyticsList(responseDict: NSDictionary) {
        analyticsListArray.removeAll()
        if responseDict.count > 0 {
            let analyticsList = responseDict["pages"] as? NSArray
            for analyticDict in analyticsList ?? [] {
                let analytic = analyticDict as? NSDictionary
                
                let id = analytic?["id"] as? String
                let name = analytic?["name"] as? String
                let url = analytic?["url"] as? String
                let views = analytic?["views"] as? String
                
                analyticsListArray.append(AnalyticDetailsDataModel(id: id, name: name, url: url, views: views))
            }
            delegate?.getAnalyticsListFromResponse()
        } else {
            delegate?.showPoorInternet()
        }
    }
}
