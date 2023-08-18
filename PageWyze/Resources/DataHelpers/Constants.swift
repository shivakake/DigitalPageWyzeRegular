//
//  Constants.swift
//  WebSites
//
//  Created by PGK Shiva Kumar on 30/12/22.
//

import Foundation

enum ViewMode {
    
    case grid
    case list
    case file
}

let statusArray = [PopUpMenuItemModel(strMenuID: "live", menuName: "Live", menuImage: "live"),
                   PopUpMenuItemModel(strMenuID: "draft", menuName: "Draft", menuImage: "drafts"),
                   PopUpMenuItemModel(strMenuID: "active", menuName: "Active", menuImage: "active"),
                   PopUpMenuItemModel(strMenuID: "complete", menuName: "Complete", menuImage: "completes"),
                   PopUpMenuItemModel(strMenuID: "inactive", menuName: "Inactive", menuImage: "inactive")]

let sortArray = [PopUpMenuItemModel(strMenuID: "name", menuName: "Name", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "type", menuName: "Type", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "url", menuName: "URL", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "date", menuName: "Date", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "status", menuName: "Status", menuImage: "")]

let componentSortArray = [PopUpMenuItemModel(strMenuID: "name", menuName: "Name", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "type", menuName: "Type", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "date", menuName: "Date", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "status", menuName: "Status", menuImage: "")]

let teamSortArray = [PopUpMenuItemModel(strMenuID: "name", menuName: "Name", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "role", menuName: "Role", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "description", menuName: "Description", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "status", menuName: "Status", menuImage: "")]

let keywordSortArray = [PopUpMenuItemModel(strMenuID: "name", menuName: "Name", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "date", menuName: "Date", menuImage: ""),
                 PopUpMenuItemModel(strMenuID: "status", menuName: "Status", menuImage: "")]
