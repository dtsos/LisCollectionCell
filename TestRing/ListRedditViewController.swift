
//
//  ListRedditViewController.swift
//  TestRing
//
//  Created by David Trivian S on 3/28/17.
//  Copyright © 2017 David Trivian S. All rights reserved.
//

import UIKit
import SafariServices
private let reuseIdentifier = "CollectionListWelcomePage"
class ListRedditViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var articles:[Article] = [Article]()
    var lastIndex = 10
    var startIndex = 0
    var scale:CGFloat = 1
    var padding:CGFloat = 24
    var floatWidth:CGFloat = 0.0
    var floatHeight:CGFloat = 0.0
    let columnNum: CGFloat = 2 //use number of columns instead of a static maximum cell width
    var cellWidth: CGFloat = 0
    let  refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        //        self.floatWidth = (Double(320 - (self.padding * 3) / 2))
        //        self.floatHeight =  self.floatWidth * 9 / 16
        //        self.collectionView.register(ArticleCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        //            flowLayout.estimatedItemSize = CGSize(width:1, height:1)
        //            flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        //        }
        self.floatWidth = UIScreen.main.bounds.size.width
        self.floatHeight = UIScreen.main.bounds.size.height
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let flow:UICollectionViewFlowLayout =  self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = self.padding
        flow.minimumInteritemSpacing = self.padding;
        flow.sectionInset = UIEdgeInsetsMake(padding, padding, flow.sectionInset.bottom, padding);
        
        GetList(refresh: false)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:#selector(ListRedditViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        self.collectionView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        GetList(refresh: true)
        
        
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //
    //        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
    //            let itemWidth = view.bounds.width / 1.0
    //            let itemHeight = layout.itemSize.height
    //            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    //            layout.invalidateLayout()
    //        }
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UICollectionViewDataSource
    //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:reuseIdentifier, for: indexPath)
        configureCell(cell: cell, forItemAt: indexPath)
        cell.contentView.needsUpdateConstraints()
        
        cell.contentView.layoutIfNeeded()
        cell.layoutIfNeeded()
        cell.contentView.setNeedsLayout()
        cell.setNeedsLayout()
        
        
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? ArticleCollectionCell
        let article =  self.articles[indexPath.row]
        cell?.articleId =  article.id
        cell?.labelTitle.text =  article.title
        cell?.labelAuthor.text =  article.author
        cell?.labelTotalComment.text = String(article.totalComment) + " Comments"
        cell?.article = article
        cell?.loadImageUrl(url: article.thumbNail)
        if article.entryDate != nil {
            
            
            let date:Date = article.entryDate!
            let dateFormater:DateFormatter = DateFormatter()
            dateFormater.formatterBehavior = .behavior10_4
            dateFormater.locale = Locale(identifier:"id")
            dateFormater.dateFormat = "EEEE, dd/MM/yyyyy HH:mm:ss"
            let StringDate:String = dateFormater.string(from: date)
            cell?.labelTime.text =  StringDate.dateDiff()
        }else{
            cell?.labelTime.text = nil
        }
        
        cell?.actionOpenURLTap = { (cell) in
            let svc = SFSafariViewController(url: URL(string: article.url)!)
            self.present(svc, animated: true, completion: nil)
        }
        cell?.actionSaveGalleryTap = { (cell) in
            if article.imageData != nil {
                let image:UIImage = UIImage(data:article.imageData!)!
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }else{
                let ac = UIAlertController(title: "No Image Data", message: "It doesn't have image", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            

            }
            
        }
        
        
        
    }
    //save to a
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        // Adjust cell size for orientation
        if indexPath.row <= self.articles.count  {
            
            
            if UIApplication.shared.statusBarOrientation.isLandscape {
                let heightRow:CGFloat = calculateHeightArticle(article: self.articles[indexPath.row],isPortrait: false)
                return CGSize(width:(UIScreen.main.bounds.size.width  ) / 2, height:heightRow)
                
                
            }
            let heightRow:CGFloat = calculateHeightArticle(article: self.articles[indexPath.row], isPortrait: true)
            return CGSize(width:UIScreen.main.bounds.size.width, height:heightRow)
        }
        return CGSize.zero
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        NSLog(NSStringFromCGSize(size))
        self.floatWidth = size.width
        self.floatHeight = size.height
        self.collectionView.collectionViewLayout.invalidateLayout()
        
       
    }
    
    
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    //get data fro server or locall
    func GetList(refresh:Bool)  {
        var after = UserDefaults.standard.string(forKey: "ListRedit_Paging_After") ?? ""
        var maxArticle = self.articles.count + 10
        if refresh {
            after = ""
            maxArticle = 10
        }else{
            self.refreshControl.beginRefreshing()
        }
        ReditUrlSessionClient.sharedInstance.ListTopReddit(after: after, countMaxArticle: maxArticle) { (articles) in
            self.refreshControl.endRefreshing()
            guard  articles != nil && articles?.count != 0 else {
                return
            }
            
            if refresh && (articles?.count)! > 0{
                
                
                self.articles.removeAll()
                self.collectionView.reloadData()
                self.startIndex = 0
                self.lastIndex = 10
            }
            
            self.collectionView.performBatchUpdates({
                //                po self.
                for i in self.startIndex..<self.lastIndex {
                    //                    if  ManagerShared.sharedInstance.listArticle.count <=  {
                    let article =  ManagerShared.sharedInstance.listArticle[i]
                    let indexPath:IndexPath = IndexPath(row: self.articles.count, section: 0)
                    self.articles.append(article)
                    self.collectionView.insertItems(at: [indexPath])
                    
                    
                    //                    }
                }
                if self.lastIndex < 50{
                    self.startIndex =  self.lastIndex
                    self.lastIndex += 10
                }
            }, completion: { (complete) in
                
            })
        }
        
    }
    override func encodeRestorableState(with coder: NSCoder) {
        
            super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        if scrollView.isAtBottom {
            print("this is end, see you in console")
            if ReditUrlSessionClient.sharedInstance.loadingState == .NotLoading {
                GetList(refresh: false)
            }
        }
    }
    func calculateHeightArticle(article:Article,isPortrait:Bool) -> CGFloat {
        let floatHeight:CGFloat = CGFloat(isPortrait ? article.heightCellPortait : article.heightCellLandsacpe)
        if floatHeight != 0.0  {
            return floatHeight
        }
        let heightAuthor: CGFloat = CGFloat(rectForText(text: article.author, font: UIFont .systemFont(ofSize: 12), maxSize: CGSize(width: UIScreen.main.bounds.size.width - 126, height: 15)).height)
        var stringDate:String?
        if let date:Date = article.entryDate{
            let dateFormater:DateFormatter = DateFormatter()
            dateFormater.formatterBehavior = .behavior10_4
            dateFormater.locale = Locale(identifier:"id")
            dateFormater.dateFormat = "EEEE, dd/MM/yyyyy HH:mm:ss"
            let StringDate:String = dateFormater.string(from: date)
            stringDate =  StringDate.dateDiff()
        }else{
            stringDate = nil
        }
        
        let heightDate: CGFloat = CGFloat(rectForText(text: stringDate!, font: UIFont .systemFont(ofSize: 12), maxSize: CGSize(width: UIScreen.main.bounds.size.width - 126, height: 15)).height)
        
        let heightTitle: CGFloat = CGFloat(rectForText(text: article.title, font: UIFont .systemFont(ofSize: 12), maxSize: CGSize(width: UIScreen.main.bounds.size.width - 126, height: CGFloat.greatestFiniteMagnitude)).height)
        
        
        let heightComment: CGFloat = CGFloat(rectForText(text: String("\(article.totalComment) Comments"), font: UIFont .systemFont(ofSize: 12), maxSize: CGSize(width: UIScreen.main.bounds.size.width - 126, height: 15)).height)
        var heightWord :CGFloat = CGFloat( 2 * self.padding + 5 + heightTitle.rounded(.up)  + 5 + heightAuthor.rounded(.up)  + 5 + heightDate.rounded(.up)  + 5 + heightComment.rounded(.up)  + 5)
        if heightWord < 110 {
            heightWord = 110
        }
        if isPortrait {
            article.heightCellPortait = Double(heightWord)
        }else{
            article.heightCellLandsacpe = Double(heightWord)
        }
        return heightWord
    }
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width:rect.size.width, height:rect.size.height)
        return size
    }
    
}
extension UIScrollView {
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

