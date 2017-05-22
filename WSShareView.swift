//
//  WSShareView.swift
//  WolfStreet_iOS
//
//  Created by zwj on 16/12/26.
//  Copyright © 2016年 Wolf Street. All rights reserved.
//
/**
 使用说明：
 需要分享处加：
 let share = WSShareView.showInView(view: self.view, type: .InsideShare, shareImageURL: "shareImageURL" as AnyObject, shareContent: "shareContent", shareTitle: "shareTitle", shareUrl: "shareUrl")
 需传入参数：
 1.需要加载的View
 2.分享类型：见shareType枚举
 3.分享图片
 4.分享内容
 5.分享标题
 6.分享链接
分享参数尽量都传（需加分享类型--扩展可以如下处理：1加枚举，2处理扩展情况，3加对应图片文字）
 */

import UIKit
import SnapKit

//分享协议
protocol WSShareViewDelete : class {
    func clicked(view shareView : WSShareView, selectIndex index: Int)
}

private let kCellId = "cell"

enum shareType : Int{
    case GeneralShare = 0 //一般分享
    case InsideShare//含内部分享
    case blackShare//含拉黑分享
    case otherShare//其余分享（需添加其他分享）
}

class WSShareView: UIView {
     var type : shareType?
     var shareImageURL : AnyObject?
     var shareContent : String?
     var shareTitle : String?
     var shareUrl : String?
     fileprivate var titles  = NSMutableArray()
     fileprivate var images = NSMutableArray()
     let shareParames = NSMutableDictionary()//分享字典
     //var platformType : SSDKPlatformType?
    weak var delegate : WSShareView?
    
    //创建collection
    fileprivate lazy var collectionView : UICollectionView = {[weak self ] in
        let flowlayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame:(CGRect(x: 0, y: 0, width: self!.bounds.size.width, height: 230)),collectionViewLayout:flowlayout)
        collection.bounces = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        //注册
        collection.register(WSCollectionViewCell.self, forCellWithReuseIdentifier: kCellId)
        flowlayout.itemSize = CGSize(width:(mScreenWidth-61) / 5.0, height: 80)
        flowlayout.minimumLineSpacing = 10 ;//代表的是纵向的空间间隔
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical
        return collection
        }()
    
    fileprivate lazy var shareView: UIView = {[weak self] in
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.8
        //view.backgroundColor = UIColor.cyan
        return view
        }()
    
    fileprivate lazy var lineOne : UIImageView = {[weak self] in
        let line = UIImageView()
        line.image = UIImage.init(named: "line_left")
        return line
        }()
    
    fileprivate lazy var lineTwo : UIImageView = {[weak self] in
        let line = UIImageView()
        line.image = UIImage.init(named: "line_right")
        return line
        }()
    fileprivate lazy var titleLabel : UILabel = {[weak self] in
        let label = UILabel()
        label.text = "分享至"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.white
        return label
        }()
    
    //更新约束override继承父类加每次add
    override func layoutSubviews() {
        super.layoutSubviews()
        //移动动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        shareView.center = CGPoint(x: mScreenWidth/2.0, y: mScreenHeight - 250/2.0)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
        UIView.commitAnimations()
    }
  

    

    

    
    
    func mAlert(title:String,messge:String,Sure:(Bool) -> Void){
        let alert = UIAlertView(title: title, message: messge, delegate: self, cancelButtonTitle: "确定")
        alert.show()
        //    let alertVC = UIAlertController(title: "提示", message: "我是提示框", preferredStyle: UIAlertControllerStyle.alert)
        //    let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
        //        print("click Sure")
        //    }
        //    let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
        //        print("click Cancel")
        //    }
        //    alertVC.addAction(acSure)
        //    alertVC.addAction(acCancel)
        //    self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mAlert(title: "", messge: "", closure: {
        
        })
        self.setUpUI()
        self.layout()
        self.addTap()
    }
    
    static func showInView(view:UIView,type:shareType,shareImageURL : AnyObject,shareContent : NSString,shareTitle : NSString,shareUrl : NSString )->WSShareView?{
    let shareview = WSShareView(frame: view.bounds)
        shareview.createImageAndTitle(type: type)
        shareview.type = type
        shareview.shareImageURL = shareImageURL
        shareview.shareContent = shareContent as String
        shareview.shareTitle = shareTitle as String
        shareview.shareUrl = shareUrl as String
         //print("创建\(shareview)")
        view.addSubview(shareview)
    return shareview
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("销毁")
    }
}

extension WSShareView  {
    fileprivate func setUpUI() {
        addSubview(shareView)
        shareView.addSubview(lineOne)
        shareView.addSubview(lineTwo)
        shareView.addSubview(titleLabel)
        shareView.addSubview(collectionView)
    }
    
}

extension WSShareView {
    fileprivate func layout() {
        shareView.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(0)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(250)}
        collectionView.snp.updateConstraints { (make) in
            make.edges.equalTo(shareView).inset(UIEdgeInsetsMake(40, 0, 10, 0))//上左下右
        }
        
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(shareView).offset(15)
            make.centerX.equalTo(self)
        }
        
        lineOne.snp.updateConstraints { (make) in
            make.top.equalTo(shareView).offset(20)
            make.right.equalTo(titleLabel.snp.left).offset(-20)
            make.size.equalTo(CGSize(width: mScreenWidth * 0.42, height: 0.5))
        }
        
        lineTwo.snp.updateConstraints { (make) in
            make.top.equalTo(shareView).offset(20)
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.size.equalTo(CGSize(width: mScreenWidth * 0.42, height: 0.5))
        }
        
        
    }
}

extension WSShareView {
    fileprivate func addTap() {
        //创建点手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showShareView))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func showShareView(){
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(rawValue: 7), animations:{Void in
           // self.shareView.backgroundColor = UIColor.yellow
            self.shareView.frame = CGRect(x: 0, y: mScreenHeight, width: mScreenWidth, height: 230)
        }, completion: {Void in
            self.removeFromSuperview()
        })
    }
}

//协议代理 ========================
extension WSShareView : UICollectionViewDataSource {
    //先写了必须实现的代理
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! WSCollectionViewCell
       // cell.backgroundColor = UIColor.lightGray
        cell.title.text = titles[indexPath.row] as? String
        cell.image.image = UIImage.init(named: images[indexPath.row] as! String)
        return cell
    }
    
}

//colllection
extension WSShareView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击第\(indexPath.row)个分享")
        print("\(shareImageURL),\(shareContent),\(shareTitle),\(shareUrl)")
        share(types: indexPath.row,type:type!)
        
    }
}

//tap
extension WSShareView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.shareView)
//        print("touch=\(touch)")
//        print("touch.view=\(touch.view)")
//        print("touchPoint=\(touchPoint)")
        if self.shareView.bounds.contains(touchPoint) {
            return false
        }
        return true
    }
}

//分享
extension WSShareView {
    func share(types:NSInteger,type:shareType) {
        switch types {
        case 0:
          print("微信")
          shareSDK(platformType: SSDKPlatformType.typeWechat)
        case 1:
            print("朋友圈")
         shareSDK(platformType: SSDKPlatformType.subTypeWechatTimeline)
        case 2:
            print("QQ")
         shareSDK(platformType: SSDKPlatformType.typeQQ)
            
        case 3:
            print("空间")
        shareSDK(platformType: SSDKPlatformType.subTypeQZone)
        case 4:
            print("微博")
        shareContent = ""
        shareContent = shareContent! + shareUrl!
        shareSDK(platformType: SSDKPlatformType.typeSinaWeibo)
        case 5:
            //有类似扩展可以如下处理：1加枚举，2处理扩展情况，3加对应图片文字
            switch type {
            case .blackShare:
                print("拉黑")
            case .InsideShare:
                 print("沃夫动态")
            default:
                print("数据异常")
            }
        case 6:
            print("举报")
        default:
          print("其他")
        }
    }
    
    func shareSDK(platformType:SSDKPlatformType) {
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: shareContent as String!,
                                          images : UIImage(named: "share_pyq_icon_n"),
                                          url : NSURL(string:"http://mob.com") as URL!,
                                          title : shareTitle as String!,
                                          type : SSDKContentType.auto)
        
        //2.进行分享
        ShareSDK.share(platformType, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            switch state{
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
            case SSDKResponseState.cancel:  print("操作取消")
            default:
                break
            }
        }}
}

extension WSShareView {
    func createImageAndTitle(type:shareType) {
        switch type {
        case .GeneralShare:
           titles = ["微信","朋友圈","QQ","空间","微博"]
            images = ["share_weixin_icon_n","share_pyq_icon_n","sharev_QQ_icon_n","share_Qzone_icon_n","sharev_weibo_icon_n"]
        case .blackShare:
          titles = ["微信","朋友圈","QQ","空间","微博","拉黑","举报"]
           images = ["share_weixin_icon_n","share_pyq_icon_n","sharev_QQ_icon_n","share_Qzone_icon_n","sharev_weibo_icon_n","share_lh_icon_n","share_report_icon_n"]
        case .InsideShare:
            titles = ["微信","朋友圈","QQ","空间","微博","沃夫动态"]
            images = ["share_weixin_icon_n","share_pyq_icon_n","sharev_QQ_icon_n","share_Qzone_icon_n","sharev_weibo_icon_n","share_wolfdongtai"]
        default:
          print("需要自定义的图片文字")
        }
 
    }
    
}


