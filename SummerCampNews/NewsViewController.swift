//
//  NewsViewController.swift
//  SummerCampNews
//
//  Created by 坂口卓也 on 2019/08/11.
//  Copyright © 2019 坂口卓也. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewsViewController: UIViewController, IndicatorInfoProvider {
    
    // urlを受け取る
    var url: String = ""
    //MainViewControllerから送られてくるitemInfoを受け取る
    var itemInfo: IndicatorInfo = ""
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
