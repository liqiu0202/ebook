import SwiftUI
import Combine

class ExploreViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isSearching = false
    @Published var bookPreviews: [BookPreview] = []
    
    let bookManager = BookManager.shared // Declare a constant property

    func updateBookPreviews() {
        if searchText.isEmpty {
            // TODO(liq) replace this with default recommended book list
            bookPreviews = []
        } else {
            bookManager.findMatches(searchText) { matchedBooks in
                self.bookPreviews = matchedBooks
            }
        }
    }
}
