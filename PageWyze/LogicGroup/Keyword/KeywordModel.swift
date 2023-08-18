//
//  KeywordModel.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 05/04/23.
//

import Foundation

public struct KeywordDetailsDataModel {
    
    public var created: String?
    public var datastatus: String?
    public var description: String?
    public var id: String?
    public var name: String?
    public var updated: String?
    public var pages: [[String: Any]]?
    
    init(created: String?, datastatus: String?, description: String?, id: String?, name: String?, updated: String?, pages: [[String: Any]]?) {
        self.created = created
        self.datastatus = datastatus
        self.description = description
        self.id = id
        self.name = name
        self.updated = updated
        self.pages = pages
    }
}
