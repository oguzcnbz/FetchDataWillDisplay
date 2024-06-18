//
//  LoadingIndicatorCollectionViewCell.swift
//  FetchDataWillDisplay
//
//  Created by Oğuz Canbaz on 1.06.2024.
//

import UIKit

class LoadingIndicatorCollectionViewCell: UICollectionViewCell {

    // MARK: -- Components
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: -- Life Cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black.withAlphaComponent(0.2)
        loadingIndicator.color = .red
    }
    
    // MARK: -- Functions
    
    func startAnimating(){
        loadingIndicator.startAnimating()
    }
}
