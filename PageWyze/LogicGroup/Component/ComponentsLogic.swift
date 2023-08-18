//
//  ComponentsLogic.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 30/03/23.
//

import Foundation
import NixelQueue

enum ComponentsAPINames : String {
    
    case componentTypesAPI = "types"
    case componentsListAPI = "components"
    case newComponentAPI = "newcomponent"
    case editComponentAPI = "editcomponent"
    case componentDetailsAPI = "component"
    case approveComponentAPI = "approvecomponent"
    case draftComponentAPI = "draftcomponent"
    case completeComponentAPI = "completecomponent"
    case deleteComponentAPI = "deletecomponent"
}

protocol ComponentsLogicDelegate : AnyObject {
    
    func getComponentsListFromResponse()
    func getTypesListFromResponse()
    func addNewComponentInQueue()
    func updateAddComponentSuccess(status: Int, index: Int)
    func getComponentDetailsFromResponse()
    func editComponentInQueue(index: Int)
    func updateEditComponent(index: Int, dataStatus: String?)
    func componentStatusChangeForQueue(index: Int)
    func updateComponentStatusChange(dataStatus: String, index: Int)
    func updateDeleteComponentSuccess(status: Int, index: Int)
    func showPoorInternet()
}

public class ComponentsLogic {
    
    public init() { }
    
    weak var delegate: ComponentsLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    public var sortedComponentListArray: [ComponentDetailsDataModel] = [ComponentDetailsDataModel]()
    public var componentDetailsData: ComponentDetailsDataModel?
    public var typesListArray: [TypesDataModel] = [TypesDataModel]()
    public var selectedSortFilterId = "name"
    public var statusFilter = "live"
    public var defaultValueString = "no"
    
    //MARK:- Component API Calls
    
    public func getComponentsList(websiteId: String?, typeId : String? , status : String? , searchText : String? ,fromDate: String?, toDate: String?, sortId: String) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        self.statusFilter = status?.lowercased() ?? "live"
        self.selectedSortFilterId = sortId
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "type": typeId ?? "",
            "text": searchText ?? "",
            "status": self.statusFilter,
            "from": fromDate ?? "",
            "to": toDate ?? "",
            "default": defaultValueString
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: ComponentsAPINames.componentsListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getComponentsTypesList() {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "type" : "component"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: ComponentsAPINames.componentTypesAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func addNewComponent(websiteId: String?, name: String?, text: String?, type: String?, description: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "name": name ?? "",
            "text": text ?? "",
            "type": type ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "addNewComponent", strApiName: ComponentsAPINames.newComponentAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        sortedComponentListArray.insert(ComponentDetailsDataModel(created: FunctionsExtension.sharedInstance.getCurrentDate(), datastatus: "queue" , componentDefault: "no", description: description, id: strId, name: name, status: "", text: "", type: type, typename: "", updated: FunctionsExtension.sharedInstance.getCurrentDate()), at: 0)
        
        delegate?.addNewComponentInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func getComponentDetails(websiteId: String?, componentId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":componentId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: componentId ?? "", strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: ComponentsAPINames.componentDetailsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func approveComponent(websiteId: String?, componentId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : componentId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "approve", strApiName: ComponentsAPINames.approveComponentAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedComponentListArray.firstIndex(where: {$0.id == componentId}) {
            sortedComponentListArray[firstIndex].datastatus = "queue"
            delegate?.componentStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func draftComponent(websiteId : String?, componentId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : componentId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "draft", strApiName: ComponentsAPINames.draftComponentAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedComponentListArray.firstIndex(where: {$0.id == componentId}) {
            sortedComponentListArray[firstIndex].datastatus = "queue"
            delegate?.componentStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    
    public func completeComponent(websiteId: String?, componentId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : componentId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "complete", strApiName: ComponentsAPINames.completeComponentAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedComponentListArray.firstIndex(where: {$0.id == componentId}) {
            sortedComponentListArray[firstIndex].datastatus = "queue"
            delegate?.componentStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func deleteComponent(websiteId: String?, componentId: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : componentId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: componentId ?? "", strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "delete", strApiName: ComponentsAPINames.deleteComponentAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedComponentListArray.firstIndex(where: {$0.id == componentId}) {
            sortedComponentListArray[firstIndex].datastatus = "queue"
            delegate?.componentStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editComponent(websiteId: String?, ref: String?, name: String?, text: String?, type: String?, description: String?, typeName: String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":ref ?? "",
            "name": name ?? "",
            "text": text ?? "",
            "type": type ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "component", strVerifyId: strId, strStatus: "queue", strOperation: "editComponent", strApiName: ComponentsAPINames.editComponentAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedComponentListArray.firstIndex(where: { $0.id == ref}) {
            sortedComponentListArray[firstIndex].name = name
            sortedComponentListArray[firstIndex].description = description
            sortedComponentListArray[firstIndex].text = text
            sortedComponentListArray[firstIndex].type = type
            sortedComponentListArray[firstIndex].typename = typeName
            componentDetailsData = sortedComponentListArray[firstIndex]
            delegate?.editComponentInQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
}

extension ComponentsLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case ComponentsAPINames.componentTypesAPI.rawValue:
            handleResponseForComponentsTypesList(responseDict: objResponseDict)
            
        case ComponentsAPINames.componentsListAPI.rawValue:
            handleResponseForComponentsList(responseDict: objResponseDict)
            
        case ComponentsAPINames.newComponentAPI.rawValue:
            handleResponseForAddNewComponent(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case ComponentsAPINames.editComponentAPI.rawValue:
            handleResponseForEditComponent(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case ComponentsAPINames.approveComponentAPI.rawValue , ComponentsAPINames.draftComponentAPI.rawValue , ComponentsAPINames.completeComponentAPI.rawValue:
            handleResponseForChangingComponentStatus(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case ComponentsAPINames.deleteComponentAPI.rawValue:
            handleResponseForDeleteComponent(responseDict: objResponseDict , objHeaderQueue: objHeaderQueue)
            
        case ComponentsAPINames.componentDetailsAPI.rawValue:
            handleResponseForComponentDetails(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        default:
            break
        }
    }
    
    //MARK:- API's response
    func handleResponseForComponentsTypesList(responseDict: NSDictionary){
        typesListArray.removeAll()
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let types = responseDict["types"] as? NSArray
                for type in types ?? []{
                    let obj = type as? NSDictionary
                    let id = obj?["id"] as? String ?? ""
                    let key = obj?["key"] as? String ?? ""
                    let name = obj?["name"] as? String ?? ""
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
    
    func handleResponseForComponentsList(responseDict: NSDictionary) {
        sortedComponentListArray.removeAll()
        var componentsListModel = [ComponentDetailsDataModel]()
        if responseDict.count > 0 {
            let componentsList = responseDict["list"] as? NSArray
            for componentDict in componentsList ?? [] {
                let component = componentDict as? NSDictionary
                let datastatus = component?["datastatus"] as? String
                let defaultValueString = component?["default"] as? String
                let description = component?["description"] as? String
                let id = component?["id"] as? String
                let name = component?["name"] as? String
                let status = component?["status"] as? String
                let type = component?["type"] as? String
                let updated = component?["updated"] as? String
                
                componentsListModel.append(ComponentDetailsDataModel(created: FunctionsExtension.sharedInstance.getCurrentDate(), datastatus: datastatus , componentDefault: defaultValueString, description: description, id: id, name: name, status: status, text: "", type: type, typename: "", updated: updated))
            }
            
            if !componentsListModel.isEmpty {
                switch selectedSortFilterId {
                case "name":
                    sortedComponentListArray = componentsListModel.sorted(by: {($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "")})
                case "type":
                    sortedComponentListArray = componentsListModel.sorted(by: {($0.type ?? "") < ($1.type ?? "")})
                case "date":
                    sortedComponentListArray = componentsListModel.sorted(by: {($0.updated ?? "") < ($1.updated ?? "")})
                case "status":
                    sortedComponentListArray = componentsListModel.sorted(by: {($0.datastatus ?? "") < ($1.datastatus ?? "")})
                default: break
                }
            } else {
                sortedComponentListArray = []
            }
            delegate?.getComponentsListFromResponse()
            
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForComponentDetails(responseDict: NSDictionary ,objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let created = responseDict["created"] as? String
            let datastatus = responseDict["datastatus"] as? String
            let defaultString = responseDict["default"] as? String
            let description = responseDict["description"] as? String
            let name = responseDict["name"] as? String
            let status = responseDict["status"] as? String
            let text = responseDict["text"] as? String
            let type = responseDict["type"] as? String
            let typename = responseDict["typename"] as? String
            let updated = responseDict["updated"] as? String
            
            componentDetailsData = ComponentDetailsDataModel(created: created, datastatus: datastatus, componentDefault: defaultString, description: description, id: objHeaderQueue.objHashMapData?["ref"] as? String ?? "", name: name, status: status, text: text, type: type, typename: typename, updated: updated)
            
            delegate?.getComponentDetailsFromResponse()
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForAddNewComponent(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int ?? 0
            let datastatus = responseDict["datastatus"] as? String
            let id = responseDict["id"] as? String
            if let firstIndex = sortedComponentListArray.firstIndex(where: {$0.id == objHeaderQueue.strObjectId}) {
                if status == 1 {
                    sortedComponentListArray[firstIndex].id = id
                    sortedComponentListArray[firstIndex].datastatus = datastatus
                } else {
                    sortedComponentListArray.remove(at: firstIndex)
                }
                delegate?.updateAddComponentSuccess(status: status, index: firstIndex)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForChangingComponentStatus(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        
        if let firstIndex = sortedComponentListArray.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live") && dataStatus != "complete" {
                sortedComponentListArray[firstIndex].datastatus = dataStatus
            }else{
                self.sortedComponentListArray.remove(at: firstIndex)
            }
            delegate?.updateComponentStatusChange(dataStatus: dataStatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForDeleteComponent(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let id = objHeaderQueue.strObjectId ?? ""
        if let firstIndex = sortedComponentListArray.firstIndex(where: {$0.id == id}) {
            if status == 1 {
                sortedComponentListArray.remove(at: firstIndex)
            } else {
                sortedComponentListArray[firstIndex].datastatus = "error"
            }
            delegate?.updateDeleteComponentSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForEditComponent(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        
        if status == 1 {
            if let firstIndex = sortedComponentListArray.firstIndex(where: { $0.id == id}) {
                if statusFilter == dataStatus || statusFilter == "live" {
                    sortedComponentListArray[firstIndex].datastatus = dataStatus
                }else{
                    sortedComponentListArray.remove(at: firstIndex)
                }
                componentDetailsData = sortedComponentListArray[firstIndex]
                delegate?.updateEditComponent(index: firstIndex, dataStatus: dataStatus)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
}
