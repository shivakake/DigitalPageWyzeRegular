//
//  KeywordLogic.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 05/04/23.
//

import Foundation
import NixelQueue

enum KeywordAPINames: String {
    
    case keywordsListAPI = "keywords"
    case keywordDetailsAPI = "keyword"
    case newKeywordAPI = "newkeyword"
    case editKeywordAPI = "editkeyword"
    case approveKeywordAPI = "approvekeyword"
    case draftKeywordAPI = "draftkeyword"
    case completeKeywordAPI = "completekeyword"
    case deleteKeywordAPI = "deleteteammember"
}

protocol KeywordLogicDelegate: AnyObject {
    
    func getKeywordsListFromResponse()
    func keywordStatusChangeForQueue(index: Int)
    func updateKeywordStatusChange(dataStatus: String?, index: Int)
    func updateDeleteKeywordSuccess(status: Int?, index: Int)
    func addNewKeywordInQueue()
    func updateAddKeywordSuccess(status: Int?, index: Int?)
    func getKeywordDetailsFromResponse()
    func editKeywordInQueue(index: Int)
    func updateEditKeyword(index: Int, dataStatus: String?)
    func showPoorInternet()
}

public class KeywordLogic {
    
    public init() { }
    
    weak var delegate: KeywordLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    public var sortedKeywordListArray: [KeywordDetailsDataModel] = [KeywordDetailsDataModel]()
    public var keywordDetailsData: KeywordDetailsDataModel?
    public var selectedSortFilterId = "name"
    public var statusFilter = "live"
    
    //MARK:- Keywords API Calls
    
    public func getKeywordsList(websiteId: String?, pageId: String?, searchText: String?, status : String?, sortId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        self.statusFilter = status?.lowercased() ?? "live"
        self.selectedSortFilterId = sortId ?? "name"
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "page": "none", //pageId,
            "text": searchText ?? "",
            "status": self.statusFilter
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: KeywordAPINames.keywordsListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getKeywordDetails(websiteId: String?, keywordId: String?, pageId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref": keywordId ?? "",
            "page": pageId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: keywordId ?? "", strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: KeywordAPINames.keywordDetailsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func approveKeyword(websiteId: String?, keywordId: String?, pageId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : keywordId ?? "",
            "page": pageId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "approve", strApiName: KeywordAPINames.approveKeywordAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedKeywordListArray.firstIndex(where: {$0.id == keywordId}) {
            sortedKeywordListArray[firstIndex].datastatus = "queue"
            delegate?.keywordStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func draftKeyword(websiteId : String?, keywordId: String?, pageId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : keywordId ?? "",
            "page": pageId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "draft", strApiName: KeywordAPINames.draftKeywordAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedKeywordListArray.firstIndex(where: {$0.id == keywordId}) {
            sortedKeywordListArray[firstIndex].datastatus = "queue"
            delegate?.keywordStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func completeKeyword(websiteId: String?, keywordId: String?, pageId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : keywordId ?? "",
            "page": pageId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "complete", strApiName: KeywordAPINames.completeKeywordAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedKeywordListArray.firstIndex(where: {$0.id == keywordId}) {
            sortedKeywordListArray[firstIndex].datastatus = "queue"
            delegate?.keywordStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func deleteKeyword(websiteId: String?, keywordId: String?, pageId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : keywordId ?? "",
            "page": pageId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: keywordId ?? "", strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "deleteKeyword", strApiName: KeywordAPINames.deleteKeywordAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedKeywordListArray.firstIndex(where: {$0.id == keywordId}) {
            sortedKeywordListArray[firstIndex].datastatus = "queue"
            delegate?.keywordStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func addNewKeyword(websiteId: String?, name: String?, pageId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "name": name ?? "",
            "page": pageId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "addNewKeyword", strApiName: KeywordAPINames.newKeywordAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        sortedKeywordListArray.insert(KeywordDetailsDataModel(created: FunctionsExtension.sharedInstance.getCurrentDate(), datastatus: "queue", description: "", id: strId, name: name, updated: FunctionsExtension.sharedInstance.getCurrentDate(), pages: nil), at: 0)
        
        delegate?.addNewKeywordInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editKeyword(websiteId: String?, keywordId: String?, name: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":keywordId ?? "",
            "name": name ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "keyword", strVerifyId: strId, strStatus: "queue", strOperation: "editKeyword", strApiName: KeywordAPINames.editKeywordAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedKeywordListArray.firstIndex(where: { $0.id == keywordId}) {
            sortedKeywordListArray[firstIndex].name = name
            keywordDetailsData = sortedKeywordListArray[firstIndex]
            delegate?.editKeywordInQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
}

extension KeywordLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case KeywordAPINames.keywordsListAPI.rawValue:
            handleResponseForKeywordsList(responseDict: objResponseDict)
            
        case KeywordAPINames.keywordDetailsAPI.rawValue:
            handleResponseForKeywordDetails(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case KeywordAPINames.newKeywordAPI.rawValue:
            handleResponseForAddNewKeyword(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case KeywordAPINames.editKeywordAPI.rawValue:
            handleResponseForEditKeyword(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case KeywordAPINames.approveKeywordAPI.rawValue,
             KeywordAPINames.draftKeywordAPI.rawValue,
             KeywordAPINames.completeKeywordAPI.rawValue:
            handleResponseForChangingKeywordStatus(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case KeywordAPINames.deleteKeywordAPI.rawValue:
            handleResponseForDeleteKeyword(responseDict: objResponseDict , objHeaderQueue: objHeaderQueue)
        default:
            break
        }
    }
    
    //MARK:- API's response
    func handleResponseForKeywordsList(responseDict: NSDictionary) {
        sortedKeywordListArray.removeAll()
        var keywordsListModel = [KeywordDetailsDataModel]()
        if responseDict.count > 0 {
            let keywordsList = responseDict["list"] as? NSArray
            for keywordDict in keywordsList ?? [] {
                let keyword = keywordDict as? NSDictionary
                
                let created = keyword?["created"] as? String
                let datastatus = keyword?["datastatus"] as? String
                let description = keyword?["description"] as? String
                let id = keyword?["id"] as? String
                let name = keyword?["name"] as? String
                let updated = keyword?["updated"] as? String
                
                keywordsListModel.append(KeywordDetailsDataModel(created: created, datastatus: datastatus, description: description, id: id, name: name, updated: updated, pages: nil))
            }
            
            if !keywordsListModel.isEmpty {
                switch selectedSortFilterId {
                case "name":
                    sortedKeywordListArray = keywordsListModel.sorted(by: {($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "")})
                case "date":
                    sortedKeywordListArray = keywordsListModel.sorted(by: {($0.updated ?? "") < ($1.updated ?? "")})
                case "status":
                    sortedKeywordListArray = keywordsListModel.sorted(by: {($0.datastatus ?? "") < ($1.datastatus ?? "")})
                default: break
                }
            } else {
                sortedKeywordListArray = []
            }
            delegate?.getKeywordsListFromResponse()
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForKeywordDetails(responseDict: NSDictionary ,objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let created = responseDict["created"] as? String
            let datastatus = responseDict["datastatus"] as? String
            let description = responseDict["description"] as? String
            let name = responseDict["name"] as? String
            let updated = responseDict["updated"] as? String
            let pages = responseDict["pages"] as? [[String: Any]]
            
            keywordDetailsData = KeywordDetailsDataModel(created: created, datastatus: datastatus, description: description, id: objHeaderQueue.objHashMapData?["ref"] as? String ?? "", name: name, updated: updated, pages: pages)
            
            delegate?.getKeywordDetailsFromResponse()
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForChangingKeywordStatus(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        
        if let firstIndex = sortedKeywordListArray.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live") && dataStatus != "complete" {
                sortedKeywordListArray[firstIndex].datastatus = dataStatus
            }else{
                self.sortedKeywordListArray.remove(at: firstIndex)
            }
            delegate?.updateKeywordStatusChange(dataStatus: dataStatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForDeleteKeyword(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let id = objHeaderQueue.strObjectId ?? ""
        if let firstIndex = sortedKeywordListArray.firstIndex(where: {$0.id == id}) {
            if status == 1 {
                sortedKeywordListArray.remove(at: firstIndex)
            } else {
                sortedKeywordListArray[firstIndex].datastatus = "error"
            }
            delegate?.updateDeleteKeywordSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForEditKeyword(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        
        if status == 1 {
            if let firstIndex = sortedKeywordListArray.firstIndex(where: { $0.id == id}) {
                if statusFilter == dataStatus || statusFilter == "live" {
                    sortedKeywordListArray[firstIndex].datastatus = dataStatus
                }else{
                    sortedKeywordListArray.remove(at: firstIndex)
                }
                keywordDetailsData = sortedKeywordListArray[firstIndex]
                delegate?.updateEditKeyword(index: firstIndex, dataStatus: dataStatus)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForAddNewKeyword(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int ?? 0
            let datastatus = responseDict["datastatus"] as? String
            let id = responseDict["id"] as? String
            if let firstIndex = sortedKeywordListArray.firstIndex(where: {$0.id == objHeaderQueue.strObjectId}) {
                if status == 1 {
                    sortedKeywordListArray[firstIndex].id = id
                    sortedKeywordListArray[firstIndex].datastatus = datastatus
                } else {
                    sortedKeywordListArray.remove(at: firstIndex)
                }
                delegate?.updateAddKeywordSuccess(status: status, index: firstIndex)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
}
