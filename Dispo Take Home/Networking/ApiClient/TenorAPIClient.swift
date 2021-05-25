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

  private static var searchGifsTransform: (String) -> AnyPublisher<[SearchResult], Never> = { query in
    var components = URLComponents(
        url: URL(string: "https://g.tenor.com/v1/search")!,
        resolvingAgainstBaseURL: false
    )!
    components.queryItems = [
      .init(name: "q", value: query),
      .init(name: "key", value: Constants.tenorApiKey),
      .init(name: "limit", value: "30"),
    ]
    let url = components.url!

    return URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { element -> Data in
          guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
          }
          return element.data
        }
        .decode(type: APIListResponse.self, decoder: JSONDecoder())
        .map { response in
          response.results.map {
            SearchResult(
                id: $0.id,
                gifUrl: $0.media[0].gif.url,
                preview: $0.media[0].gif.preview,
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
    var components = URLComponents(
        url: URL(string: "https://g.tenor.com/v1/trending")!,
        resolvingAgainstBaseURL: false
    )!
    components.queryItems = [
      .init(name: "key", value: Constants.tenorApiKey),
      .init(name: "limit", value: "30"),
    ]
    let url = components.url!

    return URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { element -> Data in
          guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
          }
          return element.data
        }
        .decode(type: APIListResponse.self, decoder: JSONDecoder())
        .map { response in
          response.results.map {
            SearchResult(
                id: $0.id,
                gifUrl: $0.media[0].gif.url,
                preview: $0.media[0].gif.preview,
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
    gifInfo: { gifId in
      // TODO: Implement
      Empty().eraseToAnyPublisher()
    },
    searchGIFs: searchGifsTransform,
    featuredGIFs: featuredGifTransform
  )
}
