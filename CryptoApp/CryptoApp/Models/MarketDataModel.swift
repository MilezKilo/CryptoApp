//
//  MarketDataModel.swift
//  CryptoApp
//
//  Created by Майлс on 21.01.2022.
//

import Foundation

//JSON Data
/*
 
 URL: https://api.coingecko.com/api/v3/global
 
 {
   "data": {
     "active_cryptocurrencies": 12691,
     "upcoming_icos": 0,
     "ongoing_icos": 50,
     "ended_icos": 3375,
     "markets": 724,
     "total_market_cap": {
       "btc": 49785550.91536508,
       "eth": 675638791.8477376,
       "ltc": 15502691980.273014,
       "bch": 5644555985.1133375,
       "bnb": 4519320104.84599,
       "eos": 759228894037.8175,
       "xrp": 2800352555957.9473,
       "xlm": 8510378857589.879,
       "link": 99077376654.28389,
       "dot": 86283557607.73578,
       "yfi": 66938301.30961542,
       "usd": 1934333491456.0996,
       "aed": 7104797242450.779,
       "ars": 201683097724988.28,
       "aud": 2687624851700.829,
       "bdt": 166642308018899.97,
       "bhd": 729266938280.8448,
       "bmd": 1934333491456.0996,
       "brl": 10482540056898.91,
       "cad": 2421371583935.866,
       "chf": 1765131537957.9583,
       "clp": 1539245875826191,
       "cny": 12264448069228.227,
       "czk": 41575790331960.8,
       "dkk": 12705187889589.994,
       "eur": 1707033831542.0745,
       "gbp": 1426553540947.452,
       "hkd": 15064465434116.65,
       "huf": 610660815911348.8,
       "idr": 27684320453194412,
       "ils": 6074861374925,
       "inr": 143961806803541.53,
       "jpy": 220214518730182.3,
       "krw": 2304909621883307.5,
       "kwd": 584865074476.6669,
       "lkr": 392501986248878.44,
       "mmk": 3446237253887197.5,
       "mxn": 39636274761081.08,
       "myr": 8098087161980.945,
       "ngn": 797600872529828.1,
       "nok": 17145872103928.635,
       "nzd": 2875541481728.8047,
       "php": 99193594411615.11,
       "pkr": 342077923934279.2,
       "pln": 7743446459657.387,
       "rub": 148335975092109.4,
       "sar": 7255564997775.341,
       "sek": 17790210195933.59,
       "sgd": 2602866226772.204,
       "thb": 63638604702160.12,
       "try": 25954786203016.38,
       "twd": 53549121210724.86,
       "uah": 54894136792006.89,
       "vef": 193684812499.49908,
       "vnd": 43773106823804850,
       "zar": 29271398276134,
       "xdr": 1379526025103.1711,
       "xag": 79277632950.57773,
       "xau": 1054559932.8720365,
       "bits": 49785550915365.08,
       "sats": 4978555091536508
     },
     "total_volume": {
       "btc": 3074069.802451044,
       "eth": 41718144.50571108,
       "ltc": 957232698.9867513,
       "bch": 348530020.920709,
       "bnb": 279050953.66995937,
       "eos": 46879517719.46046,
       "xrp": 172911197530.40894,
       "xlm": 525483763311.34985,
       "link": 6117653939.328085,
       "dot": 5327683916.5824175,
       "yfi": 4133187.378664744,
       "usd": 119437789973.71141,
       "aed": 438694405384.491,
       "ars": 12453169825018.957,
       "aud": 165950687398.75366,
       "bdt": 10289533358031.926,
       "bhd": 45029480073.568756,
       "bmd": 119437789973.71141,
       "brl": 647257271425.5378,
       "cad": 149510553360.03238,
       "chf": 108990208171.34082,
       "clp": 95042621371580.84,
       "cny": 757283363549.3182,
       "czk": 2567148082578.9624,
       "dkk": 784497383432.6185,
       "eur": 105402894149.48042,
       "gbp": 88084295165.5025,
       "hkd": 930173864296.7062,
       "huf": 37705999817586.375,
       "idr": 1709402265151547,
       "ils": 375099754112.98975,
       "inr": 8889098038774.068,
       "jpy": 13597415106253.607,
       "krw": 142319466908290.84,
       "kwd": 36113210176.45142,
       "lkr": 24235515749959.32,
       "mmk": 212792139073967.28,
       "mxn": 2447390318765.9106,
       "myr": 500026307724.9419,
       "ngn": 49248842516992.95,
       "nok": 1058692867755.4889,
       "nzd": 177553829819.1197,
       "php": 6124829947060.285,
       "pkr": 21122020279321.07,
       "pln": 478128583311.16174,
       "rub": 9159186415813.11,
       "sar": 448003745048.412,
       "sek": 1098478312222.4707,
       "sgd": 160717162317.68546,
       "thb": 3929443571240.129,
       "try": 1602610055102.1804,
       "twd": 3306456058737.235,
       "uah": 3389505692741.971,
       "vef": 11959305910.067715,
       "vnd": 2702824079927839.5,
       "zar": 1807398328666.6865,
       "xdr": 85180523615.66162,
       "xag": 4895094520.043874,
       "xau": 65115094.33786799,
       "bits": 3074069802451.044,
       "sats": 307406980245104.4
     },
     "market_cap_percentage": {
       "btc": 38.03518446163811,
       "eth": 17.650104999386663,
       "usdt": 4.041477996974974,
       "bnb": 3.7204218797348294,
       "usdc": 2.1843298028259976,
       "ada": 2.037589323517953,
       "sol": 2.002897896564629,
       "xrp": 1.7020473642652716,
       "luna": 1.4127556308502167,
       "dot": 1.2469775798773592
     },
     "market_cap_change_percentage_24h_usd": -7.871624602277836,
     "updated_at": 1642764112
   }
 }
 */

// MARK: - Welcome
struct GlobalData: Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCup: String {
        /*
        if let item = totalVolume.first(where: { (key, value) -> Bool in
            return key == "usd"
        }) {
            return "\(item.value)"
        }
         */
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
