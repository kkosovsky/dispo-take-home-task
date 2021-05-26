import Combine
import UIKit

protocol TenorApiClientType {
    var gifInfo: (_ gifId: String) -> AnyPublisher<GifInfo, Never> { get }
    var searchGIFs: (_ query: String) -> AnyPublisher<[SearchResult], Never> { get }
    var featuredGIFs: () -> AnyPublisher<[SearchResult], Never> { get }
}

struct TenorAPIClient: TenorApiClientType {
    var gifInfo: (_ gifId: String) -> AnyPublisher<GifInfo, Never>
    var searchGIFs: (_ query: String) -> AnyPublisher<[SearchResult], Never>
    var featuredGIFs: () -> AnyPublisher<[SearchResult], Never>
}

// MARK: - Live Implementation

extension TenorAPIClient {

    private static var gifInfoTransform: (String) -> AnyPublisher<GifInfo, Never> = { id in
        URLSession.shared.dataTaskPublisher(for: .gifInfo(id: id))
            .decode(type: ApiDetailsResponse.self, decoder: JSONDecoder())
            .map {
                GifInfo(
                    id: $0.results[0].id,
                    gifUrl: $0.results[0].media[0].gif.url,
                    title: $0.results[0].title.isEmpty ? "No title" : $0.results[0].title,
                    shares: $0.results[0].shares,
                    tenorUrl: $0.results[0].itemurl,
                    tags: $0.results[0].tags
                )
            }
            .catch { error in
                Empty().eraseToAnyPublisher()
            }
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private static var searchGifsTransform: (String) -> AnyPublisher<[SearchResult], Never> = { query in
        URLSession.shared.dataTaskPublisher(for: .search(query: query))
            .decode(type: APIListResponse.self, decoder: JSONDecoder())
            .map { response in
                response.results.map {
                    SearchResult(
                        id: $0.id,
                        gifUrl: $0.media[0].gif.url,
                        text: $0.title.isEmpty ? "No title" : $0.title
                    )
                }
            }
            .replaceError(with: [])
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private static var featuredGifTransform: () -> AnyPublisher<[SearchResult], Never> = {
        URLSession.shared.dataTaskPublisher(for: .featuredGifs)
            .decode(type: APIListResponse.self, decoder: JSONDecoder())
            .map { response in
                response.results.map {
                    SearchResult(
                        id: $0.id,
                        gifUrl: $0.media[0].gif.url,
                        text: $0.title.isEmpty ? "No title" : $0.title
                    )
                }
            }
            .replaceError(with: [])
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    static let live = TenorAPIClient(
        gifInfo: gifInfoTransform,
        searchGIFs: searchGifsTransform,
        featuredGIFs: featuredGifTransform
    )
}
