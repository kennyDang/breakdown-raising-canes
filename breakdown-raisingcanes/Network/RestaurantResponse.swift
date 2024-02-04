//
//  RestaurantResponse.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 2/3/24.
//

import Foundation

//struct RestaurantResponse: Codable {
//    let restaurants: [Restaurant]
//}
//
//// MARK: - Restaurant
//struct Restaurant: Codable, Identifiable {
//    let createdAt, updatedAt, openingDate, city: String
//    let country: String
//    let id: Int
//    let isavailable: Bool
//    let latitude, longitude: Double
//    let name, slug, state, storename: String
//    let streetaddress, zip: String
//}


struct RestaurantResponse: Codable {
    let restaurants: [Restaurant]
}

struct RestaurantNetworkResponse: Codable {
    let restaurants: [Restaurant]
}

// MARK: - Restaurant
struct Restaurant: Codable, Identifiable {
    let createdAt, updatedAt, openingDate, city: String
    let country: String
    let id: Int
    let isavailable: Bool
    let latitude, longitude: Double
    let name, slug, state, storename: String
    let streetaddress, zip: String
}
