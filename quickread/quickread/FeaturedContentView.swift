import SwiftUI


struct FeaturedContentView: View {
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
