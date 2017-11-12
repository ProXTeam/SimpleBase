//
//  SimpleViewController.swift
//  iOS Sample
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import PagingKit

class SimpleViewController: UIViewController {
    
    var menuViewController: PagingMenuViewController?
    var contentViewController: PagingContentViewController?
    
    var dataSource: [(menu: String, content: UIViewController)]! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewController?.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "identifier")
        menuViewController?.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        
        setupSource()
        
        menuViewController?.reloadData()
        contentViewController?.reloadData()

    }
    
    func setupSource() {
        
        let sb1 = UIStoryboard(name: "Pager", bundle: nil)
        let vc1 = sb1.instantiateViewController(withIdentifier: "contentVC") as! ContentTableViewController
        
        let sb2 = UIStoryboard(name: "Main", bundle: nil)
        let vc2 = sb2.instantiateViewController(withIdentifier: "searchVC") as! SearchYoutubeVC
        
        dataSource = [("Animal", vc1),("Youtube", vc2)]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController?.dataSource = self
            menuViewController?.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController?.delegate = self
            contentViewController?.dataSource = self
        }
    }
}

extension SimpleViewController: PagingMenuViewControllerDataSource {
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index)  as! MenuCell
        cell.isSelected = (viewController.currentFocusedIndex == index)
        cell.titleLabel.text = dataSource[index].menu
        return cell
    }

    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return viewController.view.bounds.width / CGFloat(dataSource.count)
    }

    var insets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
}

extension SimpleViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt Index: Int) -> UIViewController {
        return dataSource[Index].content
    }
}

extension SimpleViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        viewController.visibleCells.forEach { $0.isSelected = false }
        viewController.cellForItem(at: page)?.isSelected = true
        contentViewController?.scroll(to: page, animated: true)
    }
}

extension SimpleViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        let isRightCellSelected = percent > 0.5
        menuViewController?.cellForItem(at: index)?.isSelected = !isRightCellSelected
        menuViewController?.cellForItem(at: index + 1)?.isSelected = isRightCellSelected
        menuViewController?.scroll(index: index, percent: percent, animated: false)
    }
}

