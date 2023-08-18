//
//  AnalyticsModel.swift
//  PageWyze
//
//  Created by PGK Shiva Kumar on 07/04/23.
//

import Foundation

public struct AnalyticDetailsDataModel {
    
    public var id: String?
    public var name: String?
    public var url: String?
    public var views: String?
    
    init(id: String?, name: String?, url: String?, views: String?) {
        self.id = id
        self.name = name
        self.url = url
        self.views = views
    }
}
