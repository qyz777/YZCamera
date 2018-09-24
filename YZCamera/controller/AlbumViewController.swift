//
//  AlbumViewController.swift
//  YZCamera
//
//  Created by Q YiZhong on 2018/9/22.
//  Copyright © 2018年 Q YiZhong. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dataArray: Array<AlbumModel> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        initView()
        loadImage()
    }
    
    func initView() {
        view.backgroundColor = UIColor.white
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier())
        view.addSubview(collectionView)
        yz_navigationBar?.leftBtn.setImage(UIImage.init(named: "back_btn"), for: UIControl.State.normal)
        yz_navigationBar?.leftBtn.addTarget(self, action: #selector(backBtnDidClicked), for: UIControl.Event.touchUpInside)
        yz_navigationBar?.titleLabel.text = "相册"
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(yz_navigationBar!.snp.bottom)
            make.right.left.bottom.equalTo(view)
        }
    }
    
    @objc func backBtnDidClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadImage() {
        if AlbumManager.shared.hasAuth() {
            userShouldOpenAuth()
        }else {
            collectionView.alpha = 0
            DispatchQueue.global().async {
                AlbumManager.shared.allAlbums(complete: { (array) in
                    DispatchQueue.main.async {
                        self.dataArray = array
                        self.collectionView.reloadData()
                        UIView.animate(withDuration: 0.4, animations: {
                            self.collectionView.alpha = 1
                        })
                    }
                })
            }
        }
    }
    
    private func userShouldOpenAuth() {
        let alert = UIAlertController.init(title: "提示", message: "此APP需要您打开相册权限", preferredStyle: UIAlertController.Style.alert)
        
        let goAction = UIAlertAction.init(title: "去开启", style: UIAlertAction.Style.default) { (alert) in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : true], completionHandler: nil)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(goAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier(), for: indexPath)  as! AlbumCollectionViewCell
        cell.model = dataArray[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MoreAlbumViewController()
        vc.model = dataArray[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        if offset.y <= -110 {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: lazy
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: (SCREEN_WIDTH - 40) / 2, height: (SCREEN_WIDTH - 40) / 2 + 35)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 15, right: 15)
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.dataSource = self
        view.delegate = self
        return view
    }()
}
