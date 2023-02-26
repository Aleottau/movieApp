//
//  NewHomeCell.swift
//  inhouseApp1
//
//  Created by alejandro on 28/12/22.
//

import UIKit

class NewHomeCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    static let identifier: String = "NewHomeCell"
    override var reuseIdentifier: String? {
        return NewHomeCell.identifier
    }

    func newHomeCellInstance() -> UICollectionViewCell? {
        let nib = UINib(nibName: "NewHomeCell", bundle: nil)
        let view = nib.instantiate(withOwner: self).first as? NewHomeCell
        return view
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        voteLabel.text = nil
    }

    func setModel(model: Movie, indexPath: Int) {
        titleLabel.text = model.title ?? model.name
        guard let vote = model.voteAverage else {
            voteLabel.text = "⭐️ 0"
            return
        }
        voteLabel.text = "⭐️ \(String(describing: vote.toString()))"
    }
}
