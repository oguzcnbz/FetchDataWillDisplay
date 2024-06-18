//
//  ViewControllerSecond.swift
//  FetchDataWillDisplay
//
//  Created by Oğuz Canbaz on 1.06.2024.
//

import UIKit

class ViewControllerSecond: UIViewController {
    
    // MARK: -- Components
    
    @IBOutlet weak var outerCollectionView: UICollectionView!
    
    // MARK: -- Properties
    
    var sectionControl: Int = 0
    var allData: [[String]] = []
    var data: [[String]] = []
    
    var isLoadingControl = true
    var isFirstLastLoading = true
    var isFirstWillDisplay = true
    
    var numberOfSection = 0
    
    // MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        getAllData()
        DispatchQueue.main.async {
            self.fetchMoreData(limit: 5)
            DispatchQueue.main.async {
                self.isFirstLastLoading = false
            }
        }
    }
    
    // MARK: -- Functions
    
    private func prepareCollectionView() {
        
        let outerNib = UINib(nibName: "OuterCollectionViewCell", bundle: nil)
        outerCollectionView.register(outerNib, forCellWithReuseIdentifier: "OuterCollectionViewCell")
        
        let outerLoadingNib = UINib(nibName: "LoadingIndicatorCollectionViewCell", bundle: nil)
        outerCollectionView.register(outerLoadingNib, forCellWithReuseIdentifier: "LoadingIndicatorCollectionViewCell")
        
        let header = UINib(nibName: "CollectionViewHeaderCollectionReusableView", bundle: nil)
        outerCollectionView.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeaderCollectionReusableView")
        
        outerCollectionView.delegate = self
        outerCollectionView.dataSource = self
    }
    
    func getAllData() {
        for i in stride(from: 1, to: 80, by: 5) {
            var tripleArray: [String] = []
            for j in i..<i+5 {
                tripleArray.append(String(j))
            }
            allData.append(tripleArray)
        }
    }
    
    func fetchMoreData(limit:Int){
        isLoadingControl = false
        
        let newIndex = numberOfSection
        numberOfSection += limit
        outerCollectionView.insertSections(IndexSet(integersIn: newIndex..<newIndex + limit))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
            let endIndex = min(self.allData.count, self.data.count + limit)
            for i in self.data.count..<endIndex {
                self.data.append(self.allData[i])
            }
            DispatchQueue.main.async {
                if self.data.count == self.numberOfSection{
                    self.outerCollectionView.reloadSections(IndexSet(integersIn: newIndex..<newIndex+limit))
                }else{
                    let actual = self.numberOfSection - self.data.count
                    self.numberOfSection -= actual
                    self.outerCollectionView.deleteSections(IndexSet(integersIn: newIndex+limit-actual..<newIndex+limit))
                    self.outerCollectionView.reloadSections(IndexSet(integersIn: newIndex..<newIndex+limit-actual))
                    self.isFirstLastLoading = true
                }
                DispatchQueue.main.async {
                    self.isLoadingControl = true
                }
            }
        }
    }
}

// MARK: -- Extensions

extension ViewControllerSecond: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == numberOfSection - 5 && !isFirstLastLoading && isLoadingControl && isFirstWillDisplay{
            fetchMoreData(limit:2)
            isFirstWillDisplay = false
        }
        else if indexPath.section == numberOfSection - 1 && !isFirstLastLoading && isLoadingControl{
            fetchMoreData(limit:2)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if data.indices.contains(indexPath.section) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OuterCollectionViewCell", for: indexPath) as! OuterCollectionViewCell
            cell.sectionControl = indexPath.section
            cell.data = data[indexPath.section]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingIndicatorCollectionViewCell", for: indexPath) as! LoadingIndicatorCollectionViewCell
            cell.startAnimating()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = collectionViewWidth
        let cellHeight = cellWidth / 2 - 30
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeaderCollectionReusableView", for: indexPath) as! CollectionViewHeaderCollectionReusableView
            header.title.text = "Title"
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
