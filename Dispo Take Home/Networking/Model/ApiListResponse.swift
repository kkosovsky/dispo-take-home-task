import Foundation

struct APIListResponse: Codable {
    let results: [Result]

    struct Result: Codable {
        let id: String
        let title: String
        let media: [Media]
    }
}
