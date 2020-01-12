//
//  StockViewController.swift
//  hello-world
//
//  Created by Mateusz Rybka on 11/01/2020.
//  Copyright © 2020 Guest User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let stocksServiceBaseURL = "https://financialmodelingprep.com/api/v3"
let symbolsListURL = "/company/stock/list"
let historicalPriceURL = "/historical-price-full/"

class StockViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var stockDetailsTabView: UITableView!
    var stockDetails: StockDetailsViewController = StockDetailsViewController()
    
    var symbolsList: [SymbolModel] = []
    var stockHistory: [PriceModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(UINib(nibName: "StockTableViewCell", bundle: nil), forCellReuseIdentifier: "stockCell")
        
        getAllStocks()
    }

    func getAllStocks() {
        DispatchQueue.main.async {
            Alamofire.request(stocksServiceBaseURL + symbolsListURL).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let data = json["symbolsList"]
                    data.array?.forEach({(symbol) in
                        let symbol = SymbolModel(
                            symbol: symbol["symbol"].stringValue,
                            name: symbol["name"].stringValue,
                            price: symbol["price"].stringValue + "$")
                        self.symbolsList.append(symbol)
                    })
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getStockDetails(companySymbol: String) {
        DispatchQueue.main.async {
            Alamofire.request(stocksServiceBaseURL + historicalPriceURL + companySymbol + "?serietype=line&timeseries=30").responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let data = json["historical"]
                    data.array?.forEach({(price) in
                        let price = PriceModel(
                            date: price["date"].stringValue,
                            close: price["close"].double ?? 0)
                        self.stockHistory.append(price)
                    })
                    self.stockDetails.stockHistory = self.stockHistory
                    self.navigationController?.pushViewController(self.stockDetails, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let company = symbolsList[row]
        self.stockDetails.company = company
        
        getStockDetails(companySymbol: company.symbol)
    }
}

extension StockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbolsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockTableViewCell
        cell.nameLabel.text = self.symbolsList[indexPath.row].name
        cell.symbolLabel.text = self.symbolsList[indexPath.row].symbol
        cell.priceLabel.text = self.symbolsList[indexPath.row].price
        return cell
    }
}
