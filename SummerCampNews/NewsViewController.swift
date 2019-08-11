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

    @IBOutlet weak var UIToolbar: UIToolbar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var nextPage: UIBarButtonItem!
    @IBOutlet weak var backPage: UIBarButtonItem!
    @IBOutlet weak var refreshPage: UIBarButtonItem!
    
    //TableViewのインスタンス取得
    var tableView: UITableView = UITableView()
    
    //XMLParserのインスタンスを取得
    var parser = XMLParser()
    
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
    
    // xmlファイルに解析をかけた内容
    var elements = NSMutableDictionary()
    // xmlファイルのタグ情報
    var element = String()
    // xmlファイルのタイトル情報
    var titleString = NSMutableString()
    //xmlファイルのリンク情報
    var linkString = NSMutableString()
    
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
        cell.textLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.textColor = UIColor.black
        //記事urlサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    //セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // webviewを表示する
        let linkURL = ((articles[indexPath.row] as AnyObject).value(forKey: "link") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlStr = (linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        guard let url = URL(string: urlStr) else {
            return
        }
        let urlRequest = NSURLRequest(url: url)
        webView.load(urlRequest as URLRequest)
    }
    
    //
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tableView.isHidden = true
        UIToolbar.isHidden = false
        self.webView.isHidden = false
    }
    
    @IBAction func cancel(_ sender: Any) {
        tableView.isHidden = false
        webView.isHidden = true
        UIToolbar.isHidden = true
    }
    
    @IBAction func backPage(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func nextPage(_ sender: Any) {
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
        
        //デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50)
        self.view.addSubview(tableView)

        //最初はTableViewを表示したいためtoolbarとwebviewを隠しておく
        UIToolbar.isHidden = true
        webView.isHidden = true
        
        parseUrl()
    }
    
    // URLを解析する
    func parseUrl() {
        // URLをurl型で定義
        let urlToSend: URL = URL(string: url)!
        // parserに解析対象のURLを格納
        parser = XMLParser(contentsOf: urlToSend)!
        // 記事情報を初期化
        articles = []
        // parserとの接続
        parser.delegate = self
        // 解析の実行
        parser.parse()
        // TableViewのリロード
        tableView.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        // エレメントにタイトルが入ってきたら
        if element == "item" {
            // 初期化
            elements = [:]
            titleString = ""
            linkString = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "title" {
            // stringにタイトルが入っているのでappend
            titleString.append(string)
        } else if element == "link" {
            linkString.append(string)
        }
    }

    // 終了タグを見つけた時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // アイテムという要素の中にあるなら、
        if elementName == "item" {
            // titleString,linkStringの中身が空でないなら
            if titleString != "" {
                // elementsに"title"、"Link"というキー値を付与しながらtitleString,linkStringをセット
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            if linkString != "" {
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            
            // articlesの中にelementsを入れる
            articles.add(elements)
        }
    }
}
