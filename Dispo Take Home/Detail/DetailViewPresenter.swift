import Kingfisher
import UIKit

extension DetailView {
    static func withTitle(_ title: String) -> (DetailView) -> Void {
        {
          $0.titleLabel.text = title
        }
    }

    static func withShares(_ shares: Int) -> (DetailView) -> Void {
        {
            $0.sharesLabel.text = "\(shares) shares"
        }
    }

    static func withTags(_ tags: [String]) -> (DetailView) -> Void {
        {
            let tagsDescription = tags.isEmpty ? "none" : tags.joined(separator: ", ")
            $0.tagsLabel.text = "Tags: \(tagsDescription)"
        }
    }

    static func withImage(_ url: URL) -> (DetailView) -> Void {
        {
            $0.gifImageView.kf.setImage(with: url)
        }
    }
}
