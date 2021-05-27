import Foundation

struct Media: Codable {
    let gif: MediaData

    struct MediaData: Codable {
        let url: URL
    }
}
