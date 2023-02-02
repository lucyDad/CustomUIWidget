//
//  FDUIStackViewViewController.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/24.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 参考
 https://nshipster.com/uistackview/
 https://juejin.cn/post/6844903752227373064
 https://www.raywenderlich.com/books/auto-layout-by-tutorials/v1.0/chapters/8-content-hugging-compression-resistance-priorities
 https://krakendev.io/blog/autolayout-magic-like-harry-potter-but-real
 
 arrangedSubviews 和 subviews 的顺序意义是不同的：

 subviews：它的顺序实际上是图层覆盖顺序，也就是视图元素的 z轴
 arrangedSubviews：它的顺序代表了 stack 堆叠的位置顺序，即视图元素的x轴和y轴

 如果一个元素没有被 addSubview，调用 arrangedSubviews 会自动 addSubview
 当一个元素被 removeFromSuperview ，则 arrangedSubviews也会同步移除
 当一个元素被 removeArrangedSubview， 不会触发 removeFromSuperview，它依然在视图结构中

 UIStackView 的布局会动态的同步数组 arrangedSubviews 的变化。
 变化包括：

 追加
 删除
 插入
 隐藏

 注意：对于隐藏（isHidden）的处理，UIStackView 会自动把空间利用起来，相当于暂时的删去，而不像 Autolayout 一般不破坏约束的做法。

 Main Axis:  主轴(横轴)
 Cross Axis: 交叉轴(纵轴)
 distribution for the main axis, and alignment for the cross axis.
 
 沿主轴排列的子视图的位置和大小部分受分布属性值的影响，部分受子视图本身的大小属性影响
 The position and size of arranged subviews along the main axis is affected in part by the value of the distribution property, and in part by the sizing properties of the subviews themselves
 
 Main Axis:  主轴 属性distribution ：
 each distribution option will determine how space along the main axis is distributed between the subviews: 每个distribution属性将决定沿主轴的空间如何在子视图之间分布
 With all distributions, save for fillEqually, the stack view attempts to find an optimal layout based on the intrinsic sizes of the arranged subviews: 对于所有distribution属性值，除了 fillEqually，堆栈视图尝试根据排列的子视图的固有大小找到最佳布局
 When it can’t fill the available space, it stretches the arranged subview with the the lowest content hugging priority: 当它无法填满可用空间时，它会拉伸具有最低内容拥抱优先级的排列子视图
 When it can’t fit all the arranged subviews, it shrinks the one with the lowest compression resistance priority: 当它不能容纳所有排列的子视图时，它会收缩具有最低抗压性优先级的子视图
 If the arranged subviews share the same value for content hugging and compression resistance, the algorithm will determine their priority based on their indices: 如果排列的子视图共享相同的内容拥抱和压缩阻力值，算法将根据它们的索引确定它们的优先级
 
 (https://krakendev.io/blog/autolayout-magic-like-harry-potter-but-real)
 约束优先级的数值范围是1~1000
 Hugging => content does not want to grow   当有更多空间的时候，优先级低的会被拉伸，优先级高的保持intrinsic content size
 Compression Resistance => content does not want to shrink  当没有更多空间的时候，优先级低的会被压缩，优先级高的保持intrinsic content size
 
 优先保留子view的内容大小
 equalSpacing: 等间距布局
 equalCentering: 等中间线间距布局
 
 优先填充stack堆栈容器
 fill:(default): arranged subviews填充所有可用stackview空间(子view大小被改变)
 fillProportionally: arranged subviews填充所有可用stackview空间(子view大小按自身比例被改变)
 fillEqually: arranged subviews填充所有可用stackview空间, 子view沿主轴的大小都相同
 
 
 Cross Axis:  交叉轴 属性Alignment ：Its value affects the positioning and sizing of arranged subviews along the cross axis 影响交叉轴排列的子view的大小和位置
 
 垂直和水平堆栈均可设置属性
 fill:(default): arranged subviews填充交叉轴上可用stackview空间
 leading/trailing: All subviews are aligned to the leading or trailing edge of the stack view along the cross axis  沿交叉轴与stackView的前缘或后缘对齐
 center: 沿交叉轴居中
 
 水平堆栈的额外属性: top和bottom是多余的，可用leading/trailing替代
 firstBaseline: Behaves like top, but uses the first baseline of the subviews instead of their top anchor.
 lastBaseline: Behaves like bottom, but uses the last baseline of the subviews instead of their bottom anchor.
 ps: Using firstBaseline and lastBaseline on vertical stacks produces unexpected results. This is a clear shortcoming of the API and a direct result of introducing orientation-specific values to an otherwise orientation-agnostic property
    在垂直堆栈上使用 firstBaseline 和 lastBaseline 会产生意想不到的结果。
    这是API的一个明显缺点，也是将特定于方向的值引入其他方向不可知的属性的直接结果
 
 UIStackView不能直接设置背景颜色
 Another quirk of stack views in iOS is that they don’t directly support setting a background color. You have to go through their backing layer to do so.
 plateStack.layer.backgroundColor = UIColor.white.cgColor
 
 The value of the spacing property is treated as an exact value for distributions that attempt to fill the available space (fill, fillEqually, fillProportionally), and as a minimum value otherwise (equalSpacing, equalCentering)
 UIStackView的属性distributions设置为fill, fillEqually, fillProportionally时，spacing属性被对待为精确值
 否则UIStackView的属性distributions设置为equalSpacing, equalCentering时，spacing属性被对待为最小值
 可以使用setCustomSpacing设置两个子试图之间的精确值，当setCustomSpacing和equalSpacing共同使用时，设置的值会应用到所有的子view
 
 通过设置isLayoutMarginsRelativeArrangement=true，并且分配值给layoutMargins，可以给UIStackView设置四周边距
 You can apply insets to your stack view by setting its isLayoutMarginsRelativeArrangement to true and assigning a new value to layoutMargins.
 plateStack.isLayoutMarginsRelativeArrangement = true
 plateStack.layoutMargins = UIEdgeInsets(…)
 
 
 我们只负责定义UIStackView的位置（position），UIStackView的大小（size）是可选的。当没有设置size的时候，UIStackView会根据它的内容的大小来调整自己的大小，即子视图各个控件的大小决定了UIStackView的大小，当子视图的各个控件大小为0，那么UIStackView的大小同样0。

 */

@interface FDUIStackViewViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
