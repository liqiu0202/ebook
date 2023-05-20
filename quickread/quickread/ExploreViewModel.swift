import SwiftUI
import Combine

class ExploreViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isSearching = false
    @Published var bookPreviews: [BookPreview] = []
    
    let bookManager = BookManager.shared
    private var cancellables: Set<AnyCancellable> = []  // Keep reference to your pipeline

    init() {
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)  // delay of 0.5 seconds
            .sink(receiveValue: searchBooks(_:))  // use the searchBooks function when new value is emitted
            .store(in: &cancellables)  // retain cancellable
    }
    
    private func searchBooks(_ query: String) {
        if query.isEmpty {
            // TODO(liq) replace this with default recommended book list
            bookPreviews = []
        } else {
            print(searchText)
            bookManager.findMatches(query) { matchedBooks in
                DispatchQueue.main.async {
                    self.bookPreviews = matchedBooks
                }
            }
        }
    }
}
