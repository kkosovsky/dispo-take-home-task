import Foundation

struct ApiDetailsResponse: Codable {
    let results: [DetailsResult]

    struct DetailsResult: Codable {
        let id: String
        let tags: [String]
        let itemurl: URL
        let title: String
        let shares: Int
        let media: [Media]
    }
}
