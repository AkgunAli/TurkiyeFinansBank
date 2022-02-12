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

        searchBar.delegate = self
        viewModel.filteredData = viewModel.documentsResponse
        viewModel.dataCopy = viewModel.documentsResponse
        
        tableView.register(UINib(nibName: DocumentListCell().nibName, bundle: nil), forCellReuseIdentifier: DocumentListCell().nibName)
        title = viewModel.title
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        viewModel.filteredData[section].documentModelName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentListCell", for:indexPath) as! DocumentListCell
        guard let items = viewModel.responseService?[indexPath.row] else { return cell }
        cell.configure(for: items)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplicationDetailPageVC") as! ApplicationDetailPageVC
        vc.viewModel.document = viewModel.responseService?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    private func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.filteredData[section].documentName
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
         50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         100
    }
}


extension ApplicationListPageVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewModel.searchContent(term: text, completion: {
            self.tableView.reloadData()
        })
        
    }
}

