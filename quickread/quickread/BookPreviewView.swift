import SwiftUI
import Alamofire
import FolioReaderKit

struct BookPreview: Identifiable, Codable {
    let id: String
    let title: String
    let authors: [String]
    let previewLink: String
    let epubURL: String
    let fileName: String

    enum CodingKeys: String, CodingKey {
        case id, title, authors
        case previewLink = "preview_link"
        case epubURL = "epub_url"
        case fileName = "file_name"
    }
    
    init(id: String, title: String, authors: [String], previewLink: String, epubURL: String, fileName: String) {
        self.id = id
        self.title = title
        self.authors = authors
        self.previewLink = previewLink
        self.epubURL = epubURL
        self.fileName = fileName
        print("in init: epubURL: \(epubURL)")
    }
}

struct BookPreviewView: View {
    var bookPreview: BookPreview
    @EnvironmentObject var bookManager: BookManager
    @State private var parentViewController: UIViewController?

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: bookPreview.previewLink)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 120, height: 160)
            .cornerRadius(8)

            Text(bookPreview.title)
                .font(.headline)
            Text("by \(bookPreview.authors.joined(separator: ", "))")
                .font(.subheadline)
        }
        .background(UIViewControllerResolver(parentViewController: $parentViewController))
        .padding()
        .background(Color(.systemGray4))
        .cornerRadius(10)
        .frame(width: 150, height: 250) // Set fixed width and height for the entire view
        .onTapGesture { // Add a tap gesture
            bookPreviewViewClicked()
        }
    }
    
    func bookPreviewViewClicked() {
        let fileName = bookPreview.fileName
        
        if bookManager.isEpubFileDownloaded(fileName: fileName) {
            openEpubFile()
        } else {
            let presignedUrlEndpoint = bookPreview.epubURL
            bookManager.downloadEpubFile(from: presignedUrlEndpoint) { localURL in
                if localURL != nil {
                    self.openEpubFile()
                } else {
                    print("Error downloading ePUB file")
                }
            }
        }
    }

    func openEpubFile() {
        let fileName = bookPreview.fileName
        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        if let parentVC = parentViewController {
            let folioReader = FolioReader()
            let config = FolioReaderConfig()
            folioReader.presentReader(parentViewController: parentVC, withEpubPath: localURL.path, andConfig: config)
        } else {
            print("Error: Parent view controller not found.")
        }
    }
}
