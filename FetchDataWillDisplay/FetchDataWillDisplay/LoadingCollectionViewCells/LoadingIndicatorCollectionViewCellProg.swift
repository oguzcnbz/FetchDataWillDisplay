//
//  LoadingIndicatorCollectionViewCellProg.swift
//  FetchDataWillDisplay
//
//  Created by Oğuz Canbaz on 1.06.2024.
//

import UIKit
import SnapKit

class LoadingIndicatorCollectionViewCellProg: UICollectionViewCell {
    
    // MARK: -- Components
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .red
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let skeletonView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: -- Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeleton()
    }
    
    // MARK: -- Functions
    
    private func setupSkeleton() {
        contentView.addSubview(skeletonView)
        skeletonView.addSubview(activityIndicator)
        
        skeletonView.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
        
        activityIndicator.snp.makeConstraints({make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
    }
    
    func startAnimating(){
        activityIndicator.startAnimating()
    }
}
