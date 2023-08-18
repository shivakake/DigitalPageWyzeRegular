//
//  TeamsLogic.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 01/04/23.
//

import Foundation
import NixelQueue

enum TeamsAPINames : String {
    
    case teamsListAPI = "team"
    case newTeamMemberAPI = "newteammember"
    case editTeamMemberAPI = "editteammember"
    case deleteTeamMemberAPI = "deleteteammember"
    case rolesListAPI = "roles"
    case newRoleAPI = "newrole"
    case editRoleAPI = "editrole"
}

protocol TeamsLogicDelegate : AnyObject {
    
    func getTeamsListFromResponse()
    func getRolesListFromResponse()
    func addNewTeamMemberInQueue()
    func updateAddTeamMemberSuccess(status: Int?, index: Int?)
    func getTeamDetailsFromResponse()
    func editTeamMemberInQueue(index: Int)
    func updateEditTeamMember(index: Int, dataStatus: String?)
    func teamMemberStatusChangeForQueue(index: Int)
    func updateDeleteTeamMemberSuccess(status: Int?, index: Int)
    func addNewRoleInQueue()
    func updateAddRoleSuccess(status: Int?, index: Int?)
    func editRoleInQueue(index: Int)
    func updateEditRole(index: Int, dataStatus: String?)
    func showPoorInternet()
}

public class TeamsLogic {
    
    public init() { }
    
    weak var delegate: TeamsLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    public var sortedTeamListArray: [TeamDetailsDataModel] = [TeamDetailsDataModel]()
    public var teamMemberDetailsData: TeamDetailsDataModel?
    public var rolesListArray: [RoleDataModel] = [RoleDataModel]()
    public var selectedSortFilterId = "name"
    public var statusFilter = "live"
    
    //MARK:- Teams API Calls
    
    public func getTeamsList(websiteId: String?, sortId: String) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        self.selectedSortFilterId = sortId
        
        let objectHashMapData = [
            "ref": websiteId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "team", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: TeamsAPINames.teamsListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func getTeamsRolesList(websiteId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : websiteId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "team", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: TeamsAPINames.rolesListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func addNewTeamMember(websiteId: String?, signedUpEmail: String?, title: String?, role: String?, description: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref": signedUpEmail ?? "",
            "title": title ?? "",
            "role": role ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "team", strVerifyId: strId, strStatus: "queue", strOperation: "addNewTeamMember", strApiName: TeamsAPINames.newTeamMemberAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        //        sortedTeamListArray.insert(ComponentDetailsDataModel(created: FunctionsExtension.sharedInstance.getCurrentDate(), datastatus: "queue" , componentDefault: "no", description: description, id: strId, name: name, status: "", text: "", type: type, typename: "", updated: FunctionsExtension.sharedInstance.getCurrentDate()), at: 0)
        
        delegate?.addNewTeamMemberInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func getTeamDetails(websiteId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: websiteId ?? "", strObjType: "team", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: TeamsAPINames.teamsListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    public func deleteTeamMember(websiteId: String?, teamMemberId: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref" : teamMemberId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: teamMemberId ?? "", strObjType: "team", strVerifyId: strId, strStatus: "queue", strOperation: "deleteTeamMember", strApiName: TeamsAPINames.deleteTeamMemberAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedTeamListArray.firstIndex(where: {$0.id == teamMemberId}) {
            sortedTeamListArray[firstIndex].datastatus = "queue"
            delegate?.teamMemberStatusChangeForQueue(index: firstIndex)
        }
        
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editTeamMember(websiteId: String?, teamMemberId: String?, title: String?, roleId: String?, description: String?, roleName: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":teamMemberId ?? "",
            "title": title ?? "",
            "role": roleId ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "team", strVerifyId: strId, strStatus: "queue", strOperation: "editTeamMember", strApiName: TeamsAPINames.editTeamMemberAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = sortedTeamListArray.firstIndex(where: { $0.id == teamMemberId}) {
            sortedTeamListArray[firstIndex].description = description
            sortedTeamListArray[firstIndex].title = title
            sortedTeamListArray[firstIndex].description = description
            sortedTeamListArray[firstIndex].role = roleId
            sortedTeamListArray[firstIndex].rolename = roleName
            teamMemberDetailsData = sortedTeamListArray[firstIndex]
            delegate?.editTeamMemberInQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func addNewRole(websiteId: String?, name: String?, description: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref": websiteId ?? "",
            "name": name ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "role", strVerifyId: strId, strStatus: "queue", strOperation: "addNewRole", strApiName: TeamsAPINames.newRoleAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        rolesListArray.insert(RoleDataModel(description: description, id: strId, name: name, datastatus: "queue"), at: 0)
        
        delegate?.addNewRoleInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editRole(websiteId: String?, roleId: String?, description: String?, roleName: String?) {
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "website": websiteId ?? "",
            "ref":roleId ?? "",
            "name": roleName ?? "",
            "description": description ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "team", strVerifyId: strId, strStatus: "queue", strOperation: "editRole", strApiName: TeamsAPINames.editRoleAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = rolesListArray.firstIndex(where: { $0.id == roleId}) {
            rolesListArray[firstIndex].description = description
            rolesListArray[firstIndex].id = roleId
            rolesListArray[firstIndex].name = roleName
            delegate?.editRoleInQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
}

extension TeamsLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case TeamsAPINames.teamsListAPI.rawValue:
            handleResponseForTeamsList(responseDict: objResponseDict)
            
        case TeamsAPINames.newTeamMemberAPI.rawValue:
            handleResponseForAddNewTeamMember(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TeamsAPINames.editTeamMemberAPI.rawValue:
            handleResponseForEditTeamMember(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TeamsAPINames.deleteTeamMemberAPI.rawValue:
            handleResponseForDeleteTeamMember(responseDict: objResponseDict , objHeaderQueue: objHeaderQueue)
            
        case TeamsAPINames.rolesListAPI.rawValue:
            handleResponseForRolesList(responseDict: objResponseDict)
            
        case TeamsAPINames.newRoleAPI.rawValue:
            handleResponseForAddNewRole(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TeamsAPINames.editRoleAPI.rawValue:
            handleResponseForEditRole(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        default:
            break
        }
    }
    
    //MARK:- API's response
    
    func handleResponseForTeamsList(responseDict: NSDictionary) {
        sortedTeamListArray.removeAll()
        var teamsListModel = [TeamDetailsDataModel]()
        if responseDict.count > 0 {
            let teamsList = responseDict["list"] as? NSArray
            for teamDict in teamsList ?? [] {
                let team = teamDict as? NSDictionary
                
                let created = team?["created"] as? String
                let datastatus = team?["datastatus"] as? String
                let description = team?["description"] as? String
                let id = team?["id"] as? String
                let image = team?["image"] as? String
                let name = team?["name"] as? String
                let role = team?["role"] as? String
                let rolename = team?["rolename"] as? String
                let status = team?["status"] as? String
                let text = team?["text"] as? String
                let title = team?["title"] as? String
                
                teamsListModel.append(TeamDetailsDataModel(created: created, datastatus: datastatus, description: description, id: id, image: image, name: name, role: role, rolename: rolename, status: status, text: text, title: title))
            }
            
            if !teamsListModel.isEmpty {
                switch selectedSortFilterId {
                case "name":
                    sortedTeamListArray = teamsListModel.sorted(by: {($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "")})
                case "role":
                    sortedTeamListArray = teamsListModel.sorted(by: {($0.role ?? "") < ($1.role ?? "")})
                case "description":
                    sortedTeamListArray = teamsListModel.sorted(by: {($0.description ?? "") < ($1.description ?? "")})
                case "status":
                    sortedTeamListArray = teamsListModel.sorted(by: {($0.datastatus ?? "") < ($1.datastatus ?? "")})
                default: break
                }
            } else {
                sortedTeamListArray = []
            }
            delegate?.getTeamsListFromResponse()
            
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForAddNewTeamMember(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int ?? 0
            let datastatus = responseDict["datastatus"] as? String
            let id = responseDict["id"] as? String
            if let firstIndex = sortedTeamListArray.firstIndex(where: {$0.id == objHeaderQueue.strObjectId}) {
                if status == 1 {
                    sortedTeamListArray[firstIndex].id = id
                    sortedTeamListArray[firstIndex].datastatus = datastatus
                } else {
                    sortedTeamListArray.remove(at: firstIndex)
                }
                delegate?.updateAddTeamMemberSuccess(status: status, index: firstIndex)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForDeleteTeamMember(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let id = objHeaderQueue.strObjectId ?? ""
        if let firstIndex = sortedTeamListArray.firstIndex(where: {$0.id == id}) {
            if status == 1 {
                sortedTeamListArray.remove(at: firstIndex)
            } else {
                sortedTeamListArray[firstIndex].datastatus = "error"
            }
            delegate?.updateDeleteTeamMemberSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForEditTeamMember(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        
        if status == 1 {
            if let firstIndex = sortedTeamListArray.firstIndex(where: { $0.id == id}) {
                if statusFilter == dataStatus || statusFilter == "live" {
                    sortedTeamListArray[firstIndex].datastatus = dataStatus
                }else{
                    sortedTeamListArray.remove(at: firstIndex)
                }
                teamMemberDetailsData = sortedTeamListArray[firstIndex]
                delegate?.updateEditTeamMember(index: firstIndex, dataStatus: dataStatus)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForRolesList(responseDict: NSDictionary) {
        rolesListArray.removeAll()
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int
            if status == 1 {
                let types = responseDict["roles"] as? NSArray
                
                for type in types ?? []{
                    let obj = type as? NSDictionary
                    let description = obj?["description"] as? String ?? ""
                    let id = obj?["id"] as? String ?? ""
                    let name = obj?["name"] as? String ?? ""
                    rolesListArray.append(RoleDataModel(description: description, id: id, name: name, datastatus: "live"))
                }
                delegate?.getRolesListFromResponse()
            } else {
                delegate?.getRolesListFromResponse()
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForAddNewRole(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int ?? 0
            let datastatus = responseDict["datastatus"] as? String
            let id = responseDict["id"] as? String
            if let firstIndex = rolesListArray.firstIndex(where: {$0.id == objHeaderQueue.strObjectId}) {
                if status == 1 {
                    rolesListArray[firstIndex].id = id
                    rolesListArray[firstIndex].datastatus = datastatus
                } else {
                    rolesListArray.remove(at: firstIndex)
                }
                delegate?.updateAddTeamMemberSuccess(status: status, index: firstIndex)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForEditRole(responseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        let id = objHeaderQueue.objHashMapData?["ref"] as? String ?? ""
        
        if status == 1 {
            if let firstIndex = rolesListArray.firstIndex(where: { $0.id == id}) {
                if statusFilter == dataStatus || statusFilter == "live" {
                    rolesListArray[firstIndex].datastatus = dataStatus
                }else{
                    rolesListArray.remove(at: firstIndex)
                }
//                teamMemberDetailsData = sortedTeamListArray[firstIndex]
                delegate?.updateEditRole(index: firstIndex, dataStatus: dataStatus)
            }
        }else{
            delegate?.showPoorInternet()
        }
    }
}
