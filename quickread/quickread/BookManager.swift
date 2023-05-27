import Foundation
import Alamofire
import FolioReaderKit

class BookManager: ObservableObject {
    
    static let shared = BookManager()

    func isEpubFileDownloaded(fileName: String) -> Bool {
        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: localURL.path)
    }

    func downloadEpubFile(from url: String, completion: @escaping (URL?) -> Void) {
        print("downloadEpubFile:\(url)")
        guard let remoteURL = URL(string: url) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(remoteURL.lastPathComponent)
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (localURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        print("remote url \(url)")
        Alamofire.download(remoteURL, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if response.result.isSuccess {
                    print("Downloaded file to: \(localURL)")
                    completion(localURL)
                } else {
                    print("Error downloading file: \(String(describing: response.error))")
                    completion(nil)
                }
            }
    }

    func findMatches(_ query: String, completion: @escaping ([BookPreview]) -> Void) {
        
        // TODO(liq) replace urlString with a new API endpoint
        // let urlString = "https://your-aws-url.com/api/search?q=\(query)"
        let urlString = "https://kv7vei147a.execute-api.us-east-1.amazonaws.com/default/book_recommendation"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([String: [BookPreview]].self, from: data)
                    let bookPreviews = response["bookPreviews"] ?? []
                    // TODO(liq) replace this hacky filter with real filter API
                    let filteredData = bookPreviews.filter { $0.title.hasPrefix(query) }
                    print(bookPreviews)
                    DispatchQueue.main.async {
                        completion(filteredData)
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    func fetchLibrary(_ query: String, completion: @escaping ([BookPreview]) -> Void) {
        
        // TODO(liq) replace urlString with a new API endpoint
        // let urlString = "https://your-aws-url.com/api/search?q=\(query)"
        let urlString = "https://kv7vei147a.execute-api.us-east-1.amazonaws.com/default/book_recommendation"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([String: [BookPreview]].self, from: data)
                    let bookPreviews = response["bookPreviews"] ?? []
                    DispatchQueue.main.async {
                        completion(bookPreviews)
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

}
