//
//  LoadingIndicatorCollectionViewFooter.swift
//  FetchDataWillDisplay
//
//  Created by Oğuz Canbaz on 1.06.2024.
//

import UIKit

class LoadingIndicatorCollectionViewFooter: UICollectionReusableView {

    // MARK: -- Components
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: -- Life Cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    // MARK: -- Functions
    
    private func setupActivityIndicator(){
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
    }
    
    func startAnimating(){
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating(){
        loadingIndicator.stopAnimating()
    }
}
