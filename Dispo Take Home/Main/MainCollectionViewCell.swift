import Kingfisher
import SnapKit
import UIKit

final class MainCollectionViewCell: UICollectionViewCell {


    var downloadTask: DownloadTask?

    // MARK: - Subviews

    var gifImageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let gifTextLabel: UILabel = UILabel(frame: .zero)

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpLayout()
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - UICollectionReusableView

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        gifImageView.animationImages = nil
        gifImageView.image = nil
        gifTextLabel.text = nil
    }

    // MARK: - Private

    private func addSubviews() {
        [gifImageView, gifTextLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setUpLayout() {
        gifImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16.0)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(gifImageView.snp.height)
        }

        gifTextLabel.snp.makeConstraints {
            $0.leading.equalTo(gifImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview()
            $0.centerYWithinMargins.equalToSuperview()
        }
    }
}
