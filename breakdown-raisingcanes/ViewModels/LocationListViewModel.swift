//
//  LocationListViewModel.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 1/28/24.
//

import Foundation
import Combine
import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

final class LocationListViewModel: ObservableObject {
    @Published var locationText: String = "" {
        didSet {
            validateLocationAndSearch()
        }
    }
    @Published var locationRestaurants: [LocationAddress] = []
    @Published var restaurants: [Restaurant] = []
    @Published var menuCategories: [Category] = []
    
    let networkClient = NetworkClient()
    private var cancellables = Set<AnyCancellable>()
    
    var interactionPublisher = PassthroughSubject<Interaction, Never>()
    
    func validateLocationAndSearch() {
        guard locationText.count > 3 else { return }        
        let publisher = networkClient.searchForAddressesWithPublisher(location: locationText)
            
        publisher.receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.locationRestaurants = response.addresses.compactMap({
                    LocationAddress(address: $0)
                })
            }
            .store(in: &cancellables)
    }
    
    func navigateToRestaurantListWith(address: Address) {
        interactionPublisher.send(.navigateToRestaurantList(address))        
    }
    
    func searchForNomNomsAt(_ address: Address) {
        let publisher = networkClient.searchForNearestNomNomsWithPublisher(lat: address.latitude, long: address.longitude)
            
        publisher.receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.restaurants = response.restaurants
            }
            .store(in: &cancellables)
    }
    
    func fetchMenu(restaurant: Restaurant) {
        let publisher = networkClient.fetchMenuFor(restaurantID: String(restaurant.id))
            
        publisher.receive(on: DispatchQueue.main)
            .sink { status in
                print("kd status \(status)")
            } receiveValue: { [weak self] response in
                guard let self else { return }
                menuCategories = response.categories
                interactionPublisher.send(.navigateToMenuDetail(response))
            }
            .store(in: &cancellables)
    }
    
    func navigateToProductList(category: Category) {
        interactionPublisher.send(.navigateToProductList(category))
    }
    
}

extension LocationListViewModel {
    enum Interaction {
        case navigateToRestaurantList(Address)
        case navigateToMenuDetail(RestaurantMenuNetworkResponse)
        case navigateToProductList(Category)
    }
}
