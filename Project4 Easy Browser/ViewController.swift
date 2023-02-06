//
//  ViewController.swift
//  Project4 Easy Browser
//
//  Created by Reza Koushki on 06/02/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
	
	var webView: WKWebView!
	var progressView: UIProgressView!
	var websites = ["apple.com", "hackingwithswift.com"]
	
	override func loadView() {
		super.loadView()
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		navigationController?.navigationBar.backgroundColor = .white
		
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		
		
		toolbarItems = [progressButton, spacer, refresh]
		navigationController?.isToolbarHidden = false
		
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		
		let url = URL(string: "https://" + websites[0])!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		
		
	}
	
	@objc func openTapped() {
		let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
		
		for website in websites {
			ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
		}
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}
	
	func openPage(action: UIAlertAction) {
		guard let actionTitle = action.title else { return }
		guard let url = URL(string: "https://" + actionTitle) else { return }
		webView.load(URLRequest(url: url))
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		
		if let host = url?.host {
			for website in websites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
		}
		
		let urlString = url?.absoluteString ?? "Unknown"
		if urlString != "about:blank" {
			notAllowedAlert()
		}
		
		decisionHandler(.cancel)
		
	}
	
	func notAllowedAlert() {
		let alert = UIAlertController(title: "DENIED", message: "Easy now. You are not allowed to visit this website", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	
}

