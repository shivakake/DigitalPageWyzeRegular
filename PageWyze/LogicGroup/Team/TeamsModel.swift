//
//  TeamsModel.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 01/04/23.
//

import Foundation

public struct TeamDetailsDataModel {
    
    public var created: String?
    public var datastatus: String?
    public var description: String?
    public var id: String?
    public var image: String?
    public var name: String?
    public var role: String?
    public var rolename: String?
    public var status: String?
    public var text: String?
    public var title: String?
    
    init(created: String?, datastatus: String?, description: String?, id: String?, image: String?, name: String?, role: String?, rolename: String?, status: String?, text: String?, title: String?) {
        self.created = created
        self.datastatus = datastatus
        self.description = description
        self.id = id
        self.image = image
        self.name = name
        self.role = role
        self.rolename = rolename
        self.status = name
        self.text = text
        self.title = title
    }
}

public struct RoleDataModel {
    
    public var description: String?
    public var id: String?
    public var name: String?
    public var datastatus: String?
    
    init(description: String?, id: String?, name: String?, datastatus: String?) {
        self.description = description
        self.id = id
        self.name = name
        self.datastatus = datastatus
    }
}
