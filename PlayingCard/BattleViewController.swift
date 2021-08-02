//
//  BattleViewController.swift
//  BattleViewController
//
//  Created by 連振甫 on 2021/8/2.
//

import UIKit

class BattleViewController: UIViewController {

    var currentCards = [Card]()
    var mineCards = [Card]()
    var pcCards = [Card]()
    
    var minePoint = 0
    var pcPoint = 0
    var money = 1000
    @IBOutlet weak var pcPointLabel: UILabel!
    @IBOutlet weak var minePointLabel: UILabel!
    @IBOutlet var mineCardImageViews: [UIImageView]!
    @IBOutlet weak var mineBGCard: UIImageView!
    @IBOutlet var pcCardImageViews: [UIImageView]!
    @IBOutlet weak var pcBGCard: UIImageView!
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    
    //computed property
    /**
     抽牌
     */
    var dealCard: Card {
        let card = currentCards.first!
        currentCards.removeFirst()
        return card
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    @IBAction func pay(_ sender: UIButton) {
        
        if money <= 0  {
            self.showAlert(title: "失敗", msg: "你沒錢了", handler: nil)
            return
        }
        
        
        payButton.isEnabled = false
        self.startButton.isEnabled = true
        self.stopButton.isEnabled = false
        self.dealButton.isEnabled = true
        money -= 100
        moneyLabel.text = "籌碼:\(money)"
    }
    @IBAction func start(_ sender: UIButton) {
        self.stopButton.isEnabled = true
        self.startButton.isEnabled = false
        resetGame()
        
    }
    
    @IBAction func stop(_ sender: Any) {
        
        battle()
        
    }
    @IBAction func deal(_ sender: Any) {
        dealMineCard()
    }
    
    
    func battle(){
        //TODO: 與電腦決鬥，分數沒有比對手高就會一直抽。抽到滿5張或爆炸。
        while (pcPoint < 20 && pcPoint < minePoint),pcCards.count < 5 {
            
                let pcCard = dealCard
                pcCards.append(pcCard)
                updatePCUI()
        }
        self.updatePCUI()
        pcBGCard.isHidden = true
        pcPointLabel.text = "Point:\(pcPoint)"
        
        //TODO: 判斷輸贏。
        if pcCards.count == 5,pcPoint < 22 {
            showAlert(title: "你輸了", msg: "莊家過五關！",handler: { _ in
                self.mineCards.removeAll()
                self.pcCards.removeAll()
                self.updateMineUI()
                self.updatePCUI()
            })
        }else if mineCards.count == 5,minePoint < 22 {
            showAlert(title: "你贏了", msg: "過五關！",handler: { _ in
                self.mineCards.removeAll()
                self.pcCards.removeAll()
                self.updateMineUI()
                self.updatePCUI()
                self.money += 200
                self.moneyLabel.text = "籌碼:\(self.money)"
            })
        }else if minePoint > pcPoint || pcPoint > 21 {
            showAlert(title: "你贏了", msg: "恭喜！",handler: { _ in
                self.mineCards.removeAll()
                self.pcCards.removeAll()
                self.updateMineUI()
                self.updatePCUI()
                self.money += 200
                self.moneyLabel.text = "籌碼:\(self.money)"
            })
        }else {
            showAlert(title: "你輸了", msg: "再加油！",handler: { _ in
                self.mineCards.removeAll()
                self.pcCards.removeAll()
                self.updateMineUI()
                self.updatePCUI()
            })
        }
        payButton.isEnabled = true
        self.startButton.isEnabled = false
        self.stopButton.isEnabled = false
        self.dealButton.isEnabled = false
    }
    
    func resetGame() {
        
        pcCards.removeAll()
        mineCards.removeAll()
        mineCardImageViews.forEach({$0.image = nil})
        pcCardImageViews.forEach({$0.image = nil})
        currentCards = CardManager.shared.getNewCards()
        pcBGCard.isHidden = false
        mineBGCard.isHidden = true
        
        
        pcCards.append(dealCard)
        pcCards.append(dealCard)
        updatePCUI()
        pcPointLabel.text = "Point:\(pcCards[1].point)"
        
        dealMineCard()
        dealMineCard()
        updateMineUI()
    }

    func dealMineCard() {
        
        let mineCard = dealCard
        mineCards.append(mineCard)
        
        //TODO: 抽牌後更新分數及介面
        updateMineUI()
        
        //TODO: 爆炸判斷
        if minePoint > 21 {
            showAlert(title: "你輸了", msg: "超過21點！",handler: { _ in
                self.mineCards.removeAll()
                self.pcCards.removeAll()
                self.updateMineUI()
                self.updatePCUI()
                self.pcBGCard.isHidden = true
                self.payButton.isEnabled = true
                self.startButton.isEnabled = false
                self.stopButton.isEnabled = false
                self.dealButton.isEnabled = false
            })
        }
        
        //TODO: 收集5張牌進行決鬥
        if mineCards.count == 5 {
            battle()
        }
    }
    
    func updateMineUI() {
        
        minePoint = 0
        
        if mineCards.count == 0 {
            mineCardImageViews.forEach({$0.image = nil})
        }
        
        
        for i in mineCards.indices {
            let card = mineCards[i]
            mineCardImageViews[i].image = UIImage(named: "\(card.imageName)")
            self.minePoint += card.point
        }
        
        //TODO: 檢查是否有超過A，有的話判斷分數大於21自動將A已1分計算
        for card in mineCards.filter({$0.number == 1}) {
            if minePoint > 21 {
                minePoint -= 10
            }
        }
        minePointLabel.text = "Point:\(minePoint)"
        
    }
    
    func updatePCUI() {
        
        pcPoint = 0
        
        if pcCards.count == 0 {
            pcCardImageViews.forEach({$0.image = nil})
        }
        
        
        for i in pcCards.indices {
            let card = pcCards[i]
            print("debug123",i)
            pcCardImageViews[i].image = UIImage(named: "\(card.imageName)")
            self.pcPoint += card.point
        }
        
        for card in pcCards.filter({$0.number == 1}) {
            if pcPoint > 21 {
                pcPoint -= 10
            }
        }
        pcPointLabel.text = "Point:\(pcPoint)"
        
    }
    
    
    func showAlert(title:String, msg:String, handler: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
