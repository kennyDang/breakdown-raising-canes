//
//  LocationAddress.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 2/3/24.
//

import Foundation

struct LocationAddress: Identifiable {
    var id: String = UUID().uuidString
    
    var address: Address
}
