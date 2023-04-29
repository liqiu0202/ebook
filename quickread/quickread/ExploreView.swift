import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $viewModel.searchText)
                    .onChange(of: viewModel.searchText, perform: { value in
                        viewModel.isSearching = !value.isEmpty
                        viewModel.updateBookPreviews()
                    })

                List(viewModel.bookPreviews) { bookPreview in
                    BookPreviewView(bookPreview: bookPreview)
                }
            }
            .navigationTitle("Explore")
        }
    }
}

struct ExploreTabView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
