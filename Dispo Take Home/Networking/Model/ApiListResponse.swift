import Foundation

struct APIListResponse: Codable {
    let results: [Result]

    struct Result: Codable {
        let id: String
        let title: String
        let media: [Media]

        struct Media: Codable {
            let gif: MediaData

            struct MediaData: Codable {
                let url: URL
                let preview: URL
            }
        }
    }
}
