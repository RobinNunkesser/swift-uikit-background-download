//
//  ViewController.swift
//  BackgroundDownloadExample
//
//  Created by Prof. Dr. Nunkesser, Robin on 09.03.23.
//

import UIKit

class ViewController: UIViewController {

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://ipv4.download.thinkbroadband.com/512MB.zip")!
        
        downloadFile(url: url)
    }
    
    func downloadFile(url: URL) {
        let backgroundTask = urlSession.downloadTask(with: url)
        backgroundTask.earliestBeginDate = Date()//.addingTimeInterval(60 * 60)        
        backgroundTask.countOfBytesClientExpectsToSend = 200            // 200 Bytes
        backgroundTask.countOfBytesClientExpectsToReceive = 500 * 1024  // 500 kB
        backgroundTask.resume()
    }


}

extension ViewController : URLSessionDownloadDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler =
                appDelegate.backgroundCompletionHandler else {
                    return
            }
            backgroundCompletionHandler()
        }
    }
        
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        debugPrint(location)
    }
}

