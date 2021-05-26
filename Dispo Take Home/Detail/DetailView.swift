import Kingfisher
import SnapKit
import UIKit

final class DetailView: UIView {

    // MARK: - Subviews

    let gifImageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.contentMode = .scaleToFill
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
            $0.top.equalTo(safeAreaLayoutGuide).offset(Margin.small)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(Margin.regular)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-Margin.regular)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(gifImageView.snp.bottom).offset(Margin.small)
            $0.leading.trailing.equalToSuperview()
        }

        sharesLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Margin.small)
            $0.leading.trailing.equalToSuperview()
        }

        tagsLabel.snp.makeConstraints {
            $0.top.equalTo(sharesLabel.snp.bottom).offset(Margin.small)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
