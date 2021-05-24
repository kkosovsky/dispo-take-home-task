import SnapKit
import UIKit

final class MainCollectionViewCell: UICollectionViewCell {

    let gifImageView = UIImageView(frame: .zero)

    let gifTextLabel: UILabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpLayout()
    }

    required init?(coder: NSCoder) { nil }

    private func addSubviews() {
        [gifImageView, gifTextLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setUpLayout() {
        gifImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8.0)
            $0.centerYWithinMargins.equalToSuperview()
        }

        gifTextLabel.snp.makeConstraints {
            $0.leading.equalTo(gifImageView.snp.trailing).offset(16.0)
            $0.centerYWithinMargins.equalToSuperview()
        }
    }
}
