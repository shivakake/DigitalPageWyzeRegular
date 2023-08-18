//
//  PagesModel.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 16/02/23.
//

import Foundation

public struct PageDetailsDataModel {
    
    public var canonical: String?
    public var components: String?
    public var created: String?
    public var data: [PageDataListModel]?
    public var datastatus: String?
    public var description: String?
    public var head: String?
    public var id: String?
    public var key: String?
    public var messages: String?
    public var metadescription: String?
    public var metatitle: String?
    public var name: String?
    public var status: String?
    public var text: String?
    public var type: String?
    public var typename: String?
    public var updated: String?
    public var url: String?
    
    init(canonical: String?, components: String?, created: String?, data: [PageDataListModel]?, datastatus: String?, description: String?, head: String?, id: String?, key: String?, messages: String?, metadescription: String?, metatitle: String?, name: String?, status: String?, text: String?, type: String?, typename: String?, updated: String?, url: String?) {
        self.canonical = canonical
        self.components = components
        self.created = created
        self.data = data
        self.datastatus = datastatus
        self.description = description
        self.head = head
        self.id = id
        self.key = key
        self.messages = messages
        self.metadescription = metadescription
        self.metatitle = metatitle
        self.name = name
        self.status = status
        self.text = text
        self.type = type
        self.typename = typename
        self.updated = updated
        self.url = url
    }
}

public class PageComponentDetailsModel {
    
    public var name: String?
    public var id: String?
    public var key: String?
    public var pagecount: String?
    public var items: [PageComponentsItemModel]?
    public var selectedId : String?
    public var selectedName: String?
    
    init(name: String?, id: String?, key: String?, pagecount: String?, items: [PageComponentsItemModel]?, selectedId: String?) {
        self.name = name
        self.id = id
        self.key = key
        self.pagecount = pagecount
        self.items = items
        self.selectedId = selectedId
    }
}

public struct PageComponentsItemModel: Codable {
    
    public var datastatus: String?
    public var componentDefault: String?
    public var description: String?
    public var id: String?
    public var name: String?
    public var status: String?
    public var type: String?
    public var updated: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, name, description
        case componentDefault = "default"
        case updated, datastatus, status
    }
    
    init(datastatus: String?, componentDefault: String?, description: String?, id: String?, name: String?, status: String?, type: String?, updated: String?) {
        self.datastatus = datastatus
        self.componentDefault = componentDefault
        self.description = description
        self.id = id
        self.name = name
        self.status = status
        self.type = type
        self.updated = updated
    }
}

public struct PageDataListModel {
    
    public var keyString: String?
    public var valueString: String?
    
    init(key: String? , value: String?) {
        self.keyString = key
        self.valueString = value
    }
}
