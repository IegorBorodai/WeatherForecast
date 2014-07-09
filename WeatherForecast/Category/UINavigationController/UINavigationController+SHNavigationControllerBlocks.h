

#pragma mark - Block Definitions
typedef void (^SHNavigationControllerBlock)(UINavigationController * navigationController,
                                            UIViewController       * viewController,
                                            BOOL                      isAnimated);

typedef UIInterfaceOrientation(^SHNavigationControllerOrientationBlock)(UINavigationController * navigationController);

typedef id<UIViewControllerInteractiveTransitioning>
(^SHNavigationControllerInteractiveControllerBlock)(UINavigationController * navigationController,
                                                    id<UIViewControllerAnimatedTransitioning> animationController);

typedef id<UIViewControllerAnimatedTransitioning>
(^SHNavigationControllerAnimatedControllerBlock) (UINavigationController * navigationController,
                                                  UINavigationControllerOperation operation,
                                                  UIViewController * fromVC,
                                                  UIViewController * toVC
                                                  );


@interface UINavigationController (SHNavigationControllerBlocks)



#pragma mark - Properties

#pragma mark - Setters

-(void)completionSetWillShowViewControllerBlock:(SHNavigationControllerBlock)theBlock;

-(void)completionSetDidShowViewControllerBlock:(SHNavigationControllerBlock)theBlock;

-(void)completionSetPreferredInterfaceOrientationForPresentatationBlock:(SHNavigationControllerOrientationBlock)theBlock;

-(void)completionSetInteractiveControllerBlock:(SHNavigationControllerInteractiveControllerBlock)theBlock;

-(void)completionSetAnimatedControllerBlock:(SHNavigationControllerAnimatedControllerBlock)theBlock;

#pragma mark - Getters

@property(nonatomic,readonly) SHNavigationControllerBlock completionBlockWillShowViewController;
@property(nonatomic,readonly) SHNavigationControllerBlock completionBlockDidShowViewController;
@property(nonatomic,readonly) SHNavigationControllerOrientationBlock completionBlockInterfaceOrientationForPresentation;
@property(nonatomic,readonly) SHNavigationControllerInteractiveControllerBlock completionBlockInteractiveController;
@property(nonatomic,readonly) SHNavigationControllerAnimatedControllerBlock completionBlockAnimatedController;


@end