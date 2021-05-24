import SnapKit
import UIKit

final class MainCollectionViewCell: UICollectionViewCell {

    // MARK: - Subviews

    var gifImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
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
            $0.leading.equalToSuperview().offset(8.0)
            $0.height.width.equalTo(64.0)
        }

        gifTextLabel.snp.makeConstraints {
            $0.leading.equalTo(gifImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview()
            $0.centerYWithinMargins.equalToSuperview()
        }
    }
}
