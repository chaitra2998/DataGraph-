//
//  CompanyInfoCell.swift
//  DataGraph
//
//  Created by Chaitrali chaudhari  on 17/07/21.
//

import UIKit

class CompanyInfoCell: UICollectionViewCell {
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var priceChangePercent: UILabel!
    
    @IBOutlet weak var rateImage: UIImageView!
    
    
    override func prepareForReuse() {
        companyName.text = nil
        priceChangePercent.text = nil
    }
    
}
