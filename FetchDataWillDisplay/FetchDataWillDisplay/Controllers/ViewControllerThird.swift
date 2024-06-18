//
//  ViewControllerThird.swift
//  FetchDataWillDisplay
//
//  Created by Oğuz Canbaz on 1.06.2024.
//

import UIKit

class ViewControllerThird: UIViewController {
    
    // MARK: -- Components
    
    @IBOutlet weak var outerCollectionView: UICollectionView!
    
    // MARK: -- Properties
    
    var sectionControl: Int = 0
    var allData: [[String]] = []
    var data: [[String]] = []
    
    var isLoadingControl = true
    var isFirstLastLoading = true
    var isFirstWillDisplay = true
    var isFooter = true
    
    var numberOfSection = 0
    
    // MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.prepareCollectionView()
            self.getAllData()
            self.fetchMoreData(limit: 5)
        }
    }
    
    // MARK: -- Functions
    
    private func prepareCollectionView() {
        let outerNib = UINib(nibName: "OuterCollectionViewCell", bundle: nil)
        outerCollectionView.register(outerNib, forCellWithReuseIdentifier: "OuterCollectionViewCell")
        
        let footer = UINib(nibName: "LoadingIndicatorCollectionViewFooter", bundle: nil)
        outerCollectionView.register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingIndicatorCollectionViewFooter")
        
        let header = UINib(nibName: "CollectionViewHeaderCollectionReusableView", bundle: nil)
        outerCollectionView.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeaderCollectionReusableView")
        
        outerCollectionView.delegate = self
        outerCollectionView.dataSource = self
    }
    
    func getAllData() {
        for i in stride(from: 1, to: 100, by: 5) {
            var quintupleArray: [String] = []
            for j in i..<i+5 {
                quintupleArray.append(String(j))
            }
            allData.append(quintupleArray)
        }
    }
    
    func fetchMoreData(limit: Int) {
        isLoadingControl = false
        isFooter = true
        outerCollectionView.reloadSections(IndexSet(integer: numberOfSection - 1))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
            let endIndex = min(self.allData.count, self.data.count + limit)
            for i in self.data.count..<endIndex {
                self.data.append(self.allData[i])
            }
            DispatchQueue.main.async {
                self.numberOfSection += limit
                if self.data.count == self.numberOfSection{
                    self.outerCollectionView.reloadData()
                    self.isLoadingControl = true
                    self.isFooter = false
                    DispatchQueue.main.async {
                        self.isFirstLastLoading = false
                    }
                }else{
                    let actual = self.numberOfSection - self.data.count
                    self.numberOfSection -= actual
                    self.outerCollectionView.reloadData()
                    self.isLoadingControl = true
                    self.isFooter = false
                    self.isFirstLastLoading = true
                    DispatchQueue.main.async {
                        self.isFirstLastLoading = true
                    }
                }
            }
        }
    }
}

// MARK: -- Extensions

extension ViewControllerThird: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == numberOfSection - 5 && !isFirstLastLoading && isLoadingControl && isFirstWillDisplay {
            fetchMoreData(limit: 4)
            isFirstWillDisplay = false
        } else if indexPath.section == numberOfSection - 1 && !isFirstLastLoading && isLoadingControl {
            fetchMoreData(limit: 4)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OuterCollectionViewCell", for: indexPath) as! OuterCollectionViewCell
        cell.sectionControl = indexPath.section
        cell.data = data[indexPath.section]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = collectionViewWidth
        let cellHeight = cellWidth / 2 - 30
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingIndicatorCollectionViewFooter", for: indexPath) as! LoadingIndicatorCollectionViewFooter
            if isFooter {
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
            return footer
        }else if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeaderCollectionReusableView", for: indexPath) as! CollectionViewHeaderCollectionReusableView
            header.title.text = "Title"
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == collectionView.numberOfSections - 1 && isFooter {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
