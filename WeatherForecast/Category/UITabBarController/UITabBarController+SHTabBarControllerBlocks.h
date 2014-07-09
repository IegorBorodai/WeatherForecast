
#pragma mark - Block Defintions
typedef BOOL (^SHTabBarControllerPredicateBlock)(UITabBarController  * theTabBarController,
UIViewController * theViewController);

typedef void (^SHTabBarControllerBlock)(UITabBarController  * theTabBarController,
UIViewController * theViewController);

typedef void (^SHTabBarControllerCustomizingBlock)(UITabBarController  * theTabBarController,
NSArray  * theViewControllers);

typedef void (^SHTabBarControllerCustomizingWithChangeBlock)(UITabBarController  * theTabBarController,
NSArray * theViewControllers,
BOOL      isChanged);

typedef id<UIViewControllerInteractiveTransitioning>
(^SHTabBarControllerInteractiveControllerBlock)(UITabBarController * tabBarController,
                                                id<UIViewControllerAnimatedTransitioning> animationController
                                                );

typedef id<UIViewControllerAnimatedTransitioning>
(^SHTabBarControllerAnimatedControllerBlock) (UITabBarController * tabBarController,
                                              UIViewController * fromVC,
                                              UIViewController * toVC
                                              );



@interface UITabBarController (SHTabBarControllerBlocks)



#pragma mark - Properties

#pragma mark - Setters
-(void)completionSetShouldSelectViewControllerBlock:(SHTabBarControllerPredicateBlock)theBlock;
-(void)completionSetDidSelectViewControllerBlock:(SHTabBarControllerBlock)theBlock;
-(void)completionSetWillBeginCustomizingViewControllersBlock:(SHTabBarControllerCustomizingBlock)theBlock;
-(void)completionSetWillEndCustomizingViewControllersBlock:(SHTabBarControllerCustomizingWithChangeBlock)theBlock;
-(void)completionSetDidEndCustomizingViewControllersBlock:(SHTabBarControllerCustomizingWithChangeBlock)theBlock;
-(void)completionSetInteractiveControllerBlock:(SHTabBarControllerInteractiveControllerBlock)theBlock;
-(void)completionSetAnimatedControllerBlock:(SHTabBarControllerAnimatedControllerBlock)theBlock;



#pragma mark - Getters
@property(nonatomic,readonly) SHTabBarControllerPredicateBlock completionBlockShouldSelectViewController;
@property(nonatomic,readonly) SHTabBarControllerBlock completionBlockDidSelectViewController;
@property(nonatomic,readonly) SHTabBarControllerCustomizingBlock completionBlockWillBeginCustomizingViewControllers;
@property(nonatomic,readonly) SHTabBarControllerCustomizingWithChangeBlock completionBlockWillEndCustomizingViewControllers;
@property(nonatomic,readonly) SHTabBarControllerCustomizingWithChangeBlock completionBlockDidEndCustomizingViewControllers;
@property(nonatomic,readonly) SHTabBarControllerInteractiveControllerBlock completionBlockInteractiveController;
@property(nonatomic,readonly) SHTabBarControllerAnimatedControllerBlock completionBlockAnimatedController;

@end