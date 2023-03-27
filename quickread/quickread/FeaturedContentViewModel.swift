import Combine
import SwiftUI

class FeaturedContentViewModel: ObservableObject {
    @Published var bookPreviews: [BookPreview] = []

    func fetchRecommendations() {
        // Replace 'fetchFromCustomAPIProvider' with your actual custom API function
        fetchFromCustomAPIProvider() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookPreviews):
                    self.bookPreviews = bookPreviews.map { preview in
                        // [TODO](liq) decouple/replace id with fileName, the current logic assumes id will be fileName, which can be used locally to determine if a epub file exist.
                        BookPreview(id: preview.id, title: preview.title, authors: preview.authors, previewLink: preview.previewLink, epubURL: preview.epubURL, fileName: preview.fileName)
                    }
                case .failure(let error):
                    print("Error fetching book recommendations: \(error)")
                }
            }
        }
    }
    
    private func fetchFromCustomAPIProvider(completion: @escaping (Result<[BookPreview], Error>) -> Void) {
        // Replace with the API Gateway URL for your Lambda function
        // [TODO] change aws api gateway security type
        let url = URL(string: "https://kv7vei147a.execute-api.us-east-1.amazonaws.com/default/book_recommendation")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([String: [BookPreview]].self, from: data)
                let bookPreviews = response["bookPreviews"] ?? []
                completion(.success(bookPreviews))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
