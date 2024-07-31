//
//  NewsInboxVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 07/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class NewsInboxVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var newsTableView: UITableView!{
        didSet{
            newsTableView.delegate = self
            newsTableView.dataSource = self
            newsTableView.register(R.nib.newsCell)
        }
    }
    
    //MARK: - PROPERTIES -
    
    private var currentPage : Int = 0
    private var viewModel = InboxNewsViewModel()
    private var isLoading : Bool = false
    private var newsList : [NewsList] = []
    private var newsCurrentPage : Int = 0
    private var newsLastPage : Int = 0
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        viewModel.delegate = self
        getNewsList()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func getNewsList(){
        if !Network.isAvailable{
            self.newsTableView.setEmptyDataSet(title: PisiffikStrings.oopsNoInternetConnection(), description: PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain(), image: R.image.ic_no_connection_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
                self.currentPage += 1
                if self.currentPage == 1{
                    self.isLoading = true
                }else{
                    self.isLoading = false
                }
                self.viewModel.getInboxNewsList(currentPage: self.currentPage)
            }
        }else{
            self.currentPage += 1
            if currentPage == 1{
                self.isLoading = true
            }else{
                self.isLoading = false
            }
            self.viewModel.getInboxNewsList(currentPage: self.currentPage)
        }
    }
    
    //MARK: - ACTIONS -
    
    
    
}

//MARK: - EXTENSION FOR NEWS VIEW MODEL DELEGATES -

extension NewsInboxVC: InboxNewsViewModelDelegate{
    
    func didReceiveNewsList(response: NewsListResponse) {
        isLoading = false
        self.newsCurrentPage = response.data?.currentPage ?? 0
        self.newsLastPage = response.data?.lastPage ?? 0
        let newsID = NewsLocalManager.shared.getNewsID()
        if let list = response.data?.news{
            if !list.isEmpty{
                for news in list{
                    var newsObj : NewsList = news
                    if !newsID.isEmpty{
                        if newsID.contains(where: {$0 == newsObj.id}){
                            newsObj.isActive = false
                        }else{
                            newsObj.isActive = true
                        }
                    }else{
                        newsObj.isActive = true
                    }
                    self.newsList.append(newsObj)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.newsTableView.reloadData()
                }
            }else{
                self.currentPage -= 1
                if self.newsList.isEmpty{
                    self.newsTableView.setEmptyDataSet(title: PisiffikStrings.sorryNoItemFound(), image: R.image.ic_no_item_found_image() ?? UIImage(), shouldDisplay: true,isScrollAllowed: false)
                    self.newsTableView.reloadData()
                }else{
                    return
                }
            }
        }
    }
    
    func didReceiveNewsListResponseWith(errorMessage: [String]?, statusCode: Int?) {
        isLoading = false
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    func didReceiveUnauthentic(error: [String]?) {
        isLoading = false
        self.newsTableView.reloadData()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        isLoading = false
        self.newsTableView.reloadData()
        self.newsTableView.setEmptyDataSet(title: error?.first ?? "", image: R.image.ic_sometong_went_wrong_image() ?? UIImage(), buttonTitle: PisiffikStrings.tryAgain(), shouldDisplay: true) {
            self.viewModel.getInboxNewsList(currentPage: self.currentPage)
        }
    }
    
}



//MARK: - EXTENSION FOR NEWS LIST VIEW METHODS -

extension NewsInboxVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 20 : newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureNewsCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading { return }
        self.newsList[indexPath.row].isActive = false
        self.newsTableView.reloadData()
        NewsLocalManager.shared.saveNewsID(id: self.newsList[indexPath.row].id ?? 0)
        guard let newsDetailVC = R.storyboard.profileSB.newsDetailVC() else {return}
        newsDetailVC.newsObj = self.newsList[indexPath.row]
        self.push(controller: newsDetailVC, hideBar: true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.newsList.count - 1) && self.newsCurrentPage != self.newsLastPage && self.newsCurrentPage < self.newsLastPage{
            getNewsList()
        }
    }
    
}

//MARK: - EXTENSION FOR NEWS CELL -

extension NewsInboxVC{
    
    private func configureNewsCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = newsTableView.dequeueReusableCell(withIdentifier: .newsCell, for: indexPath) as! NewsCell
        
        if isLoading{
            cell.setSkeletonView()
        }else{
            
            cell.hideSkeletonView()
            
            let news = newsList[indexPath.row]
            cell.notificationImage.image = R.image.ic_news_icon()
            cell.headingLbl.text = news.title
            cell.descriptionLbl.text = news.description
            if news.isActive ?? true{
                cell.notificationReadImage.isHidden = false
            }else{
                cell.notificationReadImage.isHidden = true
            }
            cell.dateLbl.text = news.created_at
        }
        
        return cell
    }
    
}
