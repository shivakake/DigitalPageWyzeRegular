//
//  PagesLogic.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 16/02/23.
//

import Foundation
import NixelQueue

enum PagesAPINames : String {
    
    case pageTypesAPI = "types"
    case pagesListAPI = "pages"
    case newPageAPI = "newpage"
    case editPageAPI = "editpage"
    case approvePageAPI = "approvepage"
    case draftPageAPI = "draftpage"
    case completePageAPI = "completepage"
    case deletePageAPI = "deletepage"
    case pageDetailsAPI = "page"
    case pagesComponentsAPI = "components"
    case verityNewPageURLAPI = "newpageurl"
    case editPageComponentsAPI = "editpagecomponents"
}

protocol PagesLogicDelegate : AnyObject {
    
    func getPagesListFromResponse()
    func getTypesListFromResponse()
    func verifyPageURLSuccess(status: Int?)
    func addNewPageInQueue()
    func updateAddPageSuccess(ststus: Int, index: Int)
    func getPageDetailsFromResponse()
    func editPageInformationInQueue(index: Int)
    func updateEditPageInformation(index: Int, dataStatus: String?)
    func pageStatusChangeForQueue(index: Int)
    func updatePageStatusChange(dataStatus: String, index: Int)
    func updateDeletePageSuccess(status: Int, index: Int)
    func getPageComponentsListFromResponse()
    func showPoorInternet()
}

public class PagesLogic {
    
    public init() { }
    
    weak var delegate: PagesLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    public var sortedPageListArray: [PageDetailsDataModel] = [PageDetailsDataModel]()
    public var pageDetailsData: PageDetailsDataModel?
    public var dataListArray: [PageDataModel]?
    public var typesListArray: [TypesDataModel] = [TypesDataModel]()
    public var pageComponentsListArray: [PageComponentDetailsModel] = [PageComponentDetailsModel]()
    public var selectedSortFilterId = "name"
    public var statusFilter = "live"
    public var searchText = ""
    public var pagesDataListArray: [PageDataListModel] = [PageDataListModel]()
    
    //MARK:- Pages API Calls
    
    public func getPagesList(websiteId: String?, typeId : String? , statusFilter : String? , searchText : String? ,fromDate: String?, toDate: String?, sortId: String) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        self.statusFilter = statusFilter?.lowercased() ?? "live"
        self.selectedSortFilterId = sortId
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "type": typeId ?? "",
            "text": searchText ?? "",
            "status": self.statusFilter,
            "from": fromDate ?? "",
            "to": toDate ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: PagesAPINames.pagesListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getPagesTypesList() {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "type" : "page"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: PagesAPINames.pageTypesAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getComponentsTypesList() {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "type" : "component"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: PagesAPINames.pageTypesAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getPageComponentsList(websiteId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : websiteId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: PagesAPINames.pagesComponentsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getPageDetails(websiteId: String?, pageId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":pageId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: websiteId ?? "", strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: PagesAPINames.pageDetailsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func addNewPage(websiteId: String?, name: String?, text: String?, type: String?, url: String?, metatitle: String?, metadescription: String?, description: String?, canonical: String?, head: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "name": name ?? "",
            "text": text ?? "",
            "type": type ?? "",
            "url": url ?? "",
            "metatitle": metatitle ?? "",
            "metadescription": metadescription ?? "",
            "description": description ?? "",
            "canonical": canonical ?? "",
            "head": head ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "addNewPage", strApiName: PagesAPINames.newPageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        sortedPageListArray.insert(PageDetailsDataModel(canonical: "", components: "", created: "", data: nil, datastatus: "queue", description: description, head: "", id: strId, key: "", messages: "", metadescription: metadescription, metatitle: metatitle, name: name, status: "", text: "", type: type, typename: "", updated: FunctionsExtension.sharedInstance.getCurrentDate(), url: url), at: 0)
        delegate?.addNewPageInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editPageInfromation(websiteId: String? , ref: String?, name: String?, type: String?, url: String?, description: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":ref ?? "",
            "name": name ?? "",
            "url": url ?? "",
            "type": type ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "editPageInformation", strApiName: PagesAPINames.editPageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == ref}) {
            sortedPageListArray[firstIndex].name = name
            sortedPageListArray[firstIndex].type = type
            sortedPageListArray[firstIndex].description = description
            sortedPageListArray[firstIndex].url = url
            delegate?.editPageInformationInQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editSeoInfromation(websiteId: String?, ref: String?, metaTitle: String?, metaDescription: String?, canonical: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":ref ?? "",
            "metatitle": metaTitle ?? "",
            "metadescription": metaDescription ?? "",
            "canonical": canonical ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "editSeoInformation", strApiName: PagesAPINames.editPageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == ref}) {
            sortedPageListArray[firstIndex].metatitle = metaTitle
            sortedPageListArray[firstIndex].metadescription = metaDescription
            sortedPageListArray[firstIndex].canonical = canonical
            delegate?.editPageInformationInQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editContentAndCode(websiteId: String?, ref: String?, contentAndCode: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":ref ?? "",
            "text": contentAndCode ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "editContent", strApiName: PagesAPINames.editPageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == ref}) {
            sortedPageListArray[firstIndex].text = contentAndCode
            delegate?.editPageInformationInQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editPageHead(websiteId: String?, ref: String?, head: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":ref ?? "",
            "head": head ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "editHead", strApiName: PagesAPINames.editPageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == ref}) {
            sortedPageListArray[firstIndex].head = head
            delegate?.editPageInformationInQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editPageComponent(websiteId: String?, ref: String?, components: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":ref ?? "",
            "components": components ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "editPageComponent", strApiName: PagesAPINames.editPageComponentsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == ref}) {
            delegate?.editPageInformationInQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func savePageData(websiteId: String?, ref: String?, data: Any?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":ref ?? "",
            "data": data ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "editHead", strApiName: PagesAPINames.editPageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func approvePage(websiteId : String, pageId: String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId,
            "ref" : pageId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "approve", strApiName: PagesAPINames.approvePageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: {$0.id == pageId}) {
            sortedPageListArray[firstIndex].datastatus = "queue"
            delegate?.pageStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func completePage(websiteId : String, pageId: String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId,
            "ref" : pageId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "complete", strApiName: PagesAPINames.completePageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: {$0.id == pageId}) {
            sortedPageListArray[firstIndex].datastatus = "queue"
            delegate?.pageStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func deletePage(websiteId : String, pageId: String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId,
            "ref" : pageId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: pageId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "delete", strApiName: PagesAPINames.deletePageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: {$0.id == pageId}) {
            sortedPageListArray[firstIndex].datastatus = "queue"
            delegate?.pageStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func draftPage(websiteId : String, pageId: String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId,
            "ref" : pageId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "draft", strApiName: PagesAPINames.draftPageAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedPageListArray.firstIndex(where: {$0.id == pageId}) {
            sortedPageListArray[firstIndex].datastatus = "queue"
            delegate?.pageStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func verifyNewPageURL(websiteId: String? , urlString: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "url": urlString ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "page", strVerifyId: strId, strStatus: "queue", strOperation: "verifyURL", strApiName: PagesAPINames.verityNewPageURLAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
}

extension PagesLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case PagesAPINames.pageTypesAPI.rawValue:
            handleResponseForPagesTypesList(responseDict: objResponseDict)
            
        case PagesAPINames.pagesListAPI.rawValue:
            handleResponseForPagesList(responseDict: objResponseDict)
            
        case PagesAPINames.newPageAPI.rawValue:
            handleResponseForAddNewPage(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case PagesAPINames.editPageAPI.rawValue:
            handleResponseForEditPage(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case PagesAPINames.approvePageAPI.rawValue , PagesAPINames.draftPageAPI.rawValue , PagesAPINames.completePageAPI.rawValue:
            handleResponseForChangingPageStatus(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case PagesAPINames.deletePageAPI.rawValue:
            handleResponseForDeletePage(responseDict: objResponseDict , objHeaderQueue: objHeaderQueue)
            
        case PagesAPINames.pageDetailsAPI.rawValue:
            handleResponseForPageDetails(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case PagesAPINames.verityNewPageURLAPI.rawValue:
            handleResponseForVerifyNewURL(responseDict: objResponseDict)
            
        case PagesAPINames.pagesComponentsAPI.rawValue:
            handleResponseForPageComponentsList(responseDict: objResponseDict)
            
        case PagesAPINames.editPageComponentsAPI.rawValue:
            handleResponseForEditPageComponent(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        default:
            break
        }
    }
    
    //MARK:- API's response
    
    func handleResponseForPagesTypesList(responseDict: NSDictionary){
        typesListArray.removeAll()
        pageComponentsListArray.removeAll()
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let types = responseDict["types"] as? NSArray
                for type in types ?? []{
                    let obj = type as? NSDictionary
                    /// This condition seperates for listing and details Types
                    if obj?.count ?? 0 < 4 {
                        let id = obj?["id"] as? String ?? ""
                        let key = obj?["key"] as? String ?? ""
                        let name = obj?["name"] as? String ?? ""
                        typesListArray.append(TypesDataModel(id: id, key: key, name: name, pagecount: ""))
                    }else {
                        let id = obj?["id"] as? String ?? ""
                        let key = obj?["key"] as? String ?? ""
                        let name = obj?["name"] as? String ?? ""
                        let pagecount = obj?["pagecount"] as? String ?? ""
                        
                        pageComponentsListArray.append(PageComponentDetailsModel(name: name, id: id, key: key, pagecount: pagecount, items: [], selectedId: "None"))
                    }
                }
                typesListArray.insert(TypesDataModel(id: "none", key: "none", name: "None", pagecount: ""), at: 0)
                delegate?.getTypesListFromResponse()
            } else {
                delegate?.getTypesListFromResponse()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForPagesList(responseDict: NSDictionary) {
        sortedPageListArray.removeAll()
        var pagesListModel = [PageDetailsDataModel]()
        if responseDict.count > 0 {
            let pagesList = responseDict["list"] as? NSArray
            for pageDict in pagesList ?? [] {
                let page = pageDict as? NSDictionary
                
                let datastatus = page?["datastatus"] as? String
                let description = page?["description"] as? String
                let id = page?["id"] as? String
                let key = page?["key"] as? String
                let metadescription = page?["metadescription"] as? String
                let metatitle = page?["metatitle"] as? String
                let name = page?["name"] as? String
                let status = page?["status"] as? String
                let type = page?["type"] as? String
                let updated = page?["updated"] as? String
                let url = page?["url"] as? String
                
                pagesListModel.append(PageDetailsDataModel(canonical: "", components: "", created: "", data: nil, datastatus: datastatus, description: description, head: "", id: id, key: key, messages: "", metadescription: metadescription, metatitle: metatitle, name: name, status: status, text: "", type: type, typename: "", updated: updated, url: url))
            }
            
            if !pagesListModel.isEmpty {
                switch selectedSortFilterId {
                case "name":
                    sortedPageListArray = pagesListModel.sorted(by: {($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "")})
                case "type":
                    sortedPageListArray = pagesListModel.sorted(by: {($0.typename ?? "") < ($1.typename ?? "")})
                case "url":
                    sortedPageListArray = pagesListModel.sorted(by: {($0.url ?? "") < ($1.url ?? "")})
                case "date":
                    sortedPageListArray = pagesListModel.sorted(by: {($0.updated ?? "") < ($1.updated ?? "")})
                case "status":
                    sortedPageListArray = pagesListModel.sorted(by: {($0.datastatus ?? "") < ($1.datastatus ?? "")})
                default: break
                }
            } else {
                sortedPageListArray = []
            }
            
            delegate?.getPagesListFromResponse()
            
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForPageComponentsList(responseDict: NSDictionary){
        if responseDict.count > 0 {
            var pageComponents: [PageComponentsItemModel] = []
            let status = responseDict["status"] as? Int
            if status == 1 {
                let components = responseDict["components"] as? NSArray
                for component in components ?? []{
                    let obj = component as? NSDictionary
                    let datastatus = obj?["datastatus"] as? String ?? ""
                    let _default = obj?["default"] as? String ?? ""
                    let description = obj?["description"] as? String ?? ""
                    let id = obj?["id"] as? String ?? ""
                    let name = obj?["name"] as? String ?? ""
                    let status = obj?["status"] as? String ?? ""
                    let type = obj?["type"] as? String ?? ""
                    let updated = obj?["updated"] as? String ?? ""
                    
                    pageComponents.append(PageComponentsItemModel(datastatus: datastatus, componentDefault: _default, description: description, id: id, name: name, status: status, type: type, updated: updated))
                }
                
                for pageIndex in 0..<pageComponentsListArray.count {
                    for componentIndex in 0..<pageComponents.count {
                        if pageComponentsListArray[pageIndex].name == pageComponents[componentIndex].type {
                            pageComponentsListArray[pageIndex].items?.append(pageComponents[componentIndex]) 
                        }
                    }
                }
                delegate?.getPageComponentsListFromResponse()
            } else {
                delegate?.getPageComponentsListFromResponse()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForPageDetails(responseDict: NSDictionary ,objHeaderQueue: ClsHeaderQueue) {
        pagesDataListArray.removeAll()
        if responseDict.count > 0 {
            
            let canonical = responseDict["canonical"] as? String
            let components = responseDict["components"] as? String
            let created = responseDict["created"] as? String
            let datastatus = responseDict["datastatus"] as? String
            let description = responseDict["description"] as? String
            let head = responseDict["head"] as? String
            let key = responseDict["key"] as? String
            let metadescription = responseDict["metadescription"] as? String
            let metatitle = responseDict["metatitle"] as? String
            let name = responseDict["name"] as? String
            let text = responseDict["text"] as? String
            let type = responseDict["type"] as? String
            let typename = responseDict["typename"] as? String
            let updated = responseDict["updated"] as? String
            let url = responseDict["url"] as? String
            
            for list in (responseDict["data"] as? NSArray) ?? [] {
                let dict = list as? [String: String]
                for (key, value) in dict ?? [:] {
                    pagesDataListArray.append(PageDataListModel(key: key, value: value))
                }
            }
            
            pageDetailsData = PageDetailsDataModel(canonical: canonical, components: components, created: created, data: pagesDataListArray, datastatus: datastatus, description: description, head: head, id: objHeaderQueue.objHashMapData?["ref"] as? String ?? "", key: key, messages: "", metadescription: metadescription, metatitle: metatitle, name: name, status: "", text: text, type: type, typename: typename, updated: updated, url: url)
            
            delegate?.getPageDetailsFromResponse()
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForAddNewPage(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int ?? 0
            let datastatus = responseDict["datastatus"] as? String
            let id = responseDict["id"] as? String
            if let firstIndex = sortedPageListArray.firstIndex(where: {$0.id == objHeaderQueue.strObjectId}) {
                if status == 1 {
                    sortedPageListArray[firstIndex].id = id
                    sortedPageListArray[firstIndex].datastatus = datastatus
                } else {
                    sortedPageListArray.remove(at: firstIndex)
                }
                delegate?.updateAddPageSuccess(ststus: status, index: firstIndex)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForChangingPageStatus(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        
        if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live") && dataStatus != "complete" {
                sortedPageListArray[firstIndex].datastatus = dataStatus
            }else{
                self.sortedPageListArray.remove(at: firstIndex)
            }
            delegate?.updatePageStatusChange(dataStatus: dataStatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForDeletePage(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let id = objHeaderQueue.strObjectId ?? ""
        if let firstIndex = sortedPageListArray.firstIndex(where: {$0.id == id}) {
            if status == 1 {
                sortedPageListArray.remove(at: firstIndex)
            } else {
                sortedPageListArray[firstIndex].datastatus = "error"
            }
            delegate?.updateDeletePageSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForVerifyNewURL(responseDict: NSDictionary) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                delegate?.verifyPageURLSuccess(status: status)
            } else {
                delegate?.verifyPageURLSuccess(status: status)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForEditPage(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        
        if status == 1 {
            if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == id}) {
                if statusFilter == dataStatus || statusFilter == "live" {
                    sortedPageListArray[firstIndex].datastatus = dataStatus
                }else{
                    sortedPageListArray.remove(at: firstIndex)
                }
                delegate?.updateEditPageInformation(index: firstIndex, dataStatus: dataStatus)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForEditPageComponent(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        
        if status == 1 {
            if let firstIndex = sortedPageListArray.firstIndex(where: { $0.id == id}) {
                if statusFilter == dataStatus || statusFilter == "live" {
                    sortedPageListArray[firstIndex].datastatus = dataStatus
                }else{
                    sortedPageListArray.remove(at: firstIndex)
                }
                delegate?.updateEditPageInformation(index: firstIndex, dataStatus: dataStatus)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
}
