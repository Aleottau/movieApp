//
//  HomeCell.swift
//  inhouseApp1
//
//  Created by alejandro on 17/08/22.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topCountLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    @IBOutlet weak var lenguageLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nameButton: UIButton!
    static let identifier: String = "HomeCell"
    override var reuseIdentifier: String? {
        return HomeCell.identifier
    }
    func homeCellInstance() -> UICollectionViewCell? {
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        let view = nib.instantiate(withOwner: self).first as? HomeCell
        return view
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        topCountLabel.text = nil
        mediaTypeLabel.text = nil
        lenguageLabel.text = nil
        voteAverageLabel.text = nil
        releaseDateLabel.text = nil
        nameButton.setTitle(nil, for: .normal)

    }
    func setModel(model: Movie, indexPath: Int) {
        topCountLabel.text = String("Top \(indexPath)")
        mediaTypeLabel.text = model.mediaType
        lenguageLabel.text = model.lenguage
        if let vote = model.voteAverage {
            voteAverageLabel.text = "⭐️ \(String(describing: vote.toString()))"
        } else {
            voteAverageLabel.text = "⭐️ 0"
        }
        releaseDateLabel.text = model.releaseDate
        nameButton.setTitle(model.title ?? model.name, for: .normal)
    }
}
extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
