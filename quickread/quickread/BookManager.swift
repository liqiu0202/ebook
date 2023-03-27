import Foundation
import Alamofire
import FolioReaderKit

class BookManager: ObservableObject {
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
}
