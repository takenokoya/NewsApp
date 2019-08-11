//
//  NewsViewController.swift
//  SummerCampNews
//
//  Created by 坂口卓也 on 2019/08/11.
//  Copyright © 2019 坂口卓也. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class NewsViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, XMLParserDelegate {

    //TableViewのインスタンス取得
    var tableView: UITableView = UITableView()
    
    //XMLParserのインスタンスを取得
    var parser = XMLParser()
    
    @IBOutlet weak var UIToolbar: UIToolbar!
    @IBOutlet weak var webView: WKWebView!
    
    // urlを受け取る
    var url: String = ""
    //MainViewControllerから送られてくるitemInfoを受け取る
    var itemInfo: IndicatorInfo = ""

    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //セルの数
    var articles = NSMutableArray()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    //セルのカスタマイズ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        //セルの色
        cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        //記事テキストサイズとフォント
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.black
        //記事urlサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    //セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    //
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tableView.isHidden = true
        UIToolbar.isHidden = false
        webView.isHidden = false
    }
    
    @IBAction func cancel(_ sender: Any) {
        
    }
    
    @IBAction func backpage(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func nextpage(_ sender: Any) {
        webView.goForward()
    }
    @IBAction func refreshPage(_ sender: Any) {
        webView.reload()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationGeligateとの接続
        webView.navigationDelegate = self
        
        //parserとの接続
        parser.delegate = self
        
        //デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50.0)
        self.view.addSubview(tableView)

        //最初はTableViewを表示したいためtoolbarとwebviewを隠しておく
        UIToolbar.isHidden = true
        webView.isHidden = true
    }
    
    // URLを解析する
    func parseUrl() {
        // URLをurl型で定義
        let urlToSend: URL = URL(string: url)!
        // parserに解析対象のURLを格納
        parser = XMLParser(contentsOf: urlToSend)!
        // 記事情報を初期化
        articles = []
        //解析の実行
        parser.parse()
        // TableViewのリロード
        tableView.reloadData()
    }
}
