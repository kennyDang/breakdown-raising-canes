//
//  RestaurantMenuListView.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 2/3/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantMenuListView: View {
    @ObservedObject var viewModel: LocationListViewModel
    var menu: RestaurantMenuNetworkResponse
    
    var body: some View {
        List(viewModel.menuCategories) { category in
            RestaurantMenuListItemView(category: category)
                .onTapGesture {
                    viewModel.navigateToProductList(category: category)
                }
        }
    }
}

struct RestaurantMenuListItemView: View {
    var category: Category
    
    var body: some View {
        VStack {
            if let image = category.images?.first(where: { $0.groupname == .mobileApp }) {
                WebImage(url: image.imageURL)
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(category.name)
                Text(category.description ?? "")
            }
        }
    }
}
