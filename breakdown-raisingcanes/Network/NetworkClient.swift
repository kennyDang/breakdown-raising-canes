//
//  NetworkClient.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 1/28/24.
//

import Combine
import Foundation

final class NetworkClient {
    private var cancellables = Set<AnyCancellable>()
    private let urlSession = URLSession.shared
    
    func searchForNearestNomNoms(location: String) async -> LocationAddressResponse? {
        let baseURL = Endpoint.restaurantLocator.url
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "query", value: location),
            URLQueryItem(name: "layers", value: EndpointQuery.layers)
        ]
        guard let url = urlComponents?.url else {
            return nil
        }
        let request = URLRequest(url: url)
        return await withCheckedContinuation { continuation in
            let task = urlSession.dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(returning: .none)
                    return
                }
                guard let data = data else {
                    continuation.resume(returning: .none)
                    return
                }
                let jsonDecoder = JSONDecoder()
                guard let locationRestaurantResponse = try? jsonDecoder.decode(LocationAddressResponse.self, from: data) else {
                    continuation.resume(returning: .none)
                    return
                }
                continuation.resume(with: .success(locationRestaurantResponse))
            }
            task.resume()
        }
    }
    
    func searchForAddressesWithPublisher(location: String) -> AnyPublisher<LocationAddressResponse, Error> {
        let baseURL = Endpoint.restaurantLocator.url
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "query", value: location),
            URLQueryItem(name: "layers", value: EndpointQuery.layers)
        ]
        let request = URLRequest(url: urlComponents!.url!)
        return urlSession.dataTaskPublisher(for: request.url!)
                .map({
                    $0.data
                })
                .decode(type: LocationAddressResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
    
    func searchForNearestNomNomsWithPublisher(lat: Double, long: Double, radius: CGFloat = 20) -> AnyPublisher<RestaurantResponse, Error> {
        let baseURL = Endpoint.restaurants.url
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "long", value: String(long)),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "limit", value: "\(30)"),
        ]
        let request = URLRequest(url: urlComponents!.url!)
        return urlSession.dataTaskPublisher(for: request.url!)
                .print()
                .map({
                    $0.data
                })
                .decode(type: RestaurantResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
    
    func fetchMenuFor(restaurantID: String) -> AnyPublisher<RestaurantMenuNetworkResponse, Error> {
        let baseURL = Endpoint.menu.url.appending(path: "\(restaurantID)/menu")
        return urlSession.dataTaskPublisher(for: baseURL)
                .print()
                .map({
                    $0.data
                })
                .decode(type: RestaurantMenuNetworkResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
}

extension NetworkClient {
    enum Endpoint: String {
        case restaurantLocator = "https://nomnom-prod-api.raisingcanes.com/radar/autocomplete"
        // https://nomnom-prod-api.raisingcanes.com/restaurants/near?lat=34.05513&long=-118.25703&radius=20&limit=30&nomnom=calendars&nomnom_calendars_from=20240202&nomnom_calendars_to=20240213&nomnom_exclude_extref=
        case restaurants = "https://nomnom-prod-api.raisingcanes.com/restaurants/near"
        // https://nomnom-prod-api.raisingcanes.com/restaurants/139247/menu?nomnom=add-restaurant-to-menu
        case menu = "https://nomnom-prod-api.raisingcanes.com/restaurants"
        case productImage = "https://olo-images-live.imgix.net"
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    struct EndpointQuery {
       static let layers = "postalCode,street,address,state,locality,county,neighborhood"
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}
