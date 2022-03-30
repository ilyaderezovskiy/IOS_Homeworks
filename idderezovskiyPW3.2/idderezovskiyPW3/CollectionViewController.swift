//
//  CollectionViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import UIKit

class CollectionViewController: ViewController {
    private var collection: UICollectionView?
    private var alarmViews: [AlarmView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection"
        
        var tabBarItem = UITabBarItem()
        tabBarItem = UITabBarItem(
            title: "Collection",
            image: UIImage(named: "collection"),
            selectedImage: UIImage(named: "collection")
        )
        self.tabBarItem = tabBarItem
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutFlow.itemSize = CGSize(
            width: view.frame.width,
            height: CGFloat(AlarmView.viewHeight)
        )
        layoutFlow.minimumLineSpacing = 0
        layoutFlow.minimumInteritemSpacing = 0
        layoutFlow.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layoutFlow)
        view.addSubview(collection)
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.register(
            CollectionCell.self,
            forCellWithReuseIdentifier: "CollectionCell"
        )
        collection.bounces = true
        collection.alwaysBounceHorizontal = true
        collection.isPagingEnabled = true
        collection.pinTop(to: self.view.topAnchor)
        collection.pinWidth(to: self.view.widthAnchor)
        collection.pinBottom(to: self.view.bottomAnchor)
        self.collection = collection
    }
    
    func updateData(_ data: AlarmModel.ViewModel) {
        alarmViews.removeAll()
        
        for i in 0 ..< data.displayedAlarms.count {
            let alarmId = data.displayedAlarms[i].alarmId
            let alarmTime = data.displayedAlarms[i].alarmTime
            let isOn = data.displayedAlarms[i].isOn
            let alarmName = data.displayedAlarms[i].alarmName
            
            let alarmView = AlarmView(
                updateAction: self.updateAlarm,
                edit: self.editAlarm,
                alarmId: alarmId,
                alarmName: alarmName,
                alarmTime: alarmTime,
                isOn: isOn
            )

            alarmViews.append(alarmView)
        }

        collection?.reloadData()
    }

    func updateAndPresentAlarm(_ alarmViewModel: AlarmModel.ViewModel.DisplayedAlarm) {
        let alarmId = alarmViewModel.alarmId
        let alarmTime = alarmViewModel.alarmTime
        let isOn = alarmViewModel.isOn
        let alarmName = alarmViewModel.alarmName
        
        for i in 0 ..< alarmViews.count {
            if alarmViews[i].getAlarmId() == alarmViewModel.alarmId {
                alarmViews[i] = AlarmView(
                    updateAction: self.updateAlarm,
                    edit: self.editAlarm,
                    alarmId: alarmId,
                    alarmName: alarmName,
                    alarmTime: alarmTime,
                    isOn: isOn
                )
            }
        }
        
        collection?.reloadData()
    }
}

extension CollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alarmViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection?.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell
        
        if let cell = cell {
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
        }

        cell?.contentView.addSubview(alarmViews[indexPath.item])
        alarmViews[indexPath.item].pin(to: cell?.contentView ?? alarmViews[indexPath.item])
        
        return cell ?? UICollectionViewCell()
    }
}

extension CollectionViewController : UICollectionViewDelegate { }

