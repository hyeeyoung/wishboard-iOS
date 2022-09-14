//
//  ItemDetailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class ItemDetailViewController: UIViewController {
    var itemDetailView: ItemDetailView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        itemDetailView = ItemDetailView()
        self.view.addSubview(itemDetailView)
        
        itemDetailView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        itemDetailView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        itemDetailView.deleteButton.addTarget(self, action: #selector(alertDialog), for: .touchUpInside)
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func alertDialog() {
        let dialog = PopUpViewController(titleText: "아이템 삭제", messageText: "정말 아이템을 삭제하시겠어요?\n삭제된 아이템은 다시 복구할 수 없어요!", greenBtnText: "취소", blackBtnText: "삭제")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
    }
    @objc func alertMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let defaultAction =  UIAlertAction(title: "아이템 수정", style: UIAlertAction.Style.default)
        let cancelAction = UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel, handler: nil)
        let destructiveAction = UIAlertAction(title: "아이템 삭제", style: UIAlertAction.Style.destructive){(_) in
            self.dismiss(animated: true)
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addAction(destructiveAction)

        self.present(alert, animated: true)
    }

}
