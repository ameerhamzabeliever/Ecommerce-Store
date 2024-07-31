//
//  ShoppingListResponse.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

// MARK: - ShoppingListResponse -

struct ShoppingListResponse: Codable {
    var code : Int?
    var message : String?
    var data : ShoppingListResponseData?
    var error : [String]?
}


// MARK: - ShoppingListResponse -

struct ShoppingListResponseData: Codable {
    var earnablePoints: Int?
    var shoppingList: [ShoppingList]?

    enum CodingKeys: String, CodingKey {
        case earnablePoints = "earnable_points"
        case shoppingList = "shopping_list"
    }
}

// MARK: - ShoppingList
struct ShoppingList: Codable {
    var variantID, productID: Int?
    var name, image, uom: String?
    var uomQuantity: Int?
    var shoppingListProductQuantity: Int?
    var price, currency: String?
    var afterDiscountPrice: String?
    var isMember : Int?
    
    enum CodingKeys: String, CodingKey {
        case variantID = "variant_id"
        case productID = "product_id"
        case name, image, uom
        case uomQuantity = "uom_quantity"
        case shoppingListProductQuantity, price, currency
        case afterDiscountPrice = "after_discount_price"
        case isMember = "is_member"
    }
}



//MARK: - REMOVE ONE PRODUCT RESPONSE -

struct RemoveProductResponse: Codable {
    var code : Int?
    var message : String?
    var data : RemoveProductResponseData?
    var error : [String]?
}

struct RemoveProductResponseData: Codable {
    var earnPoints : Int
    var totalQuantity : Int
    enum CodingKeys: String, CodingKey{
        case earnPoints = "earnable_points"
        case totalQuantity = "total_quantity"
    }
}


//MARK: - PRODUCT MODIFY RESPONSE -

struct ModifyProductResponse: Codable{
    var code : Int?
    var message : String?
    var data : ModifyProductResponseData?
    var error : [String]?
}

struct ModifyProductResponseData: Codable {
    var totalQuantity : Int
    var newQuantity : Int
    enum CodingKeys: String, CodingKey{
        case totalQuantity = "total_quantity"
        case newQuantity = "new_quantity"
    }
}
