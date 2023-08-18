//
//  WenoiVisualPanelModel.swift
//  WenoiUI
//
//  Created by Roushil singla on 9/29/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

public struct WenoiVisualPanelModel {
    
    var strId: String?
    var strTitle: String?
    var strImage: String?
    var blIsSelected: Bool?
    
    public init(id: String?, title: String?, image: String?, isSelected: Bool?) {
        strId           = id
        strTitle        = title
        strImage        = image
        blIsSelected    = isSelected
    }
    
    public init(country: CountryViewModel) {
        strId       = country.strCountryId
        strTitle    = country.strName
    }
    
    public init(language: (String, Any)) {
        strId       = language.0
        strTitle    = language.1 as? String
    }
}

public class CountryViewModel: NSObject {
    
    private var countryModel: CountryModel
    
    public var strCountryId: String? {
        return countryModel.strCountryId
    }
    
    public var strName: String? {
        return countryModel.strName
    }
    
    public var strId: String? {
        return countryModel.strId
    }
    
    //this model will now be exposed to viewcontroller to be used
   public init(model: CountryModel) {
        self.countryModel = model
    }
}


public class CountryModel: NSObject {
    
    var strCountryId    : String?
    var strName         : String?
    var strId           : String?
    var strVerifyId     : String?
    var strDataStatus   : String?
    var strCreatedDate  : String?
    var strUpdatedDate  : String?
    var strOperation    : String?
    var strQueueStatus  : String?
    
    convenience init(id: String, name: String) {
        self.init()
        strCountryId = id
        strName      = name
    }
    
    public class func initModelWithResponse(res: [String : Any]) -> [CountryModel] {
        
        var listData    = [CountryModel]()
        if let data     = res["countries"] as? [String: String] {
            for (key, value) in data  {
                listData.append(CountryModel(id: key, name: value))
            }
        }
        return listData
    }
}
