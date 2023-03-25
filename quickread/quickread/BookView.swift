import SwiftUI
import FolioReaderKit
import UIKit

struct Book: Identifiable {
    let id: Int
    let title: String
    let author: String
    let epubFilePath: String
    let shouldHideNavigationOnTap: Bool
    let scrollDirection: FolioReaderScrollDirection
}

struct BookView: View {
    let book: Book
    @State private var coverImage: UIImage?
    
    var body: some View {
        VStack(alignment: .center) {
            if let coverImage = coverImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .frame(width: 150, height: 150)
                    .onTapGesture {
                        openBook(book)
                    }
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(8)
                    .frame(width: 150, height: 150)
            }
            
            Text(book.title)
                .font(.headline)
                .padding(.top)
            
            Text(book.author)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .onAppear {
            loadCoverImage()
        }
    }
    
    func loadCoverImage() {
        DispatchQueue.global(qos: .background).async {
            if let epubPath = Bundle.main.path(forResource: book.epubFilePath, ofType: "epub") {
                do {
                    let coverImage = try FolioReader.getCoverImage(epubPath)
                    DispatchQueue.main.async {
                        self.coverImage = coverImage
                    }
                } catch {
                    print("Error loading cover image: \(error)")
                }
            }
        }
    }
    
    func openBook(_ book: Book) {
        guard let epubPath = Bundle.main.path(forResource: book.epubFilePath, ofType: "epub") else {
            print("EPUB file not found")
            return
        }

        let config = FolioReaderConfig()
        config.shouldHideNavigationOnTap = book.shouldHideNavigationOnTap
        config.scrollDirection = book.scrollDirection
        let folioReader = FolioReader()
        folioReader.presentReader(parentViewController: UIApplication.shared.windows.first!.rootViewController!, withEpubPath: epubPath, andConfig: config)
    }
}
