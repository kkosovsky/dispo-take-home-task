import Foundation
import Combine

extension URLSession {
    func dataTaskPublisher(for endpoint: Endpoint) -> AnyPublisher<Data, Error>  {
        URLSession.shared.dataTaskPublisher(for: endpoint.url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }.eraseToAnyPublisher()
    }
}
