//
//  SceneDelegate.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 1/28/24.
//

import Combine
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var cancellables = Set<AnyCancellable>()
    var navigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let locationListViewModel = LocationListViewModel()
        locationListViewModel.interactionPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] interaction in
                guard let self else { return }
                switch interaction {
                case .navigateToMenuDetail(let menuResponse):
                    let hostingController = UIHostingController(rootView: RestaurantMenuListView(viewModel: locationListViewModel, menu: menuResponse))
                    navigationController?.pushViewController(hostingController, animated: true)
                case .navigateToRestaurantList(let address):
                    let hostingController = UIHostingController(rootView: RestaurantListView(viewModel: locationListViewModel, selectedAddress: address))
                    navigationController?.pushViewController(hostingController, animated: true)
                case .navigateToProductList(let category):
                    let hostingController = UIHostingController(rootView: RestaurantDetailListView(viewModel: locationListViewModel, selectedCategory: category))
                    navigationController?.pushViewController(hostingController, animated: true)
                }
            }
            .store(in: &cancellables)
        let hostingController = UIHostingController(rootView: LocationListView(viewModel: locationListViewModel))
        navigationController = UINavigationController(rootViewController: hostingController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

