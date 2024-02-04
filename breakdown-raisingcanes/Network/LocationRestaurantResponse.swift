//
//  LocationAddressResponse.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 1/28/24.
//

import Foundation

struct LocationAddressResponse: Codable {
    let meta: Meta
    let addresses: [Address]
}

// MARK: - Address
struct Address: Codable {
    let latitude, longitude: Double
    let geometry: Geometry
    let country, countryCode, countryFlag, county: String
    let distance: Int
    let city, stateCode, state, layer: String
    let formattedAddress, addressLabel: String
    let postalCode, street, number: String?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - Meta
struct Meta: Codable {
    let code: Int
}
