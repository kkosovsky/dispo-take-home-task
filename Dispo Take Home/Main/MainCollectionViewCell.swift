import Kingfisher
import SnapKit
import UIKit

final class MainCollectionViewCell: UICollectionViewCell {

    // MARK: - DownloadTask

    var gifDownloadTask: DownloadTask?

    var gifImageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemTeal
        return imageView
    }()

    // MARK: - Subviews

    let gifTitleLabel: UILabel = UILabel(frame: .zero)

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
        gifDownloadTask?.cancel()
        gifImageView.animationImages = nil
        gifImageView.image = nil
        gifTitleLabel.text = nil
    }

    // MARK: - Private

    private func addSubviews() {
        [gifImageView, gifTitleLabel].forEach {
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

        gifTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(gifImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview()
            $0.centerYWithinMargins.equalToSuperview()
        }
    }
}
