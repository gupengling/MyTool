//
//  HomeViewController.swift
//  MyTool
//
//  Created by 顾鹏凌 on 2017/1/10.
//  Copyright © 2017年 顾鹏凌. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DetailDelegate {

    @IBOutlet var tabViewList :UITableView!
    var dataArray = NSMutableArray()
    let cellID = "testCellID"

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.title = "UITableView"
        // 添加nav右侧按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.done, target: self, action:#selector(HomeViewController.rightBarButtonItemClicked))
        

        let itemCom :ListItemModel = ListItemModel.init(name: "换算器", isShow: true);
        let itemView :ListItemModel = ListItemModel.init(name: "view", isShow: true);
        let itemOther :ListItemModel = ListItemModel.init(name: "其他", isShow: true);
        
        itemOther.isShow = false
        // 数据源数组
        self.dataArray = [itemCom,itemView,itemOther]
        
        self.tabViewList.delegate = self
        self.tabViewList.dataSource = self
        self.tabViewList.rowHeight = 60.0
        self.tabViewList.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellID)// cell的第二种写法 注册cell
        
        // 去掉没有数据的cell的分割线
        self.tabViewList.tableFooterView = UIView()

        
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
    //MARK:- 按钮点击clicked
    func rightBarButtonItemClicked(){
        
        if self.tabViewList.isEditing {
            self.tabViewList.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "编辑"
        }else {
            self.tabViewList.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "完成"
        }
        
    }
    //MARK:- 代理和协议tableview
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         //cell的写法1：
         var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? UITableViewCell
         if cell == nil {
         cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
         }
         cell!.textLabel!.text = self.dataArray[indexPath.row] as? String
         return cell!
         */
        
        // cell的写法2：
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath)
        
        let model = whitchModel(tag: indexPath.row)
        cell.textLabel!.text = model.name
        return cell

    }
    //  返回的cell的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    //  cell选中时的状态
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let model = whitchModel(tag: indexPath.row)
        if model.isShow {
            print("\(model)")
            let lecturedetail = self.storyboard?.instantiateViewController(withIdentifier: "detailvc") as! DetailViewController
            lecturedetail.detailDelegate = self;
            
            lecturedetail.setMyChangeName(tempClose: { (name) in
                print("block \(name) 回调啦")
            })
            
//            weak var WeakSelf = self
//            // 第一用方法
//            lecturedetail.changName = { (name) -> () in
//                print("------\(name)")
//                //            WeakSelf!.userNames!.text = names
//            }
            self.navigationController?.pushViewController(lecturedetail, animated: true);
        }
    }
    
    // 可以被编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = whitchModel(tag: indexPath.row)
        return model.isShow
    }
    
    // 确定编辑模式（默认是滑动删除模式）
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // 设置编辑模式为删除
        return  UITableViewCellEditingStyle.delete
    }
    
    // 允许移动某行（排序）
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let model = whitchModel(tag: indexPath.row)
        return model.isShow
    }
    
    // 实现排序
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // 从数组中读取需要移动行的数据
        let object:AnyObject = self.dataArray[sourceIndexPath.row] as AnyObject
        
        // 在数组中先移除需要移动行的数据
        self.dataArray.removeObject(at: sourceIndexPath.row)
        
        // 把需要移动的cell数据插到到想要移动的数据前面
        self.dataArray.insert(object, at: destinationIndexPath.row)
    }
    
    //MARK:- 其他方法 other
    //获取某个对象
    func whitchModel(tag : NSInteger) -> ListItemModel {
        let model = self.dataArray[tag]
        return model as! ListItemModel
    }

    
    //MARK:- 代理DetailDelegate
    func lastDo(data: Any) {
        print("homevc print delegate \(data)")
    }
    func isCompleted() -> Bool {
        return true
    }
    
}
