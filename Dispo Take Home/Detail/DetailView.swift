import SnapKit
import UIKit

final class DetailView: UIView {

    let gifImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    let sharesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    let tagsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        setUpLayout()
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Private

    private func addSubviews() {
        [gifImageView, titleLabel, sharesLabel, tagsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setUpLayout() {
        gifImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16.0)
            $0.leading.equalToSuperview().offset(32.0)
            $0.trailing.equalToSuperview().offset(-32.0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(gifImageView.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
        }

        sharesLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
        }

        tagsLabel.snp.makeConstraints {
            $0.top.equalTo(sharesLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
