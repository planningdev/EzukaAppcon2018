//
//  FirstViewController.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/04.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class FirstViewController: UIViewController {

    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    let appModel = AppModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.tapLabel.alpha)
        print("\(self) viewWillAppear")
        // navigationBarを非表示
        navigationController?.navigationBar.isHidden = true
        // tapLabelを点滅
        UILabel.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.tapLabel.alpha = 0
        }, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(tapLabel.alpha)
        tapLabel.alpha = 1
    }
    
    func setup() {
        // tapGestureの設定
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(toQRCodeReaderView))
        self.view.addGestureRecognizer(tapGR)
//      最初はactivityIndicatorを隠す
        self.activityIndicator.isHidden = true
    }
    
    @objc func toQRCodeReaderView() {
        readerVC.delegate = self
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .fullScreen
        readerVC.codeReader.switchDeviceInput()
        present(readerVC, animated: true, completion: nil)
    }
    
//    汚いけどしょうがない
    func toListView(token: String) {
        
        // tokenから状態取得
//        guard let token = token else { return }
//        guard let request = Router.fetchVoteStatus(token: token).makeURLRequest(token) else { return }
        startCommunicating()
        appModel.getVoteStatus(token,
                               onSuccess: {[weak self] (status) in
                                DispatchQueue.main.async {
                                    print(status)
                                    if !status.app && !status.idea {
                                        self?.stopCommunicating()
                                        self?.presentCompletedAlart()
                                    } else {
                                        let selectVoteVC = self?.storyboard!.instantiateViewController(withIdentifier: "SelectVoteKind") as! SelectVoteKindViewController
                                        selectVoteVC.voteStatus = status
                                        selectVoteVC.token = token
                                        self?.stopCommunicating()
                                        self?.navigationController?.pushViewController(selectVoteVC, animated: true)
                                    }
                                }
            },
                               onError: { [weak self] () in
                                self?.stopCommunicating()
                                // エラーダイアログを表示
        })
    }
    
    private func startCommunicating() {
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    private func stopCommunicating() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    func presentCompletedAlart() {
        let alertVC = UIAlertController(title: "投票済みです", message: "ありがとうございました", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alertVC.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }))

        present(alertVC, animated: true, completion: nil)
    }
}

extension FirstViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: { () in self.toListView(token: result.value) })
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}
