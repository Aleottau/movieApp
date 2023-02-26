//
//  TrendingHeader.swift
//  inhouseApp1
//
//  Created by alejandro on 27/12/22.
//

import Foundation
import UIKit
import SnapKit

class SectionHeaders: UICollectionReusableView {

    let sectionTitle =  UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func labelConfig() {
        sectionTitle.font = UIFont.preferredFont(forTextStyle: .title1)
        sectionTitle.adjustsFontForContentSizeCategory = true
        sectionTitle.numberOfLines = 1
        sectionTitle.textAlignment = .left
    }
    func constraintsForLabel() {
        addSubview(sectionTitle)
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        labelConfig()
        constraintsForLabel()
    }
}
