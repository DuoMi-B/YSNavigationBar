//
//  YSNavigationBar.h
//  

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, YSControlState) {
    YSControlStateNormal       = 0,
    YSControlStateHighlighted  = 1 << 0,
    YSControlStateDisabled     = 1 << 1,
    YSControlStateSelected     = 1 << 2,
    YSControlStateFocused NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 3,
    YSControlStateApplication  = 0x00FF0000,
    YSControlStateReserved     = 0xFF000000
};

@interface YSBarButtonItem : UIControl

@property (nonatomic,strong,readonly) UIView *context;
@property(nullable, nonatomic,readonly,strong) NSString *currentTitle;
@property(nullable, nonatomic,readonly,strong) UIColor  *currentTitleColor;
@property(nullable, nonatomic,readonly,strong) UIColor  *currentTitleShadowColor;
@property(nullable, nonatomic,readonly,strong) UIImage  *currentImage;
@property(nullable, nonatomic,readonly,strong) UIImage  *currentBackgroundImage;
@property(nullable, nonatomic,readonly,strong) NSAttributedString *currentAttributedTitle;
/** 扩展边距 */
@property (nonatomic, assign) CGFloat titleExtensionMargin;

//********** 扩展：当按钮点击样式发生改变 **********
/** 无按钮高亮点击 */
@property(nonatomic, assign) BOOL adjustsImageWhenHighlighted;
/** 自定义尺寸  */
@property (nonatomic,assign) CGSize itemCustomSize;
/** 圆角 */
@property (nonatomic, assign) CGFloat itemCornerRadius;
/** 背景颜色 */
@property (nullable, nonatomic, strong) UIColor *itemBackgroundColor;
/** 字体  */
@property (nullable, nonatomic,strong) UIFont *itemTitleFont;


- (void)setTitle:(nullable NSString *)title forState:(YSControlState)state;
- (void)setTitleColor:(nullable UIColor *)color forState:(YSControlState)state;
- (void)setTitleShadowColor:(nullable UIColor *)color forState:(YSControlState)state;
- (void)setImage:(nullable UIImage *)image forState:(YSControlState)state;
- (void)setBackgroundImage:(nullable UIImage *)image forState:(YSControlState)state;
- (void)setAttributedTitle:(nullable NSAttributedString *)title forState:(YSControlState)state;

- (nullable NSString *)titleForState:(YSControlState)state;
- (nullable UIColor *)titleColorForState:(YSControlState)state;
- (nullable UIColor *)titleShadowColorForState:(YSControlState)state;
- (nullable UIImage *)imageForState:(YSControlState)state;
- (nullable UIImage *)backgroundImageForState:(YSControlState)state;
- (nullable NSAttributedString *)attributedTitleForState:(YSControlState)state;

//禁止外部调用
-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;


//构建方法-标题
- (instancetype)initWithImage:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;
- (instancetype)initWithImage:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage target:(nullable id)target action:(nullable SEL)action;
- (instancetype)initWithImage:(nullable UIImage *)image disabledImage:(nullable UIImage *)disabledImage target:(nullable id)target action:(nullable SEL)action;
//构建方法-图片
- (instancetype)initWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (instancetype)initWithTitle:(nullable NSString *)title selectedTitle:(nullable NSString *)selectedTitle target:(nullable id)target action:(nullable SEL)action;
- (instancetype)initWithTitle:(nullable NSString *)title disabledTitle:(nullable NSString *)disabledTitle target:(nullable id)target action:(nullable SEL)action;
@end


@interface YSNavigationBar : UIView
/** 导航栏左侧按钮数组，顺序：左 -> 右 对应 0 -> 1 */
@property (nullable, nonatomic,strong) NSArray<__kindof  UIView *> *leftBarButtonItems;//外面可传入UIButton,必须以数组形式；如果UIButton设置了frame，内部只处理UIButton的宽度和高度，x和y不做处理。
/** 导航栏右侧按钮数组,顺序：左 -> 右 对应 0 -> 1 */
@property (nullable, nonatomic,strong) NSArray<__kindof  UIView *> *rightBarButtonItems;//外面可传入UIButton,必须以数组形式；如果UIButton设置了frame，内部只处理UIButton的宽度和高度，x和y不做处理。
/** 导航栏左侧按钮  */
@property (nullable, nonatomic,strong) YSBarButtonItem *leftBarButtonItem;
/** 导航栏右侧按钮  */
@property (nullable, nonatomic,strong) YSBarButtonItem *rightBarButtonItem;
/** 导航栏标题  */
@property (nullable, nonatomic,copy) NSString *navTitle;
/** 导航栏背景颜色  */
@property(nullable, nonatomic,strong) UIColor *barTintColor;  // default is white
//**************************************************************
/** 导航栏标题颜色  */
@property (nullable, nonatomic,strong) UIColor *navTitleColor;
/** 导航栏标题字体  */
@property (nullable, nonatomic,strong) UIFont *navTitleFont;
/** 导航栏标题富文本  */
@property (nullable, nonatomic,strong) NSAttributedString *navTitleAttributedText;
/** 隐藏导航栏左边按钮  */
@property (nonatomic,assign,getter=isHidesLeftButtonItem) BOOL hidesLeftButtonItem;
/** 隐藏导航栏右边按钮  */
@property (nonatomic,assign,getter=isHidesRightButtonItem) BOOL hidesRightButtonItem;
/** 隐藏导航栏底部分界线  */
@property (nonatomic,assign,getter=isHidesNavBottomLine) BOOL hidesNavBottomLine;
/** 导航栏底部分界线颜色  */
@property (nullable, nonatomic,strong) UIColor *navBottomLineColor;
/** 中间自定义  */
@property (nullable, nonatomic,strong) __kindof  UIView *customView;
/** 导航栏背景图片  */
@property (nullable, nonatomic,strong) UIImage *backgroundImage;
/** BLBarButtonItem间距 */
@property (nonatomic, assign) CGFloat navItemSpace;
/** 左边距 */
@property (nonatomic, assign) CGFloat navLeftSideMargin;
/** 右边距 */
@property (nonatomic, assign) CGFloat navRightSideMargin;


/** 隐藏标题标题  */
@property (nonatomic,assign) BOOL hideNavTitle;

/**
 根据索引在左边插入item

 @param leftItem 要插入的item
 @param index 索引
 */
- (void)insertLeftItem:(__kindof  UIView *)leftItem atIndex:(NSInteger)index;

/**
 根据索引在右边插入item
 
 @param rightItem 要插入的item
 @param index 索引
 */
- (void)insertRightItem:(__kindof  UIView *)rightItem atIndex:(NSInteger)index;


/**
 左边添加新的item

 @param leftItem 要添加的item
 */
- (void)addLeftItem:(__kindof  UIView *)leftItem;
/**
 右边添加新的item
 
 @param rightItem 要添加的item
 */
- (void)addRightItem:(__kindof  UIView *)rightItem;


/**
 根据索引删除左边的item

 @param index 索引
 */
- (void)removeLeftItemAtIndex:(NSUInteger)index;
/**
 根据索引删除右边的item
 
 @param index 索引
 */
- (void)removeRightItemAtIndex:(NSUInteger)index;


/**
 直接删除item

 @param item 要删除 item
 */
- (void)removeItem:(__kindof  UIView *)item;

/**
 重新布局左边内容
 */
- (void)relayoutLeftContent;

/**
 重新布局右边内容
 */
- (void)relayoutRightContent;
@end
NS_ASSUME_NONNULL_END
