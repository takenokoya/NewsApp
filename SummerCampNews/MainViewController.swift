//
//  ViewController.swift
//  SummerCampNews
//
//  Created by 坂口卓也 on 2019/08/11.
//  Copyright © 2019 坂口卓也. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class MainViewController: ButtonBarPagerTabStripViewController {
    
    let urlList: [String] = ["https://news.yahoo.co.jp/pickup/domestic/rss.xml",
                             "https://www.j-cast.com/index.xml",
                             "https://horiemon.com/feed/"]

    //タブの名前をひ表示
    var itemInfo: [IndicatorInfo] = ["Yahoo!", "JCAST", "ホリエモン"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //管理されるViewControllerを返す
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        //返すViewControllerの配列を作る
        var childViewControllers: [UIViewController] = []
        
        //それぞれのVCに異なるURLとITEMINFOをいれる
        for i in 0 ..< urlList.count {
            let VC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "News") as! NewsViewController
            
            //urlListのURLを一つずつVCにあるurlに入れる
            VC.url = urlList[i]
            VC.itemInfo = itemInfo[i]
            
            //配列にappend
            childViewControllers.append(VC)
        }
        // VCを返す
        return childViewControllers
    }

}

