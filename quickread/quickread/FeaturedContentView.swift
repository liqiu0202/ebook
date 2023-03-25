import SwiftUI

struct FeaturedContent: Identifiable {
    let id: String
    let title: String
    let authors: [String]
    let previewLink: String
}

struct FeaturedContentView: View {
    let featuredBooks: [Book] = [
        Book(id: 1, title: "乌合之众", author: "Author 1", epubFilePath: "the_crowd", shouldHideNavigationOnTap: true, scrollDirection: .horizontal),
        // Add more books here
        Book(id: 2, title: "乌合之众2", author: "Author 2", epubFilePath: "the_crowd", shouldHideNavigationOnTap: true, scrollDirection: .horizontal),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Featured Content")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(featuredBooks) { book in
                        // Create a custom BookView for each book
                        BookView(book: book)
                    }
                }
            }
        }
    }
}
