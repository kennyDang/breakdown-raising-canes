//
//  RestaurantListView.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 2/3/24.
//

import SwiftUI

struct RestaurantListView: View {
    @ObservedObject var viewModel: LocationListViewModel
    var selectedAddress: Address
    
    var body: some View {
        List(viewModel.restaurants) { restaurant in
            RestaurantListItemView(restaurant: restaurant)
            .onTapGesture {
                viewModel.fetchMenu(restaurant: restaurant)
            }
        }
        .onAppear {
            viewModel.searchForNomNomsAt(selectedAddress)
        }
    }
}

struct RestaurantListItemView: View {
    var restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(restaurant.name)
            Text(restaurant.streetaddress)
        }
    }
}
