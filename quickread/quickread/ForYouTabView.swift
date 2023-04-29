//
//  ForYouView.swift
//  quickread
//
//  Created by Li Qiu on 4/29/23.
//

import SwiftUI

struct ForYouTabView: View {
    @ObservedObject var viewModel = FeaturedContentViewModel()

    var body: some View {
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
}

struct ForYouTabView_Previews: PreviewProvider {
    static var previews: some View {
        ForYouTabView()
    }
}
