//
//  RestaurantDetailListView.swift
//  breakdown-raisingcanes
//
//  Created by Kenny Dang on 2/4/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantDetailListView: View {
    @ObservedObject var viewModel: LocationListViewModel
    var selectedCategory: Category
    var body: some View {
        List(selectedCategory.products) { product in
            RestaurantDetailListItemView(product: product)
        }
    }
    
}

struct RestaurantDetailListItemView: View {
    var product: Product
    
    var body: some View {
        VStack {
            if let image = product.images?.first(where: { $0.groupname == .mobileApp }) {
                WebImage(url: image.imageURL)
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(product.name)
                Text(product.description)
            }
        }
    }
}

