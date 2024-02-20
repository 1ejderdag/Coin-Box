//
//  CoinManager.swift
//  Coin-Box
//
//  Created by Ejder Dağ on 19.02.2024.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "503B177C-32EA-4E94-B990-FA338017B708"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","TRY","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {(data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let price = self.parseJson(safeData) {
                        let priceString = String(format: "%.2f", price)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJson(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
}
