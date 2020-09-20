//
//  FAQViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 19.08.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController{
    
    @IBOutlet weak var faqTable: UITableView!
    
    let model = DataModel.sharedData
    var selectedIndexes = [Int]()
    var heightLabel = 0
    var isTapped = [Bool]()
    var labels1size = [CGFloat]()
    var labels2size = [CGFloat]()
    var specialWords = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        setWords()
        for _ in 0..<model.faq.count {
            isTapped.append(false)
            labels1size.append(0)
            labels2size.append(0)
        }
        faqTable.reloadData()
    }
    
    private func setWords(){
        for number in 0..<model.faq.count {
            if model.faq[number].question == "You have not received your order in time"{
                specialWords.append(number)
            }
            if model.faq[number].question == "Описание процесса передачи данных "{
                specialWords.append(number)
            }
        }
    }
    
    private func registerTableViewCells() {
        faqTable.delegate = self
        faqTable.dataSource = self
        let faq1Cell = UINib(nibName: "faq1cell",
                                  bundle: nil)
        self.faqTable.register(faq1Cell,
                                forCellReuseIdentifier: "faq1cell")
        let faq2Cell = UINib(nibName: "faq2cell",
                                  bundle: nil)
        self.faqTable.register(faq2Cell,
                                forCellReuseIdentifier: "faq2cell")
        faqTable.tableFooterView = UIView(frame: .zero)
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.faq.count
        //"TimesNewRomanPSMT" self.view.frame.width
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "faq2cell") as? faq2cell {
            //cell.answerLabel.adjustsFontSizeToFitWidth = true
            //cell.questionLabel.adjustsFontSizeToFitWidth = true
            var cell1Size = model.faq[indexPath.row].question?.height(withConstrainedWidth: cell.questionLabel.frame.size.width, font: UIFont(name: "TimesNewRomanPSMT", size: 21)!)
            print(model.faq[indexPath.row].question!)
            if model.faq[indexPath.row].question == "Не получили свой заказ в срок?" {
                for number in 0..<model.faq.count {
                    if model.faq[number].question == "Доставка" || model.faq[number].question == "What is HOTEL STORE?" {
                        cell1Size = self.labels1size[number]
                        break
                    }
                }
            }
            
            if model.faq[indexPath.row].question == "Описание процесса передачи данных " || model.faq[indexPath.row].question == "Описание процесса передачи данных" || model.faq[indexPath.row].question == "You have not received your order in time"{
                for number in 0..<model.faq.count {
                    if model.faq[number].question == "How to place an order in the hotel you are staying in?" || model.faq[number].question == "Как сделать заказ в отель, в котором вы остановились?" {
                        cell1Size = self.labels1size[number]
                        break
                    }
                }
            }
            
            self.labels1size[indexPath.row] = cell1Size!
            let cell2Size = model.faq[indexPath.row].answer?.height(withConstrainedWidth: cell.questionLabel.frame.size.width, font: UIFont(name: "TimesNewRomanPSMT", size: 18.1)!)
            self.labels2size[indexPath.row] = cell2Size!
            cell.questionLabel.adjustsFontSizeToFitWidth = true
            cell.questionLabel.text = model.faq[indexPath.row].question ?? "Question\(indexPath.row + 1)"
            cell.answerLabel.text = model.faq[indexPath.row].answer ?? "Answer\(indexPath.row + 1)"
            cell.plusMinusImage.image = UIImage(named: "plus")
            if selectedIndexes.contains(indexPath.row) {
                cell.plusMinusImage.image = UIImage(named: "minus")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexes.contains(indexPath.row) {
            self.selectedIndexes.remove(at: self.selectedIndexes.firstIndex(of: indexPath.row)!)
            isTapped[indexPath.row] = true
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            isTapped[indexPath.row] = false
            self.selectedIndexes.append(indexPath.row)
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if specialWords.contains(indexPath.row) {
            
        }
        if selectedIndexes.contains(indexPath.row) {
            if !isTapped[indexPath.row] {
                return labels2size[indexPath.row] + labels1size[indexPath.row] + 100
            } else {
                return labels1size[indexPath.row] + 35
            }
        } else {
            return labels1size[indexPath.row] + 35
        }
    }
}
