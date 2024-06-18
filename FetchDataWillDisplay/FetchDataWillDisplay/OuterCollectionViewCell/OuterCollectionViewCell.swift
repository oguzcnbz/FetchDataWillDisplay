//
//  OuterCollectionViewCell.swift
//  FetchDataWillDisplay
//
//  Created by Oğuz Canbaz on 1.06.2024.
//

import UIKit

class OuterCollectionViewCell: UICollectionViewCell {

    // MARK: -- Components
    
    @IBOutlet weak var innerCollectionView: UICollectionView!
    
    // MARK: -- Properties
    
    var data: [String] = []
    var sectionControl: Int = 0 {
        didSet {
            innerCollectionView.reloadData()
        }
    }
  
    // MARK: -- Life Cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCollectionView()
    }
    
    // MARK: -- Functions
    
    private func prepareCollectionView() {
        let nibFirst = UINib(nibName: "InnerCollectionViewCellFirst", bundle: nil)
        innerCollectionView.register(nibFirst, forCellWithReuseIdentifier: "InnerCollectionViewCellFirst")
        
        let nibSecond = UINib(nibName: "InnerCollectionViewCellSecond", bundle: nil)
        innerCollectionView.register(nibSecond, forCellWithReuseIdentifier: "InnerCollectionViewCellSecond")
        
        let nibThird = UINib(nibName: "InnerCollectionViewCellThird", bundle: nil)
        innerCollectionView.register(nibThird, forCellWithReuseIdentifier: "InnerCollectionViewCellThird")
        
        innerCollectionView.delegate = self
        innerCollectionView.dataSource = self
    }
}

// MARK: -- Extensions

extension OuterCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if sectionControl == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCollectionViewCellFirst", for: indexPath) as! InnerCollectionViewCellFirst
            cell.label.text = data[indexPath.row]
            return cell
        } else if sectionControl == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCollectionViewCellSecond", for: indexPath) as! InnerCollectionViewCellSecond
            cell.label.text = data[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCollectionViewCellThird", for: indexPath) as! InnerCollectionViewCellThird
            cell.label.text = data[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHieght = collectionView.frame.height
        
        let cellWidth = collectionViewWidth * 0.4
        let cellHieght = collectionViewHieght
        return CGSize(width: cellWidth, height: cellHieght)
    }
}
