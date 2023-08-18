//
//  ComponentsModel.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 30/03/23.
//

import Foundation

public struct ComponentDetailsDataModel {
    
    public var created: String?
    public var datastatus: String?
    public var componentDefault: String?
    public var description: String?
    public var id: String?
    public var name: String?
    public var status: String?
    public var text: String?
    public var type: String?
    public var typename: String?
    public var updated: String?
    
    enum CodingKeys: String, CodingKey {
        case componentDefault = "default"
    }
    
    init(created: String?, datastatus: String?, componentDefault: String?, description: String?, id: String?, name: String?, status: String?, text: String?, type: String?, typename: String?, updated: String?) {
        self.created = created
        self.datastatus = datastatus
        self.componentDefault = componentDefault
        self.description = description
        self.id = id
        self.name = name
        self.status = status
        self.text = text
        self.type = type
        self.typename = typename
        self.updated = updated
    }
}
