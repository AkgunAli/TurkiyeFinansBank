//
//  ApplicationDetailPageVC.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 31.01.2022.
//

import UIKit
import Kingfisher


class ApplicationDetailPageVC: UIViewController {
    let viewModel = ApplicationDetailPageVM()
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var documentKind: UILabel!
    @IBOutlet weak var documentWrapperType: UILabel!
    @IBOutlet weak var documentInformation: UILabel!
    @IBOutlet weak var documentTrackName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        setUI()
    }
    
    func setUI() {
        if let imageUrl = URL(string: viewModel.document?.artworkUrl100 ?? "") {
            documentImage.kf.setImage(with: imageUrl, placeholder: #imageLiteral(resourceName: "singer-bg"))
        }
        documentName.text = viewModel.document?.artistName
        documentKind.text =  viewModel.document?.kind
        documentWrapperType.text = viewModel.document?.wrapperType
        documentInformation.text = viewModel.document?.collectionName
        documentTrackName.text = viewModel.document?.trackName
        
    }
}
