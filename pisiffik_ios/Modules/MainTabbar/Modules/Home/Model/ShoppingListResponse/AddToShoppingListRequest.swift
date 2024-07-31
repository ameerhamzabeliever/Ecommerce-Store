//
//  AddToShoppingListRequest.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

struct AddToShoppingProductRequest: Codable{
    
    var products : [AddToShoppingListRequest]
    
    enum CodingKeys: String, CodingKey{
        case products
    }
    
}

struct AddToShoppingListRequest: Codable{
    
    var recipeID : Int
    var variantID : Int
    var uomQuantity : Int
    
    enum CodingKeys: String, CodingKey{
        case recipeID = "recipe_id"
        case variantID = "variant_id"
        case uomQuantity = "uom_quantity"
    }
    
}

//MARK: - ADD PISIFFIK PRODUCTS TO SHOPPING LIST RESPONSE -

struct AddPisiffikProductToShoppingResponse: Codable{
    
    var code : Int?
    var message : String?
    var data : AddPisiffikProductToShoppingResponseData?
    var error : [String]?
    
}

struct AddPisiffikProductToShoppingResponseData: Codable{
    
    var totalQuantity : Int
    
    enum CodingKeys: String, CodingKey{
        case totalQuantity = "total_quantity"
    }
    
}

struct AddPisiffikProductToCartRequest: Codable{
    
    var products : [AddPisiffikProductRequest]
    
    enum CodingKeys: String, CodingKey{
        case products
    }
    
}

struct AddPisiffikProductRequest: Codable{
    
    var variantID : Int
    var offerItemID: Int
    var uomQuantity : Int
    
    enum CodingKeys: String, CodingKey{
        case variantID = "variant_id"
        case offerItemID = "offer_item_id"
        case uomQuantity = "uom_quantity"
    }
    
}


struct RemoveProductRequest: Codable{
    
    var variantID : Int
    
    enum CodingKeys: String, CodingKey{
        case variantID = "variant_id"
    }
}

struct ModifyProductRequest: Codable{
    
    var modifyType : Int
    var variantID : Int
    
    enum CodingKeys: String, CodingKey{
        case modifyType
        case variantID = "variant_id"
    }
}
