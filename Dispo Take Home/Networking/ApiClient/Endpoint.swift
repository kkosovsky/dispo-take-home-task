import Foundation

enum Endpoint {
    case search(query: String)
    case featuredGifs
    case gifInfo(id: String)

    var url: URL {
        components.url!
    }

    private var components: URLComponents {
        switch self {
        case .search:
            var components = URLComponents(
                url: URL(string: "https://g.tenor.com/v1/search")!,
                resolvingAgainstBaseURL: false
            )!

            components.queryItems = queryItems
            return components
        case .featuredGifs:
            var components = URLComponents(
                url: URL(string: "https://g.tenor.com/v1/trending")!,
                resolvingAgainstBaseURL: false
            )!

            components.queryItems = queryItems
            return components
        case .gifInfo:
            var components = URLComponents(
                url: URL(string: "https://g.tenor.com/v1/gifs")!,
                resolvingAgainstBaseURL: false
            )!

            components.queryItems = queryItems
            return components
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case let .search(query):
            return [
                .init(name: "q", value: query),
                .init(name: "key", value: Constants.tenorApiKey),
                .init(name: "limit", value: "30"),
            ]
        case .featuredGifs:
            return [
                .init(name: "key", value: Constants.tenorApiKey),
                .init(name: "limit", value: "30"),
            ]
        case let .gifInfo(id):
            return [
                .init(name: "ids", value: id),
                .init(name: "key", value: Constants.tenorApiKey),
            ]
        }
    }
}
