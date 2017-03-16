# MyTool
>* 个人测试swift工具
>* 欢迎各位指教

### 本文设计代理写法
* 此处为代理试例：

```
//#mark delegate
@objc protocol DetailDelegate:NSObjectProtocol {
    func lastDo(data:Any)
    @objc optional func isCompleted() -> Bool //可选
}

var detailDelegate:DetailDelegate!

if (self.detailDelegate.isCompleted!()) {
  self.detailDelegate?.lastDo(data: "fuck")
}
```
* 它处调用

```
lecturedetail.detailDelegate = self;

//MARK:- 代理DetailDelegate
func lastDo(data: Any) {
   print("homevc print delegate \(data)")
}
func isCompleted() -> Bool {
   return true
}
```

### 本文设计block写法
* 此处为block试例

```
//swift写法声明一个block
typealias changUserName = (String) ->()//A
    //MARK:- 闭包block
//    其他类使用
var changName: changUserName?//B
// 或者使用实例方法调用（方法名字不固定，但参数是必须的）
func setMyChangeName(tempClose: @escaping changUserName)  {
	self.changName = tempClose
}

//MARK:- 按钮点击clicked
changName?("很好的block")
```
* 使用

```
lecturedetail.setMyChangeName(tempClose: { (name) in
 print("block \(name) 回调啦")
})
```

> 未完待续
