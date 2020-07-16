//
//  YSNavigationBar.m
//

#import "YSNavigationBar.h"


static CGFloat const NavigationBarContentHeght = 44.0;
static CGFloat const NavigationBarStackSideMargin = 8.0;
static CGFloat const NavigationBarStackItemMargin = 5.0;
static CGFloat const NavigationButtonItemTitleExtensionMargin = 10.0;
static CGFloat const NavigationButtonItemImageExtensionMargin = 14.0;
static NSString * const YSBarButtonItemSize = @"YSBarButtonItemSize";

typedef void(^ItemSizeChangedBlock)(void);

@interface YSBarButtonItem ()

/** 按钮  */
@property (nonatomic,strong,readwrite) UIButton *itemButton;
/** 方法  */
@property (nonatomic, assign,readwrite) SEL action;
/** 代理  */
@property (nonatomic, weak,readwrite)   id  target;
/** 最终尺寸  */
@property (nonatomic,assign) CGSize itemSize;
/** 尺寸改变回调  */
@property (nonatomic, copy) ItemSizeChangedBlock itemSizeChangedBlock;
@end

@implementation YSBarButtonItem

- (void)dealloc{
}

- (void)configButton{
    self.itemButton.adjustsImageWhenHighlighted = NO;
    self.itemButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.itemButton addTarget:self action:@selector(barButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self layoutButtonItem];
}
- (void)layoutButtonItem{
    if (self.itemButton.currentTitle.length) {
        [self setButtonItemTitle];
    }
    
    if (self.itemButton.currentImage) {
        [self setButtonItemImage];
    }
    
    if (self.itemSizeChangedBlock) {
        self.itemSizeChangedBlock();
    }
}

- (void)setButtonItemTitle{
    
    if (_itemCustomSize.width && _itemCustomSize.height) {
         [self.itemButton.titleLabel sizeToFit];
        _itemSize = _itemCustomSize;
    }else{
        [self.itemButton.titleLabel sizeToFit];
        _itemSize = CGSizeMake(self.itemButton.titleLabel.frame.size.width + NavigationButtonItemTitleExtensionMargin, NavigationBarContentHeght);
    }
}

- (void)setButtonItemImage{
    
    if (_itemCustomSize.width && _itemCustomSize.height) {
        _itemSize = _itemCustomSize;
    }else{
        _itemSize = CGSizeMake(self.itemButton.imageView.image.size.width + NavigationButtonItemImageExtensionMargin, NavigationBarContentHeght);
    }
}

- (void)setTitleExtensionMargin:(CGFloat)titleExtensionMargin{
    _titleExtensionMargin = titleExtensionMargin;
}

- (void)barButtonItemAction{
    
    NSMethodSignature * signature = [self.target methodSignatureForSelector:self.action];
    if (signature == nil) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if (signature.numberOfArguments > 2) {
        if ([self.target respondsToSelector:self.action]) {
            
            [self.target performSelector:self.action withObject:self];
        }
    } else {
        if ([self.target respondsToSelector:self.action]) {
             [self.target performSelector:self.action];
        }
    }
    
#pragma clang diagnostic pop
    
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action{
    self.itemButton = [[UIButton alloc] init];
    [self.itemButton setImage:image forState:UIControlStateNormal];
    [self configButton];
    self.target = target;
    self.action = action;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
    self.itemButton = [[UIButton alloc] init];
    [self.itemButton setImage:image forState:UIControlStateNormal];
    [self.itemButton setImage:selectedImage forState:UIControlStateSelected];
    self.target = target;
    self.action = action;
    [self configButton];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image disabledImage:(UIImage *)disabledImage target:(id)target action:(SEL)action{
    self.itemButton = [[UIButton alloc] init];
    [self.itemButton setImage:image forState:UIControlStateNormal];
    [self.itemButton setImage:disabledImage forState:UIControlStateDisabled];
    self.target = target;
    self.action = action;
    [self configButton];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    self.itemButton = [[UIButton alloc] init];
    [self.itemButton setTitle:title forState:UIControlStateNormal];
    self.target = target;
    self.action = action;
    [self configButton];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle target:(id)target action:(SEL)action{
    self.itemButton = [[UIButton alloc] init];
    [self.itemButton setTitle:title forState:UIControlStateNormal];
    [self.itemButton setTitle:selectedTitle forState:UIControlStateSelected];
    self.target = target;
    self.action = action;
    [self configButton];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title disabledTitle:(NSString *)disabledTitle target:(id)target action:(SEL)action{
    self.itemButton = [[UIButton alloc] init];
    [self.itemButton setTitle:title forState:UIControlStateNormal];
    [self.itemButton setTitle:disabledTitle forState:UIControlStateDisabled];
    self.target = target;
    self.action = action;
    [self configButton];
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.itemButton.selected = selected;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    self.itemButton.enabled = enabled;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.itemButton.userInteractionEnabled = userInteractionEnabled;
}

- (void)setItemCustomSize:(CGSize)itemCustomSize{
    _itemCustomSize = itemCustomSize;
     [self layoutButtonItem];
}

- (void)setItemCornerRadius:(CGFloat)itemCornerRadius{
    _itemCornerRadius = itemCornerRadius;
    self.itemButton.layer.cornerRadius = _itemCornerRadius;
}

- (void)setItemBackgroundColor:(UIColor *)itemBackgroundColor{
    _itemBackgroundColor = itemBackgroundColor;
    self.itemButton.backgroundColor = _itemBackgroundColor;
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor{
    [self.itemButton setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    [self.itemButton setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont{
    _itemTitleFont = itemTitleFont;
    [self.itemButton.titleLabel setFont:_itemTitleFont];
    [self layoutButtonItem];
}

- (void)setAdjustsImageWhenHighlighted:(BOOL)adjustsImageWhenHighlighted{
    _adjustsImageWhenHighlighted = adjustsImageWhenHighlighted;
    [self.itemButton setAdjustsImageWhenHighlighted:adjustsImageWhenHighlighted];
}

- (void)setTitle:(nullable NSString *)title forState:(YSControlState)state{
    [self.itemButton setTitle:title forState:(UIControlState)state];
    [self layoutButtonItem];
}
- (void)setTitleColor:(nullable UIColor *)color forState:(YSControlState)state{
    [self.itemButton setTitleColor:color forState:(UIControlState)state];
    
}
- (void)setTitleShadowColor:(nullable UIColor *)color forState:(YSControlState)state{
    [self.itemButton setTitleShadowColor:color forState:(UIControlState)state];
}
- (void)setImage:(nullable UIImage *)image forState:(YSControlState)state{
    [self.itemButton setImage:image forState:(UIControlState)state];
}
- (void)setBackgroundImage:(nullable UIImage *)image forState:(YSControlState)state{
    [self.itemButton setBackgroundImage:image forState:(UIControlState)state];
}
- (void)setAttributedTitle:(nullable NSAttributedString *)title forState:(YSControlState)state{
    [self.itemButton setAttributedTitle:title forState:(UIControlState)state];
    [self layoutButtonItem];
}

- (nullable NSString *)titleForState:(YSControlState)state{
    return [self.itemButton titleForState:(UIControlState)state];
}
- (nullable UIColor *)titleColorForState:(YSControlState)state{
    return [self.itemButton titleColorForState:(UIControlState)state];
}
- (nullable UIColor *)titleShadowColorForState:(YSControlState)state{
    return [self.itemButton titleShadowColorForState:(UIControlState)state];
}
- (nullable UIImage *)imageForState:(YSControlState)state{
    return [self.itemButton imageForState:(UIControlState)state];
}
- (nullable UIImage *)backgroundImageForState:(YSControlState)state{
    return [self.itemButton backgroundImageForState:(UIControlState)state];
}
- (nullable NSAttributedString *)attributedTitleForState:(YSControlState)state{
    return [self.itemButton attributedTitleForState:(UIControlState)state];
}

- (UIView *)context{
    return self.itemButton;
}

- (NSString *)currentTitle{
    return self.itemButton.currentTitle;
}

- (UIColor *)currentTitleColor{
    return self.itemButton.currentTitleColor;
}

- (UIColor *)currentTitleShadowColor{
    return self.itemButton.currentTitleShadowColor;
}


- (UIImage *)currentImage{
    return self.itemButton.currentImage;
}

- (UIImage *)currentBackgroundImage{
    return self.itemButton.currentBackgroundImage;
}

- (NSAttributedString *)currentAttributedTitle{
    return self.itemButton.currentAttributedTitle;
}

@end

@interface YSNavigationBar()
/** 左侧控件承载视图  */
@property (nonatomic,strong) UIView *leftStackView;
/** 右侧控件承载视图  */
@property (nonatomic,strong) UIView *rightStackView;
/** 标题  */
@property (nonatomic,strong) UILabel *navTitleLab;
/** 底部分界线  */
@property (nonatomic,strong) UIView *navigationBarBottomLine;
/** 导航栏内容区域视图  */
@property (nonatomic,strong) UIView *navigationBarContentView;
/** 中间内容区域视图  */
@property (nonatomic,strong) UIView *centerStackView;
/** 导航栏内容区域视高度 */
@property (nonatomic, assign) CGFloat navigationBarContentH;
@end

@implementation YSNavigationBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
       _navigationBarContentH = frame.size.height - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        
        //默认背景颜色
        self.barTintColor = [UIColor whiteColor];
        
        //默认边距
        self.navLeftSideMargin = NavigationBarStackSideMargin;
        self.navRightSideMargin = NavigationBarStackSideMargin;
        //导航栏内容区域视图
        self.navigationBarContentView = [[UIView alloc] init];
        self.navigationBarContentView.frame = CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), frame.size.width, _navigationBarContentH);
        self.navigationBarContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.navigationBarContentView];
        
        //两端承载视图
        self.leftStackView = [[UIView alloc] init];
        self.leftStackView.backgroundColor = [UIColor clearColor];
        self.leftStackView.hidden = YES;
        [self.navigationBarContentView addSubview:self.leftStackView];
        self.rightStackView = [[UIView alloc] initWithFrame:CGRectZero];
        self.rightStackView.backgroundColor = [UIColor clearColor];
        self.rightStackView.hidden = YES;
        [self.navigationBarContentView addSubview:self.rightStackView];
        
        //中间视图
        self.centerStackView = [[UIView alloc] init];
        self.centerStackView.backgroundColor = [UIColor clearColor];
        self.centerStackView.hidden = YES;
        [self.navigationBarContentView addSubview:self.centerStackView];
        
        //外接自定义视图
        self.customView = [[UIView alloc] init];
        self.customView.backgroundColor = [UIColor clearColor];
        self.customView.hidden = YES;
        
        //标题
        self.navTitleLab = [[UILabel alloc] init];
        self.navTitleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        self.navTitleLab.textColor = [UIColor blackColor];
        self.navTitleLab.textAlignment = NSTextAlignmentCenter;
        self.navTitleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.centerStackView addSubview:self.navTitleLab];
        
        //底部分界线
        self.navigationBarBottomLine = [[UIView alloc] init];
        self.navigationBarBottomLine.frame = CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5);
        self.navigationBarBottomLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mine_line"]];
        [self addSubview:self.navigationBarBottomLine];
        
    }
    return self;
}

/**
 setter--frame
 */
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _navigationBarContentH = frame.size.height - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    self.navigationBarBottomLine.frame = CGRectMake(0, frame.size.height, frame.size.width, 0.33);
    self.navigationBarContentView.frame = CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), frame.size.width,_navigationBarContentH);
    self.navItemSpace = NavigationBarStackItemMargin;
}

/**
 setter--d左边单个控件
 */
- (void)setLeftBarButtonItem:(YSBarButtonItem *)leftBarButtonItem{
    _leftBarButtonItem = leftBarButtonItem;
    [self.leftStackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_leftBarButtonItem && [leftBarButtonItem isKindOfClass:[leftBarButtonItem class]]) {
        self.leftBarButtonItems = @[_leftBarButtonItem];
    }else{
        self.leftStackView.hidden = YES;
        [self layoutCenterStackView];
    }
}

/**
 setter--左边多个控件
 */
- (void)setLeftBarButtonItems:(NSArray<__kindof  UIView *> *)leftBarButtonItems{
    _leftBarButtonItems = leftBarButtonItems;
    [self layoutLeftItems];
}

- (void)insertLeftItem:(__kindof  UIView *)leftItem atIndex:(NSInteger)index{
    if (!(leftItem && [leftItem isKindOfClass:[UIView class]])) {
        return;
    }
    if (!(_leftBarButtonItems.count && [_leftBarButtonItems isKindOfClass:[NSArray class]])) {
        self.leftBarButtonItems = @[leftItem];
    }else{
        
        if (index >= _leftBarButtonItems.count || index < 0) {
            return;
        }
        if ([_leftBarButtonItems containsObject:leftItem]) {
            
        }else{
            NSMutableArray *leftBarButtonItemsM = [NSMutableArray arrayWithArray:_leftBarButtonItems];
            [leftBarButtonItemsM insertObject:leftItem atIndex:index];
            self.leftBarButtonItems = leftBarButtonItemsM;
        }
    }
}
- (void)addLeftItem:(__kindof  UIView *)leftItem{
    if (!(leftItem && [leftItem isKindOfClass:[UIView class]])) {
        return;
    }
    if (!(_leftBarButtonItems.count && [_leftBarButtonItems isKindOfClass:[NSArray class]])) {
        self.leftBarButtonItems = @[leftItem];
    }else{
        if ([_leftBarButtonItems containsObject:leftItem]) {
            
        }else{
            NSMutableArray *leftBarButtonItemsM = [NSMutableArray arrayWithArray:_leftBarButtonItems];
            [leftBarButtonItemsM addObject:leftItem];
            self.leftBarButtonItems = leftBarButtonItemsM;
        }
    }
}

- (void)removeLeftItemAtIndex:(NSUInteger)index{
    if (!(_leftBarButtonItems.count && [_leftBarButtonItems isKindOfClass:[NSArray class]])) {
        
    }else{
        
        if (index >= _leftBarButtonItems.count || index < 0) {
            return;
        }
        NSMutableArray *leftBarButtonItemsM = [NSMutableArray arrayWithArray:_leftBarButtonItems];
        if ([leftBarButtonItemsM objectAtIndex:index] && [[leftBarButtonItemsM objectAtIndex:index] isKindOfClass:[UIView class]]) {
            
            [leftBarButtonItemsM removeObjectAtIndex:index];
            self.leftBarButtonItems = leftBarButtonItemsM;
        }else{
            [leftBarButtonItemsM removeObjectAtIndex:index];
            _leftBarButtonItems = leftBarButtonItemsM;
            [self removeLeftItemAtIndex:index];
        }
    }
}


- (void)insertRightItem:(__kindof  UIView *)rightItem atIndex:(NSInteger)index{
    if (!(rightItem && [rightItem isKindOfClass:[UIView class]])) {
        return;
    }
    if (!(_rightBarButtonItems.count && [_rightBarButtonItems isKindOfClass:[NSArray class]])) {
        self.rightBarButtonItems = @[rightItem];
    }else{
        if (index >= _rightBarButtonItems.count || index < 0) {
            return;
        }
        if ([_rightBarButtonItems containsObject:rightItem]) {
            
        }else{
            NSMutableArray *rightBarButtonItemsM = [NSMutableArray arrayWithArray:_rightBarButtonItems];
            [rightBarButtonItemsM insertObject:rightItem atIndex:index];
            self.rightBarButtonItems = rightBarButtonItemsM;
        }
    }
}
- (void)addRightItem:(__kindof  UIView *)rightItem{
    if (!(rightItem && [rightItem isKindOfClass:[UIView class]])) {
        return;
    }
    if (!(_rightBarButtonItems.count && [_rightBarButtonItems isKindOfClass:[NSArray class]])) {
        self.rightBarButtonItems = @[rightItem];
    }else{
        if ([_rightBarButtonItems containsObject:rightItem]) {
            
        }else{
            NSMutableArray *rightBarButtonItemsM = [NSMutableArray arrayWithArray:_rightBarButtonItems];
            [rightBarButtonItemsM addObject:rightItem];
            self.rightBarButtonItems = rightBarButtonItemsM;
        }
    }
}

- (void)removeRightItemAtIndex:(NSUInteger)index{
    if (!(_rightBarButtonItems.count && [_rightBarButtonItems isKindOfClass:[NSArray class]])) {
        
    }else{
        
        if (index >= _rightBarButtonItems.count || index < 0) {
            return;
        }
        NSMutableArray *rightBarButtonItemsM = [NSMutableArray arrayWithArray:_rightBarButtonItems];
        if ([rightBarButtonItemsM objectAtIndex:index] && [[rightBarButtonItemsM objectAtIndex:index] isKindOfClass:[UIView class]]) {
            
            [rightBarButtonItemsM removeObjectAtIndex:index];
            self.rightBarButtonItems = rightBarButtonItemsM;
        }else{
            [rightBarButtonItemsM removeObjectAtIndex:index];
            _rightBarButtonItems = rightBarButtonItemsM;
            [self removeRightItemAtIndex:index];
        }
    }
}

- (void)removeItem:(__kindof UIView *)item{
    if (!(_leftBarButtonItems.count && [_leftBarButtonItems isKindOfClass:[NSArray class]])) {
        
    }else{
        if ([_leftBarButtonItems containsObject:item]) {
            NSMutableArray *leftBarButtonItemsM = [NSMutableArray arrayWithArray:_leftBarButtonItems];
            [leftBarButtonItemsM removeObject:item];
            self.leftBarButtonItems = leftBarButtonItemsM;
            //必要一步
            return;
        }
    }
    
    if (!(_rightBarButtonItems.count && [_rightBarButtonItems isKindOfClass:[NSArray class]])) {
        
    }else{
        
        if ([_rightBarButtonItems containsObject:item]) {
            
            NSMutableArray *rightBarButtonItemsM = [NSMutableArray arrayWithArray:_rightBarButtonItems];
            [rightBarButtonItemsM removeObject:item];
            self.rightBarButtonItems = rightBarButtonItemsM;
        }
    }
}

/**
 布局左边控件
 */
- (void)layoutLeftItems{
    [self.leftStackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_hidesLeftButtonItem && [_leftBarButtonItems isKindOfClass:[NSArray class]] && _leftBarButtonItems.count) {
        self.leftStackView.hidden = NO;
        CGFloat itemWidth = 0.0;
        NSInteger idx = 0;
        for (id _Nonnull item in _leftBarButtonItems) {
            
            //BLBarButtonItem
            if ([item isKindOfClass:[YSBarButtonItem class]]) {
                YSBarButtonItem  *leftBarButtonItem  = (YSBarButtonItem *)item;
//                leftBarButtonItem.itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.leftStackView addSubview:leftBarButtonItem.itemButton];
                leftBarButtonItem.itemButton.frame = CGRectMake(itemWidth + self.navItemSpace*idx, 0, leftBarButtonItem.itemSize.width, leftBarButtonItem.itemSize.height);
                //设置自定义size时，居中
                if (leftBarButtonItem.itemSize.width && leftBarButtonItem.itemSize.height) {
                    CGPoint center = leftBarButtonItem.itemButton.center;
                    center.y = _navigationBarContentH * 0.5;
                    leftBarButtonItem.itemButton.center = center;
                }
                
                leftBarButtonItem.frame = leftBarButtonItem.itemButton.frame;
                itemWidth += leftBarButtonItem.itemSize.width;
                //有效item个数累计
                idx ++;
                
                typeof(self) __weak weakSelf = self;
                leftBarButtonItem.itemSizeChangedBlock = ^{
                    [weakSelf layoutLeftItems];
                };
            }
            
            //UIButton
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton  *leftBarButton  = (UIButton *)item;
                leftBarButton.adjustsImageWhenHighlighted = NO;
                [leftBarButton.titleLabel sizeToFit];
//                leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.leftStackView addSubview:leftBarButton];
                //设置自定义size时，居中
                if (leftBarButton.frame.size.width && leftBarButton.frame.size.height) {
                    leftBarButton.frame = CGRectMake(itemWidth + self.navItemSpace*idx, 0, leftBarButton.frame.size.width, leftBarButton.frame.size.height);
                    CGPoint center = leftBarButton.center;
                    center.y = _navigationBarContentH * 0.5;
                    leftBarButton.center = center;
                }else{
                    
                    if (leftBarButton.titleLabel.frame.size.width) {
                        leftBarButton.frame = CGRectMake(itemWidth + self.navItemSpace*idx, 0, leftBarButton.titleLabel.frame.size.width + NavigationButtonItemTitleExtensionMargin, _navigationBarContentH);
                    }else{
                        leftBarButton.frame = CGRectMake(itemWidth + self.navItemSpace*idx, 0, leftBarButton.imageView.image.size.width + NavigationButtonItemImageExtensionMargin, _navigationBarContentH);
                    }
                }
                itemWidth += leftBarButton.frame.size.width;
                //有效item个数累计
                idx ++;
            }
            if ([_leftBarButtonItems indexOfObject:item] == (_leftBarButtonItems.count - 1)) {
                self.leftStackView.frame = CGRectMake(self.navLeftSideMargin, 0, itemWidth + self.navItemSpace*(idx - 1), _navigationBarContentH);
            }
        }
    }else{
        self.leftStackView.hidden = YES;
    }
    [self layoutCenterStackView];
}

/**
 setter--右边单个控件
 */
- (void)setRightBarButtonItem:(YSBarButtonItem *)rightBarButtonItem{
    _rightBarButtonItem = rightBarButtonItem;
    [self.rightStackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_rightBarButtonItem && [rightBarButtonItem isKindOfClass:[YSBarButtonItem class]]) {
        self.rightBarButtonItems = @[_rightBarButtonItem];
    }else{
        self.rightStackView.hidden = YES;
    }
    [self layoutCenterStackView];
}

/**
 setter--右边多个控件
 */
- (void)setRightBarButtonItems:(NSArray<__kindof  UIView *> *)rightBarButtonItems{
    _rightBarButtonItems = rightBarButtonItems;
    [self layoutRightItems];
}

/**
 布局右边控件
 */
- (void)layoutRightItems{
    [self.rightStackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_hidesRightButtonItem && [_rightBarButtonItems isKindOfClass:[NSArray class]] && _rightBarButtonItems.count) {
        self.rightStackView.hidden = NO;
        
        CGFloat itemWidth = 0.0;
        NSInteger idx = 0;
        for (id _Nonnull item in _rightBarButtonItems) {
            
            //BLBarButtonItem
            if ([item isKindOfClass:[YSBarButtonItem class]]) {
                YSBarButtonItem  *rightBarButtonItem  = (YSBarButtonItem *)item;
//                rightBarButtonItem.itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [self.rightStackView addSubview:rightBarButtonItem.itemButton];
                rightBarButtonItem.itemButton.frame = CGRectMake(itemWidth  + self.navItemSpace*idx, 0, rightBarButtonItem.itemSize.width, rightBarButtonItem.itemSize.height);
                //设置自定义size时，居中
                if (rightBarButtonItem.itemSize.width && rightBarButtonItem.itemSize.height) {
                    CGPoint center = rightBarButtonItem.itemButton.center;
                    center.y = _navigationBarContentH * 0.5;
                    rightBarButtonItem.itemButton.center = center;
                }
                rightBarButtonItem.frame = rightBarButtonItem.itemButton.frame;
                itemWidth += rightBarButtonItem.itemSize.width;
                //有效item个数累计
                idx ++;
                
                typeof(self) __weak weakSelf = self;
                rightBarButtonItem.itemSizeChangedBlock = ^{
                    [weakSelf layoutRightItems];
                };
            }
            
            //UIButton
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton  *rightBarButton  = (UIButton *)item;
                rightBarButton.adjustsImageWhenHighlighted = NO;
                [rightBarButton.titleLabel sizeToFit];
//                rightBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [self.rightStackView addSubview:rightBarButton];

                //设置自定义size时，居中
                if (rightBarButton.frame.size.width && rightBarButton.frame.size.height) {
                    
                    rightBarButton.frame = CGRectMake(itemWidth  + self.navItemSpace*idx, 0, rightBarButton.frame.size.width, rightBarButton.frame.size.height);
                    CGPoint center = rightBarButton.center;
                    center.y = _navigationBarContentH * 0.5;
                    rightBarButton.center = center;

                }else{
                    if (rightBarButton.titleLabel.frame.size.width) {
                        rightBarButton.frame = CGRectMake(itemWidth  + self.navItemSpace*idx, 0, rightBarButton.titleLabel.frame.size.width + NavigationButtonItemTitleExtensionMargin, _navigationBarContentH);
                    }else{
                        rightBarButton.frame = CGRectMake(itemWidth  + self.navItemSpace*idx, 0, rightBarButton.imageView.image.size.width + NavigationButtonItemImageExtensionMargin, _navigationBarContentH);
                    }
                    
                }
                itemWidth += rightBarButton.frame.size.width;
                //有效item个数累计
                idx ++;
            }
            
            if ([_rightBarButtonItems indexOfObject:item] == (_rightBarButtonItems.count - 1)) {
                self.rightStackView.frame = CGRectMake(self.frame.size.width - self.navRightSideMargin - itemWidth - self.navItemSpace*(idx - 1), 0, itemWidth + self.navItemSpace*(idx - 1), _navigationBarContentH);
            }
        }
    }else{
        self.rightStackView.hidden = YES;
    }
    [self layoutCenterStackView];
}

/**
 setter--隐藏左边控件
 */
- (void)setHidesLeftButtonItem:(BOOL)hidesLeftButtonItem{
    
    _hidesLeftButtonItem = hidesLeftButtonItem;
    [self layoutLeftItems];
}

- (void)setNavLeftSideMargin:(CGFloat)navLeftSideMargin{
    _navLeftSideMargin = navLeftSideMargin;
    [self layoutLeftItems];
}

- (void)setNavRightSideMargin:(CGFloat)navRightSideMargin{
    _navRightSideMargin = navRightSideMargin;
     [self layoutRightItems];
}

/**
 setter--隐藏右边控件
 */
- (void)setHidesRightButtonItem:(BOOL)hidesRightButtonItem{
    _hidesRightButtonItem = hidesRightButtonItem;
    [self layoutRightItems];
}

/**
 setter--背景颜色
 */
- (void)setBarTintColor:(UIColor *)barTintColor{
    _barTintColor = barTintColor;
    self.backgroundColor = _barTintColor;
}

/**
 setter--标题
 */
- (void)setNavTitle:(NSString *)navTitle{
    _navTitle = navTitle;
    self.centerStackView.hidden = NO;
    self.navTitleLab.text = _navTitle;
    [self layoutCenterStackView];
}

/**
 setter--标题字体
 */
- (void)setNavTitleFont:(UIFont *)navTitleFont{
    _navTitleFont = navTitleFont;
    self.navTitleLab.font = _navTitleFont;
    [self layoutCenterStackView];
}

/**
 setter--标题颜色
 */
- (void)setNavTitleColor:(UIColor *)navTitleColor{
    _navTitleColor = navTitleColor;
    self.navTitleLab.textColor = _navTitleColor;
}

/**
 setter--隐藏标题
 */
- (void)setHideNavTitle:(BOOL)hideNavTitle{
    _hideNavTitle = hideNavTitle;
    self.navTitleLab.hidden = _hideNavTitle;
}

/**
 setter--标题富文本
 */
- (void)setNavTitleAttributedText:(NSAttributedString *)navTitleAttributedText{
    _navTitleAttributedText = navTitleAttributedText;
    self.centerStackView.hidden = NO;
    self.navTitleLab.attributedText = _navTitleAttributedText;
    [self layoutCenterStackView];
}

/**
 setter--中间自定义
 */
- (void)setCustomView:(UIView *)customView{
    if (customView) {
        _customView = customView;
        [self.centerStackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _customView.hidden = NO;
        self.centerStackView.hidden = NO;
        //必要的一步
        [self.centerStackView addSubview:_customView];
        [self layoutCenterStackView];
    }
}

/**
 setter--隐藏底部分界线
 */
- (void)setHidesNavBottomLine:(BOOL)hidesNavBottomLine{
    _hidesNavBottomLine = hidesNavBottomLine;
    self.navigationBarBottomLine.hidden = _hidesNavBottomLine;
}

/**
 setter--底部分界线颜色
 */
- (void)setNavBottomLineColor:(UIColor *)navBottomLineColor{
    _navBottomLineColor = navBottomLineColor;
    self.navigationBarBottomLine.backgroundColor = _navBottomLineColor;
}

/**
 setter--导航栏背景图片
 */
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    self.backgroundColor = [UIColor colorWithPatternImage:_backgroundImage];
}

- (void)setNavItemSpace:(CGFloat)navItemSpace{
    _navItemSpace = navItemSpace;
}

/**
 重新布局左边内容
 */
- (void)relayoutLeftContent{
    [self layoutLeftItems];
}

/**
 重新布局右边内容
 */
- (void)relayoutRightContent{
     [self layoutRightItems];
}

/**
 设置中间视图
 */
- (void)layoutCenterStackView{
    self.centerStackView.hidden = NO;
    CGFloat originalCenterWidth = 0;
    
    if (_customView.isHidden) {
        [self.navTitleLab sizeToFit];
        originalCenterWidth = CGRectGetWidth(self.navTitleLab.frame);
    }else{
        originalCenterWidth = CGRectGetWidth(_customView.frame);
    }
    if (self.leftStackView.isHidden) {
        self.leftStackView.frame = CGRectZero;
    }
    
    if (self.rightStackView.isHidden) {
        self.rightStackView.frame = CGRectZero;
    }
    
    if (self.centerStackView.isHidden) {
        self.centerStackView.frame = CGRectZero;
    }
    
    CGFloat centerPointFromLeftMargin = self.navigationBarContentView.frame.size.width * 0.5 - CGRectGetMaxX(self.leftStackView.frame);
    CGFloat centerPointFromRightMargin = CGRectGetMinX(self.rightStackView.frame) - self.navigationBarContentView.frame.size.width * 0.5;
    CGFloat titleLimitWidth = self.navigationBarContentView.frame.size.width - self.navLeftSideMargin + self.navRightSideMargin - self.leftStackView.frame.size.width - self.rightStackView.frame.size.width;
    CGFloat titleWidth = titleLimitWidth > originalCenterWidth ? originalCenterWidth : titleLimitWidth;
    //左边拥挤
    BOOL leftCrowded = !CGRectEqualToRect(self.leftStackView.frame,CGRectZero) && ((CGRectGetMaxX(self.leftStackView.frame) >self.navigationBarContentView.frame.size.width * 0.5) || (fabs(centerPointFromLeftMargin) < titleWidth * 0.5));
    //右边拥挤
    BOOL rightCrowded = !CGRectEqualToRect(self.rightStackView.frame,CGRectZero) && ((CGRectGetMinX(self.rightStackView.frame) < self.navigationBarContentView.frame.size.width * 0.5) || (fabs(centerPointFromRightMargin) < titleWidth * 0.5));
    if (leftCrowded && rightCrowded) {
        self.centerStackView.frame = CGRectMake(CGRectGetMaxX(self.leftStackView.frame), 0, titleWidth, _navigationBarContentH);
        
        if (_customView.isHidden) {
            CGRect frame = self.navTitleLab.frame;
            frame.size.width = titleWidth;
            self.navTitleLab.frame = frame;
            self.navTitleLab.center = CGPointMake(self.centerStackView.frame.size.width * 0.5, self.centerStackView.frame.size.height * 0.5);
            if (titleWidth < 15) {
                self.centerStackView.hidden = YES;
            }else if (titleWidth < 25) {
                self.navTitleLab.text = @"...";
            }
            
        }else{
            CGPoint center = _customView.center;
            center.y = self.centerStackView.frame.size.height * 0.5;
            _customView.center = center;
            self.centerStackView.clipsToBounds = YES;
            if (titleWidth < 15) {
                self.centerStackView.hidden = YES;
            }
        }
        
    }else if (leftCrowded){
        
        self.centerStackView.frame = CGRectMake(CGRectGetMaxX(self.leftStackView.frame), 0, titleWidth, _navigationBarContentH);
        
        if (_customView.isHidden) {
            CGRect frame = self.navTitleLab.frame;
            frame.size.width = titleWidth;
            self.navTitleLab.frame = frame;
            self.navTitleLab.center = CGPointMake(self.centerStackView.frame.size.width * 0.5, self.centerStackView.frame.size.height * 0.5);
            if (titleWidth < 15) {
                self.centerStackView.hidden = YES;
            }else if (titleWidth < 25) {
                self.navTitleLab.text = @"...";
            }
            
        }else{
            CGPoint center = _customView.center;
            center.y = self.centerStackView.frame.size.height * 0.5;
            _customView.center = center;
            self.centerStackView.clipsToBounds = YES;
            if (titleWidth < 15) {
                self.centerStackView.hidden = YES;
            }
        }
    }else if (rightCrowded){
        
        self.centerStackView.frame = CGRectMake(CGRectGetMinX(self.rightStackView.frame) - titleWidth, 0, titleWidth, _navigationBarContentH);
        
        if (_customView.isHidden) {
            CGRect frame = self.navTitleLab.frame;
            frame.size.width = titleWidth;
            self.navTitleLab.frame = frame;
            self.navTitleLab.center = CGPointMake(self.centerStackView.frame.size.width * 0.5, self.centerStackView.frame.size.height * 0.5);
            if (titleWidth < 15) {
                self.centerStackView.hidden = YES;
            }else if (titleWidth < 25) {
                self.navTitleLab.text = @"...";
            }
        }else{
            CGPoint center = _customView.center;
            center.y = self.centerStackView.frame.size.height * 0.5;
            _customView.center = center;
            self.centerStackView.clipsToBounds = YES;
            if (titleWidth < 15) {
                self.centerStackView.hidden = YES;
            }
        }
    }else{
        self.centerStackView.frame = CGRectMake(0, 0, originalCenterWidth, _navigationBarContentH);
        self.centerStackView.center = CGPointMake(self.navigationBarContentView.frame.size.width * 0.5, self.navigationBarContentView.frame.size.height * 0.5);
        if (_customView.isHidden) {
            
            self.navTitleLab.center = CGPointMake(self.centerStackView.frame.size.width * 0.5, self.centerStackView.frame.size.height * 0.5);
        }else{
            CGPoint center = _customView.center;
            center.y = self.centerStackView.frame.size.height * 0.5;
            _customView.center = center;
            self.centerStackView.clipsToBounds = YES;
            if (titleWidth < 15) {
                self.centerStackView.hidden = YES;
            }
        }
    }
}

@end

