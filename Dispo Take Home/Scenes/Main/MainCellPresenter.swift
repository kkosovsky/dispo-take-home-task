import Kingfisher
import UIKit

extension MainCollectionViewCell {
    static func withTitle(_ title: String) -> (MainCollectionViewCell) -> Void {
        {
            $0.gifTitleLabel.text = title
        }
    }

    static func withImage(
        _ url: URL,
        cache: ImageCache,
        downloader: ImageDownloader
    ) -> (MainCollectionViewCell) -> Void {
        { cell in
            if let image = cache.retrieveImageInMemoryCache(forKey: url.absoluteString) {
                cell.gifImageView.image = image
                return
            }

            cell.gifDownloadTask = downloader.downloadImage(with: url) { result in
                guard case let .success(value) = result else {
                    return
                }

                cell.gifImageView.image = value.image
                cache.store(value.image, forKey: url.absoluteString, toDisk: false)
            }
        }
    }
}
