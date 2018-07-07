//
//  DefaultSegmentControl.swift
//  Konka
//
//  Created by 杨超杰 on 2017/3/17.
//  Copyright © 2017年 Heading. All rights reserved.
//

import Foundation
import UIKit

fileprivate class DefaultSliderView : UIView {
    
    fileprivate var color : UIColor? {
        didSet{
            self.backgroundColor = color
        }
    }
}

fileprivate enum DefaultItemViewState : Int {
    case Normal
    case Selected
}

fileprivate class DefaultItemView : UIView {
    
    enum showType {
        case normal
        case image
    }
    var type : showType = .normal {
        didSet {
            layoutSubviews()
        }
    }
    
    fileprivate func itemWidth() -> CGFloat {
        
        if let text = titleLabel.text {
            let string = text as NSString
            let size = string.size(withAttributes: [NSAttributedStringKey.font:selectedFont!])
            return size.width + DefaultSegmentPattern.itemBorder
        }
        
        return 0.0
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate lazy var bridgeView : CALayer = {
        let view = CALayer()
        let width = DefaultSegmentPattern.bridgeWidth
        view.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        view.backgroundColor = DefaultSegmentPattern.bridgeColor.cgColor
        view.cornerRadius = view.bounds.size.width * 0.5
        return view
    }()
    
    fileprivate lazy var itemIamge : UIImageView = {
        let view = UIImageView.init(image: UIImage.init(named: "ic_scaner"))
        return view
    }()
    
    fileprivate func showImage(image: UIImage,selectImage: UIImage) {
        itemIamge.image = image
        normalImage = image
        self.selectImage = selectImage
        type = .image
    }
    
    fileprivate lazy var selectImage : UIImage = {
        let image = UIImage.init(named: "ic_scaner")
        return image!
    }()
    
    fileprivate lazy var normalImage : UIImage = {
        let image = UIImage.init(named: "ic_scaner")
        return image!
    }()
    
    fileprivate func showBridge(show:Bool){
        self.bridgeView.isHidden = !show
    }
    
    fileprivate var state : DefaultItemViewState = .Normal {
        didSet{
            updateItemView(state: state)
        }
    }
    
    fileprivate var font : UIFont?{
        didSet{
            if state == .Normal {
                self.titleLabel.font = font
            }
        }
    }
    fileprivate var selectedFont : UIFont?{
        didSet{
            if state == .Selected {
                self.titleLabel.font = selectedFont
            }
        }
    }
    
    fileprivate var text : String?{
        didSet{
            self.titleLabel.text = text
        }
    }
    
    fileprivate var textColor : UIColor?{
        didSet{
            if state == .Normal {
                self.titleLabel.textColor = textColor
            }
        }
    }
    fileprivate var selectedTextColor : UIColor?{
        didSet{
            if state == .Selected {
                self.titleLabel.textColor = selectedTextColor
            }
        }
    }
    
    fileprivate var itemBackgroundColor : UIColor?{
        didSet{
            if state == .Normal {
                self.backgroundColor = itemBackgroundColor
            }
        }
    }
    fileprivate var selectedBackgroundColor : UIColor?{
        didSet{
            if state == .Selected {
                self.backgroundColor = selectedBackgroundColor
            }
        }
    }
    
    fileprivate var textAlignment = NSTextAlignment.center {
        didSet{
            self.titleLabel.textAlignment = textAlignment
        }
    }
    
    private func updateItemView(state:DefaultItemViewState){
        switch state {
        case .Normal:
            self.titleLabel.font = self.font
            self.titleLabel.textColor = self.textColor
            self.backgroundColor = self.itemBackgroundColor
            self.itemIamge.image = normalImage
        case .Selected:
            self.titleLabel.font = selectedFont
            self.titleLabel.textColor = self.selectedTextColor
            self.backgroundColor = self.selectedBackgroundColor
            self.itemIamge.image = selectImage
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(itemIamge)
        bridgeView.isHidden = true
        layer.addSublayer(bridgeView)
        
        layer.masksToBounds = true
    }
    
    fileprivate override func layoutSubviews() {
        super.layoutSubviews()
        
        if type == .image {
            itemIamge.isHidden = false
            titleLabel.sizeToFit()
            //itemIamge.frame.size.width =
            
            titleLabel.sizeToFit()
            
            titleLabel.center.x = bounds.size.width * 0.5 + itemIamge.frame.size.width/2
            titleLabel.center.y = bounds.size.height * 0.5
            
            itemIamge.frame.origin.x = titleLabel.frame.origin.x - itemIamge.frame.size.width - 5
            itemIamge.center.y = bounds.size.height * 0.5
        }else {
            itemIamge.isHidden = true
            titleLabel.sizeToFit()
            
            titleLabel.center.x = bounds.size.width * 0.5
            titleLabel.center.y = bounds.size.height * 0.5
            
            let width = bridgeView.bounds.size.width
            let x:CGFloat = titleLabel.frame.maxX
            bridgeView.frame = CGRect(x: x, y: bounds.midY - width, width: width, height: width)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc public protocol DefaultSegmentControlDelegate {
    @objc optional func didSelected(segement:DefaultSegmentControl, index: Int)
}

open class DefaultSegmentControl: UIControl {
    
    fileprivate struct Constants {
        static let height : CGFloat = 40.0
    }
    
    open weak var delegate : DefaultSegmentControlDelegate?
    
    open var autoAdjustWidth = false {
        didSet{
            
        }
    }
    
    open var contentImage : Bool = false
    
    //recomend to use segmentWidth(index:Int)
    open func segementWidth() -> CGFloat {
        return bounds.size.width / (CGFloat)(itemViews.count)
    }
    //when autoAdjustWidth is true, the width is not necessarily the same
    open func segmentWidth(index:Int) -> CGFloat {
        guard index >= 0 && index < itemViews.count else {
            return 0.0
        }
        
        if autoAdjustWidth {
            return itemViews[index].itemWidth()
        }else{
            return segementWidth()
        }
    }
    
    open var selectedIndex = 0 {
        didSet{
            guard self.itemViews.count > oldValue else {
                let originItem = self.itemViews[0]
                originItem.state = .Selected
                return
            }
            
            guard self.itemViews.count > selectedIndex else {
                return
            }
            let originItem = self.itemViews[oldValue]
            originItem.state = .Normal
            
            let selectItem = self.itemViews[selectedIndex]
            selectItem.state = .Selected
        }
    }
    
    //MARK - color set
    open var itemTextColor = DefaultSegmentPattern.itemTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.textColor = itemTextColor
            }
        }
    }
    
    open var itemSelectedTextColor = DefaultSegmentPattern.itemSelectedTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedTextColor = itemSelectedTextColor
            }
        }
    }
    open var itemBackgroundColor = DefaultSegmentPattern.itemBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.itemBackgroundColor = itemBackgroundColor
            }
        }
    }
    
    open var itemSelectedBackgroundColor = DefaultSegmentPattern.itemSelectedBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedBackgroundColor = itemSelectedBackgroundColor
            }
        }
    }
    
    open var sliderViewColor = DefaultSegmentPattern.sliderColor{
        didSet{
            self.sliderView.color = sliderViewColor
        }
    }
    
    open var sliderViewWidth :CGFloat = 0 {
        didSet {
            self.sliderView.frame.size.width = sliderViewWidth
        }
    }
    
    open var isAnimation = DefaultSegmentPattern.isAnimation {
        didSet{
            
        }
    }
    
    //MAR - font
    open var font = DefaultSegmentPattern.textFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.font = font
            }
        }
    }
    
    open var sliderHeight = DefaultSegmentPattern.sliderHeight {
        didSet {
            
        }
    }
    
    open var selectedFont = DefaultSegmentPattern.selectedTextFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedFont = selectedFont
            }
        }
    }
    
    open var items : [String]?{
        didSet{
            guard items != nil && items!.count > 0 else {
                fatalError("Items cannot be empty")
            }
            
            self.removeAllItemView()
            
            
            for title in items! {
                let view = self.createItemView(title: title)
                self.itemViews.append(view)
                self.contentView.addSubview(view)
                print("==========\(view.frame)")
            }
            //self.selectedIndex = 0
            
            self.contentView.bringSubview(toFront: self.sliderView)
            doLayout()
        }
    }
    
    open func showBridge(show:Bool, index:Int){
        
        guard index < itemViews.count && index >= 0 else {
            return
        }
        
        itemViews[index].showBridge(show: show)
    }
    
    open func showImage(images: [UIImage],selectImages: [UIImage]) {
        //确定是包含图片的类型
        contentImage = true
        for index in 0..<images.count {
            itemViews[index].showImage(image: images[index],selectImage: selectImages[index])
        }
    }
    
    
    //when true, scrolled the itemView to a point when index changed
    open var autoScrollWhenIndexChange = true
    //default self.scrollView.center
    open var scrollToPointWhenIndexChanged : CGPoint?
    
    open var bounces = false {
        didSet{
            self.scrollView.bounces = bounces
        }
    }
    
    fileprivate func removeAllItemView() {
        itemViews.forEach { (label) in
            label.removeFromSuperview()
        }
        itemViews.removeAll()
    }
    private var itemWidths = [CGFloat]()
    private func createItemView(title:String) -> DefaultItemView {
        return createItemView(title: title,
                              font: self.font,
                              selectedFont: self.selectedFont,
                              textColor: self.itemTextColor,
                              selectedTextColor: self.itemSelectedTextColor,
                              backgroundColor: self.itemBackgroundColor,
                              selectedBackgroundColor: self.itemSelectedBackgroundColor
        )
    }
    
    private func createItemView(title:String, font:UIFont, selectedFont:UIFont, textColor:UIColor, selectedTextColor:UIColor, backgroundColor:UIColor, selectedBackgroundColor:UIColor) -> DefaultItemView {
        let item = DefaultItemView()
        item.text = title
        item.textColor = textColor
        item.textAlignment = .center
        item.font = font
        item.selectedFont = selectedFont
        
        item.itemBackgroundColor = backgroundColor
        item.selectedTextColor = selectedTextColor
        item.selectedBackgroundColor = selectedBackgroundColor
        
        item.state = .Normal
        return item
    }
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    open lazy var contentView = UIView()
    fileprivate lazy var sliderView : DefaultSliderView = DefaultSliderView()
    fileprivate var itemViews = [DefaultItemView]()
    fileprivate var numberOfSegments : Int {
        return itemViews.count
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        scrollToPointWhenIndexChanged = scrollView.center
    }
    
    fileprivate func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(sliderView)
        sliderView.color = sliderViewColor
        
        scrollView.frame = bounds
        contentView.frame = scrollView.bounds
        
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSegement(tapGesture:)))
        
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapSegement(tapGesture:UITapGestureRecognizer) {
        let index = selectedTargetIndex(gesture: tapGesture)
        move(to: index)
    }
    
    open func move(to index:Int){
        move(to: index, animated: true)
    }
    
    open func move(to index:Int, animated:Bool) {
        var width : CGFloat = 0
        if contentImage {
            width = sliderViewWidth
        }else {
            width = self.segmentWidth(index: index) - DefaultSegmentPattern.itemBorder
        }
        
        if sliderViewWidth > 0 {
            width = sliderViewWidth
        }
        
        let position = centerX(with: index)
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.sliderView.center.x = position
                self.sliderView.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: self.sliderView.bounds.height)
            })
        }
        self.delegate?.didSelected?(segement: self, index: index)
       
        
        selectedIndex = index
        
        if autoScrollWhenIndexChange {
            scrollItemToPoint(index: index, point: scrollToPointWhenIndexChanged!)
        }
    }
    
    fileprivate func currentItemX(index:Int) -> CGFloat {
        if autoAdjustWidth {
            var x:CGFloat = 0.0
            for i in 0..<index {
                x += segmentWidth(index: i)
            }
            return x
        }
        return segementWidth() * CGFloat(index)
    }
    
    fileprivate func centerX(with index:Int) -> CGFloat {
        if autoAdjustWidth {
            return currentItemX(index: index) + segmentWidth(index: index)*0.5
        }
        
        return (CGFloat(index) + 0.5)*segementWidth()
    }
    
    private func selectedTargetIndex(gesture: UIGestureRecognizer) -> Int {
        let location = gesture.location(in: contentView)
        var index = 0
        
        if autoAdjustWidth {
            for (i,itemView) in itemViews.enumerated() {
                if itemView.frame.contains(location) {
                    index = i
                    break
                }
            }
        }else{
            index = Int(location.x / segementWidth())
        }
        
        if index < 0 {
            index = 0
        }
        if index > numberOfSegments - 1 {
            index = numberOfSegments - 1
        }
        return index
    }
    
    private func scrollItemToCenter(index : Int) {
        scrollItemToPoint(index: index, point: CGPoint(x: scrollView.bounds.size.width * 0.5, y: 0))
    }
    
    open func scrollItemToPoint(index : Int,point:CGPoint) {
        
        let currentX = currentItemX(index: index)
        
        let scrollViewWidth = scrollView.bounds.size.width
        
        var scrollX = currentX - point.x + segmentWidth(index: index) * 0.5
        
        let maxScrollX = scrollView.contentSize.width - scrollViewWidth
        
        if scrollX > maxScrollX {
            scrollX = maxScrollX
        }
        if scrollX < 0.0 {
            scrollX = 0.0
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollX, y: 0.0), animated: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doLayout() {
        
        guard itemViews.count > 0 else {
            return
        }
        
        var x:CGFloat = 0.0
        let y:CGFloat = 0.0
        var width:CGFloat = segmentWidth(index: selectedIndex)
        if contentImage {
            width = sliderViewWidth
        }else {
            width = segmentWidth(index: selectedIndex)  - DefaultSegmentPattern.itemBorder
        }
        
        if sliderViewWidth > 0 {
            width = sliderViewWidth
        }
        
        let height:CGFloat = bounds.size.height
        
        sliderView.frame = CGRect(x: currentItemX(index: selectedIndex) + 15, y: contentView.bounds.size.height - DefaultSegmentPattern.sliderHeight, width: width, height: sliderHeight)
        self.sliderView.center.x = centerX(with: selectedIndex)
        var contentWidth:CGFloat = 0.0
        
        for (index,item) in itemViews.enumerated() {
            x = contentWidth
            width = segmentWidth(index: index)
            item.frame = CGRect(x: x, y: y, width: width, height: height)
            
            contentWidth += width
        }
        
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: contentWidth, height: contentView.bounds.height)
        scrollView.contentSize = contentView.bounds.size

    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        doLayout()
    }
}
