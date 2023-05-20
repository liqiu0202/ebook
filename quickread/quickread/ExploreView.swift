import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()

    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText)
            // search result section
            List(viewModel.bookPreviews) { bookPreview in
                BookPreviewView(bookPreview: bookPreview)
            }
        }
        .navigationBarTitle("Explore")
    }
}

struct ExploreTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExploreView()
        }
    }
}
