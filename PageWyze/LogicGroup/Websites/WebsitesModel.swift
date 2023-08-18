//
//  WebsitesModel.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 18/01/23.
//

import Foundation

public struct TypesDataModel {
    
    public var id: String?
    public var key: String?
    public var name: String?
    public var pagecount: String?
    
    init(id: String?, key: String?, name: String?, pagecount: String?) {
        self.id = id
        self.key = key
        self.name = name
        self.pagecount = pagecount
    }
}

public struct WebsiteDetailsDataModel {
    
    public var category: String?
    public var categoryname: String?
    public var components: String?
    public var copyright: String?
    public var created: String?
    public var datastatus: String?
    public var description: String?
    public var domain: String?
    public var domainname: String?
    public var favicon: String?
    public var faviconname: String?
    public var faviconurl: String?
    public var id: String?
    public var language: String?
    public var languagename: String?
    public var livestatus: String?
    public var logo: String?
    public var logoname: String?
    public var logourl: String?
    public var messages: String?
    public var name: String?
    public var pagedata: [PageDataModel]?
    public var secure: String?
    public var status: String?
    public var test: String?
    public var type: String?
    public var typename: String?
    public var updated: String?
    public var url: String?
    public var www: String?
    
    init(category: String?, categoryname: String?, components: String?, copyright: String?, created: String?, datastatus: String?, description: String?, domain: String?, domainname: String?, favicon: String?, faviconname: String?, faviconurl: String?, id: String?, language: String?, languagename: String?, livestatus: String?, logo: String?, logoname: String?, logourl: String?, messages: String?, name: String?, pagedata: [PageDataModel]?, secure: String?, status: String?, test: String?, type: String?, typename: String?, updated: String?, url: String?, www: String?) {
        
        self.category = category
        self.categoryname = categoryname
        self.components = components
        self.copyright = copyright
        self.created = created
        self.datastatus = datastatus
        self.description = description
        self.domain = domain
        self.domainname = domainname
        self.favicon = favicon
        self.faviconname = faviconname
        self.faviconurl = faviconurl
        self.id = id
        self.language = language
        self.languagename = languagename
        self.livestatus = livestatus
        self.logo = logo
        self.logoname = logoname
        self.logourl = logourl
        self.messages = messages
        self.name = name
        self.pagedata = pagedata
        self.secure = secure
        self.status = status
        self.test = test
        self.type = type
        self.typename = typename
        self.updated = updated
        self.url = url
        self.www = www
    }
}

public struct PageDataModel : Codable {
    
    public var name: String?
    public var key: String?
    public var length: String?
    
    init(name: String?, key: String?, length: String?) {
        self.name = name
        self.key = key
        self.length = length
    }
}

public struct StatisticsDataModel {
    
    public var name: String?
    public var value: String?
    
    init(name: String?, value: String?) {
        self.name = name
        self.value = value
    }
}

public struct WebsiteFileDataModel {
    
    public var datastatus: String?
    public var description: String?
    public var filename: String?
    public var filesize: String?
    public var filetype: String?
    public var group: String?
    public var groupname: String?
    public var id: String?
    public var name: String?
    public var type: String?
    public var updated: String?
    
    init(datastatus: String?, description: String?, filename: String?, filesize: String?, filetype: String?, group: String?, groupname: String?, id: String?, name: String?, type: String?, updated: String?) {
        
        self.datastatus = datastatus
        self.description = description
        self.filename = filename
        self.filesize = filesize
        self.filetype = filetype
        self.group = group
        self.groupname = groupname
        self.id = id
        self.name = name
        self.type = type
        self.updated = updated
    }
}

public struct WebsiteGroupDataModel {
    
    public var created: String?
    public var datastatus: String?
    public var description: String?
    public var directory: String?
    public var id: String?
    public var key: String?
    public var name: String?
    public var updated: String?
    
    init(created: String?, datastatus: String?, description: String?, directory: String?, id: String?, key: String?, name: String?, updated: String?) {
        self.created = created
        self.datastatus = datastatus
        self.description = description
        self.directory = directory
        self.id = id
        self.key = key
        self.name = name
        self.updated = updated
    }
}
