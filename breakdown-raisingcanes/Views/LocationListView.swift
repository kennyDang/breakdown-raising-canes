//
//  LocationListView.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 1/28/24.
//

import SwiftUI

struct LocationListView: View {
    @ObservedObject var viewModel: LocationListViewModel
    
    var body: some View {
        VStack {
            TextField(
                "Enter a location",
                text: $viewModel.locationText
            )
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.secondary)
            Spacer()
            List(viewModel.locationRestaurants) { location in
                LocationListItemView(locationRestaurant: location)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.navigateToRestaurantListWith(address: location.address)
                    }
            }
        }
        .padding()
    }
}

struct LocationListItemView: View {
    var locationRestaurant: LocationAddress
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(locationRestaurant.address.formattedAddress)
        }
    }
}
