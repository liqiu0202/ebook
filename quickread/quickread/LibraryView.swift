import SwiftUI

struct LibraryView: View {
    let bookManager = BookManager.shared
    @State private var bookPreviews: [BookPreview] = []
    
    // TODO(liq) replace this api with real aws endpoint
    let url = URL(string: "https://kv7vei147a.execute-api.us-east-1.amazonaws.com/default/book_recommendation")!

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("My History")) {
                    ForEach(bookPreviews) { bookPreview in
                        BookPreviewView(bookPreview: bookPreview)
                            .environmentObject(bookManager)
                    }
                }
            }
            .navigationBarTitle("Library")
            .listStyle(GroupedListStyle())
            .onAppear {
                bookManager.fetchLibrary("[todo] replace this") { matchedBooks in
                    DispatchQueue.main.async {
                        self.bookPreviews = matchedBooks
                    }
                }

            }
        }
    }
}


struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
