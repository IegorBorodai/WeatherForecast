



@protocol SHViewControllerAnimatedTransitioning <UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign,getter = isReversed) BOOL reversed;
@property(nonatomic,strong) NSMutableDictionary * userInfo;
@property(nonatomic,readonly) id<UIViewControllerContextTransitioning> transitionContext;
@end

typedef void(^SHTransitionAnimationCompletionBlock)();

typedef void(^SHTransitionPreparedAnimationBlock)(UIView * containerView,
                                                  UIViewController * fromVC,
                                                  UIViewController * toVC,
                                                  NSTimeInterval duration,
                                                  id<SHViewControllerAnimatedTransitioning> transitionObject,
                                                  SHTransitionAnimationCompletionBlock transitionDidComplete
                                                  );

typedef void(^SHTransitionAnimationBlock)(id<SHViewControllerAnimatedTransitioning> transitionObject);

typedef NSTimeInterval(^SHTransitionDurationBlock)(id<SHViewControllerAnimatedTransitioning> transitionObject);

typedef UIGestureRecognizer *(^SHTransitionGestureRecognizerCreationBlock)(UIScreenEdgePanGestureRecognizer * edgeRecognizer);

typedef void(^SHTransitionCallbackGestureRecognizerBlock)(UIViewController * controller,
                                                          UIGestureRecognizer * recognizer,
                                                          UIGestureRecognizerState state,
                                                          CGPoint location
                                                          );


@interface UIViewController (SHTransitionBlocks)

@property(nonatomic,strong, setter = SH_setInteractiveTransition:) UIPercentDrivenInteractiveTransition * SH_interactiveTransition;

-(void)completionInteractiveTransitionWithGestureBlock:(SHTransitionGestureRecognizerCreationBlock)theGestureCreateBlock
                            onGestureCallbackBlock:(SHTransitionCallbackGestureRecognizerBlock)theGestureCallbackBlock;

-(id<SHViewControllerAnimatedTransitioning>)SH_animatedTransition;

-(void)completionAnimationDuration:(NSTimeInterval)theDuration
   withPreparedTransitionBlock:(SHTransitionPreparedAnimationBlock)theBlock;

-(void)completionAnimatedTransitionBlock:(SHTransitionAnimationBlock)theBlock;
-(void)completionDurationTransitionBlock:(SHTransitionDurationBlock)theBlock;

@property(nonatomic,readonly) SHTransitionPreparedAnimationBlock SH_blockAnimationDurationWithPreparedTransition;
@property(nonatomic,readonly) SHTransitionAnimationBlock SH_blockAnimatedTransition;
@property(nonatomic,readonly) SHTransitionDurationBlock SH_blockDurationTransition;


@end