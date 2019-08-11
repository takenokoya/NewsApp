//
//  ViewController.swift
//  SummerCampNews
//
//  Created by 坂口卓也 on 2019/08/11.
//  Copyright © 2019 坂口卓也. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: ButtonBarPagerTabStripViewController {
    
    let urlList: [String] = ["https://news.yahoo.co.jp/pickup/domestic/rss.xml",
                             "https://www.nhk.or.jp/rss/news/cat0.xml",
                             "http://shukan.bunshun.jp/list/feed/rss"]

    //タブの名前をひ表示
    var itemInfo: [IndicatorInfo] = ["Yahoo!", "NHK", "週間文春"]
    
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

