//
//  StockDetailsViewController.swift
//  hello-world
//
//  Created by Mateusz Rybka on 12/01/2020.
//  Copyright © 2020 Guest User. All rights reserved.
//

import UIKit
import Charts

class StockDetailsViewController: UIViewController {

    @IBOutlet weak var stockDetailsTabView: UITableView!
    
    @IBOutlet weak var historyChartView: LineChartView!
    
    var company: SymbolModel?
    var stockHistory: [PriceModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.stockDetailsTabView.rowHeight = UITableView.automaticDimension
        self.stockDetailsTabView.estimatedRowHeight = 50
        self.stockDetailsTabView.register(UINib(nibName: "StockTableViewCell", bundle: nil), forCellReuseIdentifier: "stockCell")
        self.stockDetailsTabView.reloadData()
        
        setChartValues(history: stockHistory)
    }
    
    func setChartValues(history: [PriceModel]) {
        let count = history.count
        let values = (0..<count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: history[i].close)
        }
        
        let set = LineChartDataSet(entries: values, label: "\(company?.symbol ?? "XYZ")")
        let data = LineChartData(dataSet: set)
        self.historyChartView.data = data
    }

}

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ stockDetailsTabView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stockDetailsTabView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockTableViewCell
        cell.nameLabel.text = self.company?.name
        cell.symbolLabel.text = self.company?.symbol
        cell.priceLabel.text = self.company?.price
        return cell
    }
}
