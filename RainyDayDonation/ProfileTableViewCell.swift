//
//  ProfileTableViewCell.swift
//  RainyDayDonation
//
//  Created by Edward Anchundia on 1/10/17.
//  Copyright © 2017 Margaret Ikeda, Simone Grant, Edward Anchundia, Miti Shah. All rights reserved.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    var projectName = UILabel()
    var projectURL = UILabel()
    var donatedDate = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(projectName)
        self.contentView.addSubview(projectURL)
        self.contentView.addSubview(donatedDate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        projectName.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(contentView.snp.width)
        }
        
        projectURL.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(projectName.snp.bottom)
            make.width.equalTo(contentView.snp.width)
        }
        
        donatedDate.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(projectURL.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalTo(contentView.snp.width)
        }
    }
}
