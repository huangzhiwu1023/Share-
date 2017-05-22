//
//  WSCollectionViewCell.swift
//  WolfStreet_iOS
//
//  Created by zwj on 16/12/23.
//  Copyright © 2016年 Wolf Street. All rights reserved.
//

import UIKit
import SnapKit

class WSCollectionViewCell: UICollectionViewCell {
   lazy var  title = UILabel()
   lazy var image = UIImageView()
    override init(frame:CGRect){
    super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
         setupUI()
    }
    
}

//界面布局
extension WSCollectionViewCell {
    fileprivate func setupUI() {
     //title.text = "微信"
    title.font = UIFont.systemFont(ofSize: 11)
    title.textColor = UIColor.white
     contentView.addSubview(title)
     contentView.addSubview(image)
       //
        image.snp.updateConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.centerX.equalTo(self.contentView).offset(0)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        title.snp.updateConstraints { (make) in
            make.top.equalTo(self.image.snp.bottom).offset(10)
            make.centerX.equalTo(self.contentView).offset(0)
        }
        
    }

}
