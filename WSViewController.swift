//
//  WSViewController.swift
//  WolfStreet_iOS
//
//  Created by zwj on 16/12/23.
//  Copyright © 2016年 Wolf Street. All rights reserved.
//

import UIKit

class WSViewController: UIViewController {
    
    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red;

       // View.delegate = self//遵守代理
      //  View.backgroundColor = UIColor.clear
       // View.alpha = 0.3
     
        btn.backgroundColor = UIColor.blue
        btn.tintColor = UIColor.lightGray
        btn.setTitle("分享", for:UIControlState.normal)
        btn.frame = CGRect(x: 180, y: 200, width: 80, height: 40)
        view.addSubview(btn)
        
        btn .addTarget(self, action: #selector(showShareView), for: UIControlEvents.touchUpInside)
    }

    func showShareView() {
        
    let share = WSShareView.showInView(view: self.view, type: .InsideShare, shareImageURL: "分享图片url" as AnyObject, shareContent: "分享内容", shareTitle: "分享标题", shareUrl: "分享链接")
   
    share?.backgroundColor = UIColor.clear
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
