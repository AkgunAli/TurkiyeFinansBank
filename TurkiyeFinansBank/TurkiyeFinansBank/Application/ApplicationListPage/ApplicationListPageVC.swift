//
//  ApplicationListPageVC.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 31.01.2022.
//

import UIKit

class ApplicationListPageVC: UIViewController {
    let viewModel = ApplicationListPageVM()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.documentsResponse.append(Documents(documentName: "başlık1", documentModelName: ["Test2","Test3"]))
        viewModel.documentsResponse.append(Documents(documentName: "başlık2", documentModelName: ["Test5","Test6"]))
        viewModel.documentsResponse.append(Documents(documentName: "başlık3", documentModelName: ["Test5","Test6"]))
        viewModel.documentsResponse.append(Documents(documentName: "başlık4", documentModelName: ["Test5","Test6"]))
        
        searchBar.delegate = self
        viewModel.filteredData = viewModel.documentsResponse
        viewModel.dataCopy = viewModel.documentsResponse
        
        tableView.register(UINib(nibName: DocumentListCell().nibName, bundle: nil), forCellReuseIdentifier: DocumentListCell().nibName)
        title = "Component List Page"

    }
}


extension ApplicationListPageVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.documentsResponse.count == 0 {
            self.tableView.setEmptyMessage("Arama sonuçlarınız burada görünecektir.")
        } else if viewModel.filteredData.count == 0{
            self.tableView.setEmptyMessage("Aradığınız sonuç bulunamadı")
        } else {
            self.tableView.restore()
        }
        return viewModel.filteredData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.filteredData.count
        return viewModel.filteredData[section].documentModelName?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
////        cell.textLabel?.text = viewModel.documentsResponse[indexPath.section].documentModelName?[indexPath.row]
//        cell.textLabel?.text = viewModel.filteredData[indexPath.section].documentModelName?[indexPath.row]
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentListCell", for:indexPath) as! DocumentListCell

        cell.artistName.text = viewModel.filteredData[indexPath.section].documentModelName?[indexPath.row]
        cell.artistType.text = viewModel.filteredData[indexPath.section].documentModelName?[indexPath.row]
        cell.artistKind.text = viewModel.filteredData[indexPath.section].documentModelName?[indexPath.row]
        return cell
    }

    private func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.filteredData[section].documentName
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        let lblHeader = UILabel.init(frame: CGRect(x: 15, y: 13, width: tableView.bounds.size.width - 10, height: 24))
            lblHeader.text = viewModel.filteredData[section].documentName
        lblHeader.textColor = UIColor.black
        headerView.addSubview(lblHeader)
        headerView.backgroundColor = UIColor.gray
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension ApplicationListPageVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        viewModel.filteredData = searchText.isEmpty ? viewModel.documentsResponse : viewModel.documentsResponse.filter { (service: Documents) -> Bool in
//
//            if let name = service.documentName,
//                let searchText = self.searchBar.text?.lowercased() {
//                return name.lowercased().contains(searchText)
//            } else {
//                return false
//            }
//        }

        viewModel.filteredData = searchText.isEmpty ? viewModel.documentsResponse : viewModel.documentsResponse.filter { (document: Documents) -> Bool in

            if let name = document.documentModelName,
                let searchText = self.searchBar.text?.lowercased() {
                let a = name.filter { (service2: String) -> Bool in
                    return service2.lowercased().contains(searchText)
                }
//                if  viewModel.filteredData.count != 0 {
//                    for i in 0...viewModel.filteredData.count - 1 {
//                        viewModel.dataCopy[i].documentModelName = viewModel.filteredData[i].documentModelName?.filter { (service2: String) -> Bool in
//                            return service2.lowercased().contains(searchText)
//                        }
//                    }
//                }
                if a.isEmpty{
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
        tableView.reloadData()
    }
}
