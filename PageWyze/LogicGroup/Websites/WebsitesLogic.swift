//
//  WebsitesLogic.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 18/01/23.
//

import Foundation
import NixelQueue

enum WebsitesAPINames : String {
    
    case typesAPI = "types"
    case categoriesAPI = "categories"
    case languagesAPI = "languages"
    case websitesListAPI = "websites"
    case newWebsiteAPI = "newwebsite"
    case editWebsiteAPI = "editwebsite"
    case approveWebsiteAPI = "approvewebsite"
    case draftWebsiteAPI = "draftwebsite"
    case completeWebsiteAPI = "completewebsite"
    case deleteWebsiteAPI = "deletewebsite"
    case websiteDetailsAPI = "website"
    case editwebsitepagedataAPI = "editwebsitepagedata"
    case editwebsitednsAPI = "editwebsitedns"
    case generateFileAPI = "generatefile"
    case componentsAPI = "components"
    case groupsAPI = "groups"
    case filesAPI = "files"
    case websitednsAPI = "websitedns"
    case websitedataAPI = "websitedata"
    case verityNewURLAPI = "newurl"
}

protocol WebsitesLogicDelegate : AnyObject {
    
    func getWebsitesListFromResponse()
    func getTypesListFromResponse()
    func getLanguagesListFromResponse()
    func getCategoriesListFromResponse()
    func getVerifyDomainResponse(status: Int?)
    func addNewWebsiteInQueue()
    func updateAddWebsiteSuccess(ststus: Int, index: Int)
    func getWebsiteDetailsFromResponse(detailsModel: WebsiteDetailsDataModel?, pagesList: [PageDataModel]?)
    func getGeneratedFileResponse(status: Int?)
    func getStatisticListResponse(statisticsDataModel: [StatisticsDataModel])
    func updateEditPageDataSuccess(datastatus: String)
    func editWebsiteInQueue(index: Int)
    func updateEditWebsiteSuccess(index: Int, copyRight: String, dataStatus: String)
    func getFilesListFromResponse()
    func getGroupsListFromResponse()
    func updateWebsiteStatusChange(dataStatus: String, index: Int)
    func websiteStatusChangeForQueue(index: Int)
    func updateDeleteWebsiteSuccess(status: Int, index: Int)
    func showPoorInternet()
}

public class WebsitesLogic {
    
    public init() { }
    
    weak var delegate: WebsitesLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    public var sortedWebsiteList: [WebsiteDetailsDataModel] = [WebsiteDetailsDataModel]()
    public var websiteDetailsModel: WebsiteDetailsDataModel?
    public var typesListArray: [TypesDataModel] = [TypesDataModel]()
    public var languageListArray: [TypesDataModel] = [TypesDataModel]()
    public var categoriesListArray: [TypesDataModel] = [TypesDataModel]()
    public var websitesPagesListArray: [PageDataModel] = [PageDataModel]()
    public var filesListArray: [WebsiteFileDataModel] = [WebsiteFileDataModel]()
    public var websiteGroupsListArray: [WebsiteGroupDataModel] = [WebsiteGroupDataModel]()
    
    public var statusFilter = "live"
    public var selectedSortFilterId = "name"
    public var imageDirectoryString = ""
    public var imageDirectoryIdString = ""
    
    //MARK:- Websites API Calls
    
    public func getWebsitesList(typeId : String? , status : String? , text : String? ,fromDate: String?, toDate: String?, sortId: String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        self.statusFilter = status?.lowercased() ?? "live"
        self.selectedSortFilterId = sortId
        
        let objectHashMapData = [
            "type": typeId ?? "",
            "text": text ?? "",
            "status": self.statusFilter,
            "from": fromDate ?? "",
            "to": toDate ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.websitesListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getTypesList() {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "type" : "website"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.typesAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getCategoriesList() {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "type" : "website"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.categoriesAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getLanguagesList()  {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "type" : "content"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.languagesAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getWebsiteDetails(websiteId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: websiteId ?? "", strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.websiteDetailsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func addNewWebsite(name: String? , url: String?, type: String?, category: String?, language: String?, domain: String?, secure: String? , www: String?, description: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "name": name ?? "",
            "url": url ?? "",
            "type": type ?? "",
            "category": category ?? "",
            "language": language ?? "",
            "domain": domain ?? "",
            "secure": secure ?? "",
            "www": www ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "addNewWebsite", strApiName: WebsitesAPINames.newWebsiteAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        sortedWebsiteList.insert(WebsiteDetailsDataModel(category: category, categoryname: "", components: "", copyright: "", created: FunctionsExtension.sharedInstance.getCurrentDate(), datastatus: "queue", description: description, domain: domain, domainname: "", favicon: "", faviconname: "", faviconurl: "",id: strId, language: language, languagename: "", livestatus: "", logo: "", logoname: "", logourl: "", messages: "", name: name, pagedata: [], secure: secure, status: "", test: "", type: type, typename: "", updated: FunctionsExtension.sharedInstance.getCurrentDate(), url: "", www: www), at: 0)
        
        delegate?.addNewWebsiteInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editWebsite(model: WebsiteDetailsDataModel?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "name": model?.name ?? "",
            "url": model?.url ?? "",
            "type": model?.type ?? "",
            "category": model?.category ?? "",
            "language": model?.language ?? "",
            "domain": model?.domain ?? "",
            "secure": model?.secure?.lowercased() ?? "",
            "www": model?.www?.lowercased() ?? "",
            "description": model?.description ?? "",
            "ref":model?.id ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "editWebsite", strApiName: WebsitesAPINames.editWebsiteAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedWebsiteList.firstIndex(where: { $0.id == model?.id}) {
            sortedWebsiteList[firstIndex] = model ?? WebsiteDetailsDataModel(category: "", categoryname: "", components: "", copyright: "", created: "", datastatus: "", description: "", domain: "", domainname: "", favicon: "", faviconname: "", faviconurl: "", id: "", language: "", languagename: "", livestatus: "", logo: "", logoname: "", logourl: "", messages: "", name: "", pagedata: nil, secure: "", status: "", test: "", type: "", typename: "", updated: "", url: "", www: "")
            delegate?.editWebsiteInQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func approveWebsite(websiteId : String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : websiteId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "approve", strApiName: WebsitesAPINames.approveWebsiteAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedWebsiteList.firstIndex(where: {$0.id == websiteId}) {
            sortedWebsiteList[firstIndex].datastatus = "queue"
            delegate?.websiteStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func completeWebsite(websiteId : String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : websiteId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "complete", strApiName: WebsitesAPINames.completeWebsiteAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedWebsiteList.firstIndex(where: {$0.id == websiteId}) {
            sortedWebsiteList[firstIndex].datastatus = "queue"
            delegate?.websiteStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func deleteWebsite(websiteId : String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : websiteId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: websiteId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "delete", strApiName: WebsitesAPINames.deleteWebsiteAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedWebsiteList.firstIndex(where: {$0.id == websiteId}) {
            sortedWebsiteList[firstIndex].datastatus = "queue"
            delegate?.websiteStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func draftWebsite(websiteId : String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : websiteId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "draft", strApiName: WebsitesAPINames.draftWebsiteAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedWebsiteList.firstIndex(where: {$0.id == websiteId}) {
            sortedWebsiteList[firstIndex].datastatus = "queue"
            delegate?.websiteStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func verifyNewWebsiteURL(typeId: String? , urlString: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "type": typeId ?? "",
            "url": urlString ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "verifyURL", strApiName: WebsitesAPINames.verityNewURLAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func checkGeneratedFile(websiteId: String?, fileName: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "file": fileName ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "generateFile", strApiName: WebsitesAPINames.generateFileAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func getStatisticsList(websiteId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.websitedataAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func savePageData(websiteId: String? , pageData: Any?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "data": pageData ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "savePageData", strApiName: WebsitesAPINames.editwebsitepagedataAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func getFilesList(websiteId: String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId,
            "type": ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.filesAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getGroupsList() {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": "none",
            "type": "websitefile"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: WebsitesAPINames.groupsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func submitBrandInformationData(websiteId: String?, favicon: String?, logo: String?, copyright: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "copyright": copyright ?? "",
            "favicon": favicon ?? "",
            "logo": logo ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: websiteId ?? "", strObjType: "website", strVerifyId: strId, strStatus: "queue", strOperation: "saveBrandInformationData", strApiName: WebsitesAPINames.editWebsiteAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
}

extension WebsitesLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case WebsitesAPINames.typesAPI.rawValue:
            handleResponseForTypesList(responseDict: objResponseDict)
            
        case WebsitesAPINames.categoriesAPI.rawValue:
            handleResponseForCategoriesList(responseDict: objResponseDict)
            
        case WebsitesAPINames.languagesAPI.rawValue:
            handleResponseForLanguagesList(responseDict: objResponseDict)
            
        case WebsitesAPINames.websitesListAPI.rawValue:
            handleResponseForWebsitesList(responseDict: objResponseDict)
            
        case WebsitesAPINames.websiteDetailsAPI.rawValue:
            handleResponseForWebsiteDetails(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case WebsitesAPINames.approveWebsiteAPI.rawValue , WebsitesAPINames.draftWebsiteAPI.rawValue , WebsitesAPINames.completeWebsiteAPI.rawValue:
            handleResponseForChangingWebsiteStatus(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case WebsitesAPINames.newWebsiteAPI.rawValue:
            handleResponseForAddNewWebsite(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case WebsitesAPINames.editWebsiteAPI.rawValue:
            handleResponseForEditWebsite(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case WebsitesAPINames.deleteWebsiteAPI.rawValue:
            handleResponseForDeleteWebsite(responseDict: objResponseDict , objHeaderQueue: objHeaderQueue)
            
        case WebsitesAPINames.verityNewURLAPI.rawValue:
            handleResponseForVerifyNewURL(responseDict: objResponseDict)
            
        case WebsitesAPINames.generateFileAPI.rawValue:
            handleResponseForGenerateFile(responseDict: objResponseDict)
            
        case WebsitesAPINames.websitedataAPI.rawValue:
            handleResponseForStatisticList(responseDict: objResponseDict)
            
        case WebsitesAPINames.editwebsitepagedataAPI.rawValue:
            handleResponseForSavePageData(responseDict: objResponseDict)
            
        case WebsitesAPINames.filesAPI.rawValue:
            handleResponseForFilesList(responseDict: objResponseDict)
            
        case WebsitesAPINames.groupsAPI.rawValue:
            handleResponseForGroupsList(responseDict: objResponseDict)
        default:
            break
        }
    }
    
    //MARK:- API's response
    
    func handleResponseForTypesList(responseDict: NSDictionary){
        typesListArray.removeAll()
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let types = responseDict["types"] as? NSArray
                for type in types ?? []{
                    let obj = type as? NSDictionary
                    let id = obj?["id"] as? String
                    let key = obj?["key"] as? String
                    let name = obj?["name"] as? String
                    typesListArray.append(TypesDataModel(id: id, key: key, name: name, pagecount: ""))
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
    
    func handleResponseForCategoriesList(responseDict: NSDictionary){
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let categories = responseDict["categories"] as? NSArray
                for category in categories ?? []{
                    let obj = category as? NSDictionary
                    let id = obj?["id"] as? String
                    let name = obj?["name"] as? String
                    categoriesListArray.append(TypesDataModel(id: id, key: "", name: name, pagecount: ""))
                }
                delegate?.getCategoriesListFromResponse()
            } else {
                delegate?.getCategoriesListFromResponse()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForLanguagesList(responseDict: NSDictionary){
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let languages = responseDict["languages"] as? NSArray
                for language in languages ?? []{
                    let obj = language as? NSDictionary
                    let id = obj?["id"] as? String
                    let name = obj?["name"] as? String
                    languageListArray.append(TypesDataModel(id: id, key: "", name: name, pagecount: ""))
                }
                delegate?.getLanguagesListFromResponse()
            } else {
                delegate?.getLanguagesListFromResponse()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForWebsitesList(responseDict: NSDictionary) {
        sortedWebsiteList.removeAll()
        var websitesListModel = [WebsiteDetailsDataModel]()
        if responseDict.count > 0 {
            let websitesList = responseDict["list"] as? NSArray
            for websiteDict in websitesList ?? [] {
                let website = websiteDict as? NSDictionary
                
                let category = website?["category"] as? String
                let categoryname = website?["categoryname"] as? String
                let datastatus = website?["datastatus"] as? String
                let description = website?["description"] as? String
                let faviconurl = website?["faviconurl"] as? String
                let id = website?["id"] as? String
                let logourl = website?["logourl"] as? String
                let name = website?["name"] as? String
                let status = website?["status"] as? String
                let type = website?["type"] as? String
                let updated = website?["updated"] as? String
                let url = website?["url"] as? String
                
                websitesListModel.append(WebsiteDetailsDataModel(category: category, categoryname: categoryname, components: "", copyright: "", created:"", datastatus: datastatus, description: description, domain: "", domainname: "", favicon: "", faviconname: "", faviconurl: faviconurl, id: id, language: "",languagename: "", livestatus: "", logo: "", logoname: "", logourl: logourl, messages: "", name: name ?? "", pagedata: [], secure: "", status: status, test: "", type: type, typename: type, updated: updated, url: url, www: ""))
            }
            
            if !websitesListModel.isEmpty {
                switch selectedSortFilterId {
                case "name":
                    sortedWebsiteList = websitesListModel.sorted(by: {($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "")})
                case "type":
                    sortedWebsiteList = websitesListModel.sorted(by: {($0.typename ?? "") < ($1.typename ?? "")})
                case "url":
                    sortedWebsiteList = websitesListModel.sorted(by: {($0.url ?? "") < ($1.url ?? "")})
                case "date":
                    sortedWebsiteList = websitesListModel.sorted(by: {($0.updated ?? "") < ($1.updated ?? "")})
                case "status":
                    sortedWebsiteList = websitesListModel.sorted(by: {($0.datastatus ?? "") < ($1.datastatus ?? "")})
                default: break
                }
            } else {
                sortedWebsiteList = []
            }
            delegate?.getWebsitesListFromResponse()
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForWebsiteDetails(responseDict: NSDictionary ,objHeaderQueue: ClsHeaderQueue) {
        websitesPagesListArray.removeAll()
        if responseDict.count > 0 {
            let category = responseDict["category"] as? String
            let categoryname = responseDict["categoryname"] as? String
            let components = responseDict["components"] as? String
            let copyright = responseDict["copyright"] as? String
            let created = responseDict["created"] as? String
            let datastatus = responseDict["datastatus"] as? String
            let description = responseDict["description"] as? String
            let domain = responseDict["domain"] as? String
            let domainname = responseDict["domainname"] as? String
            let favicon = responseDict["favicon"] as? String
            let faviconname = responseDict["faviconname"] as? String
            let faviconurl = responseDict["faviconurl"] as? String
            let language = responseDict["language"] as? String
            let languagename = responseDict["languagename"] as? String
            let livestatus = responseDict["livestatus"] as? String
            let logo = responseDict["logo"] as? String
            let logoname = responseDict["logoname"] as? String
            let logourl = responseDict["logourl"] as? String
            let messages = responseDict["messages"] as? String
            let name = responseDict["name"] as? String
            let pagedata:[[String:Any]] = responseDict["pagedata"] as? [[String:Any]] ?? []
            let secure = responseDict["secure"] as? String
            let status = responseDict["status"] as? String
            let test = responseDict["test"] as? String
            let type = responseDict["type"] as? String
            let typename = responseDict["typename"] as? String
            let updated = responseDict["updated"] as? String
            let url = responseDict["url"] as? String
            let www = responseDict["www"] as? String
            
            for page in pagedata {
                let name = page["name"] as? String
                let key = page["key"] as? String
                let length = page["length"] as? String
                let objPageData = PageDataModel(name: name, key: key, length: length)
                websitesPagesListArray.append(objPageData)
            }
            websiteDetailsModel = WebsiteDetailsDataModel(category: category, categoryname: categoryname, components: components, copyright: copyright, created: created, datastatus: datastatus, description: description, domain: domain, domainname: domainname, favicon: favicon, faviconname: faviconname, faviconurl: faviconurl, id: objHeaderQueue.strObjectId, language: language, languagename: languagename, livestatus: livestatus, logo: logo, logoname: logoname, logourl: logourl, messages: messages, name: name, pagedata: websitesPagesListArray, secure: secure, status: status, test: test, type: type, typename: typename, updated: updated, url: url, www: www)
            
            delegate?.getWebsiteDetailsFromResponse(detailsModel: websiteDetailsModel, pagesList: websitesPagesListArray)
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForAddNewWebsite(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int ?? 0
            let datastatus = responseDict["datastatus"] as? String
            let id = responseDict["id"] as? String
            _ = responseDict["test"] as? String
            let url = responseDict["url"] as? String
            if let firstIndex = sortedWebsiteList.firstIndex(where: {$0.id == objHeaderQueue.strObjectId}) {
                if status == 1 {
                    sortedWebsiteList[firstIndex].id = id
                    sortedWebsiteList[firstIndex].url = url
                    sortedWebsiteList[firstIndex].datastatus = datastatus
                } else {
                    sortedWebsiteList.remove(at: firstIndex)
                }
                delegate?.updateAddWebsiteSuccess(ststus: status, index: firstIndex)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForChangingWebsiteStatus(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        
        if let firstIndex = sortedWebsiteList.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live") && dataStatus != "complete" {
                sortedWebsiteList[firstIndex].datastatus = dataStatus
            }else{
                sortedWebsiteList.remove(at: firstIndex)
            }
            delegate?.updateWebsiteStatusChange(dataStatus: dataStatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForDeleteWebsite(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let id = objHeaderQueue.strObjectId ?? ""
        if let firstIndex = sortedWebsiteList.firstIndex(where: {$0.id == id}) {
            if status == 1 {
                sortedWebsiteList.remove(at: firstIndex)
            } else {
                sortedWebsiteList[firstIndex].datastatus = "error"
            }
            delegate?.updateDeleteWebsiteSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForVerifyNewURL(responseDict: NSDictionary) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                delegate?.getVerifyDomainResponse(status: status)
            } else {
                delegate?.getVerifyDomainResponse(status: status)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForGenerateFile(responseDict: NSDictionary) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                delegate?.getGeneratedFileResponse(status: status)
            } else {
                delegate?.getGeneratedFileResponse(status: status)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForStatisticList(responseDict: NSDictionary) {
        var statModel: [StatisticsDataModel] = [StatisticsDataModel]()
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let statistiData = responseDict["data"] as? NSArray
                for stats in statistiData ?? [] {
                    if let obj = stats as? NSDictionary {
                        let name = obj["name"] as? String
                        let value = obj["value"] as? String
                        statModel.append(StatisticsDataModel(name: name, value: value))
                    }
                }
                delegate?.getStatisticListResponse(statisticsDataModel: statModel)
            } else {
                delegate?.getStatisticListResponse(statisticsDataModel: statModel)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForSavePageData(responseDict: NSDictionary) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            let datastatus = responseDict["datastatus"] as? String
            if status == 1 {
                delegate?.updateEditPageDataSuccess(datastatus: datastatus ?? "")
            } else {
                delegate?.updateEditPageDataSuccess(datastatus: datastatus ?? "")
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForEditWebsite(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let dataStats = status == 1 ? datastatus?.lowercased() : "error"
        let faviconurl = responseDict["faviconurl"] as? String
        let logourl = responseDict["logourl"] as? String
        let test = responseDict["test"] as? String
        let url = responseDict["url"] as? String
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        let copyright = objHeaderQueue.objHashMapData?["copyright"] as? String ?? ""
        
        if status == 1 {
            if let firstIndex = sortedWebsiteList.firstIndex(where: { $0.id == id}) {
                if statusFilter == dataStats || statusFilter == "live" {
                    sortedWebsiteList[firstIndex].datastatus = dataStats
                    sortedWebsiteList[firstIndex].faviconurl = faviconurl
                    sortedWebsiteList[firstIndex].logourl = logourl
                    sortedWebsiteList[firstIndex].test = test
                    sortedWebsiteList[firstIndex].url = url
                    websiteDetailsModel?.copyright = copyright
                    sortedWebsiteList[firstIndex].copyright = copyright
                }else{
                    sortedWebsiteList.remove(at: firstIndex)
                }
                delegate?.updateEditWebsiteSuccess(index: firstIndex, copyRight: copyright, dataStatus: datastatus ?? "live")
                
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForFilesList(responseDict: NSDictionary){
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let files = responseDict["list"] as? NSArray
                for file in files ?? []{
                    let list = file as? NSDictionary
                    let datastatus = list?["datastatus"] as? String
                    let description = list?["description"] as? String
                    let filename = list?["filename"] as? String
                    let filesize = list?["filesize"] as? String
                    let filetype = list?["filetype"] as? String
                    let group = list?["group"] as? String
                    let groupname = list?["groupname"] as? String
                    let type = list?["type"] as? String
                    let updated = list?["updated"] as? String
                    let id = list?["id"] as? String
                    let name = list?["name"] as? String
                    
                    filesListArray.append(WebsiteFileDataModel(datastatus: datastatus, description: description, filename: filename, filesize: filesize,filetype: filetype, group: group, groupname: groupname, id: id, name: name, type: type, updated: updated))
                }
                delegate?.getFilesListFromResponse()
            } else {
                delegate?.getFilesListFromResponse()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForGroupsList(responseDict: NSDictionary){
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let groups = responseDict["list"] as? NSArray
                for group in groups ?? []{
                    let obj = group as? NSDictionary
                    let created = obj?["created"] as? String
                    let datastatus = obj?["datastatus"] as? String
                    let description = obj?["description"] as? String
                    let directory = obj?["directory"] as? String
                    let id = obj?["id"] as? String
                    let key = obj?["key"] as? String
                    let name = obj?["name"] as? String
                    let updated = obj?["updated"] as? String
                    
                    websiteGroupsListArray.append(WebsiteGroupDataModel(created: created, datastatus: datastatus, description: description, directory: directory, id: id, key: key, name: name, updated: updated))
                    
                    if key == "images"{
                        imageDirectoryString = directory ?? ""
                        imageDirectoryIdString = id ?? ""
                    }
                }
                delegate?.getGroupsListFromResponse()
            } else {
                delegate?.getGroupsListFromResponse()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
}
