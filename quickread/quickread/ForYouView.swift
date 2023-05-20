//
//  ForYouView.swift
//  quickread
//
//  Created by Li Qiu on 4/29/23.
//

import SwiftUI

struct ForYouView: View {
    @ObservedObject var viewModel = ForYouViewModel()
    @State private var isSearching = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: ExploreView(),
                    isActive: $isSearching,
                    label: {
                        SearchButtonView()
                    }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(viewModel.bookPreviews, id: \.id) { bookPreview in
                            BookPreviewView(bookPreview: bookPreview)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    viewModel.fetchRecommendations()
                }
            }
            .navigationBarTitle("For You")
        }
    }
}



struct ForYouTabView_Previews: PreviewProvider {
    static var previews: some View {
        ForYouView()
    }
}
