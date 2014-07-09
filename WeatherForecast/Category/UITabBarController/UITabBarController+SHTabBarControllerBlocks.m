
#import "UITabBarController+SHTabBarControllerBlocks.h"

#define SHStaticConstString(X) static NSString * const X = @#X

SHStaticConstString(completionBlockShouldSelectViewController);
SHStaticConstString(completionBlockDidSelectViewController);
SHStaticConstString(completionBlockWillBeginCustomizingViewControllers);
SHStaticConstString(completionBlockWillEndCustomizingViewControllers);
SHStaticConstString(completionBlockDidEndCustomizingViewControllers);
SHStaticConstString(completionBlockInteractiveController);
SHStaticConstString(completionBlockAnimatedController);



@interface SHTabBarControllerBlocksManager : NSObject
<UITabBarControllerDelegate>

@property(nonatomic,strong) NSMapTable     * mapBlocks;

+(instancetype)sharedManager;
-(void)SH_memoryDebugger;
-(void)setMapTable:(NSMapTable *)theMapTable forObject:(id)theObject;
-(NSMapTable *)mapTableForObject:(id)theObject;
@end
@implementation SHTabBarControllerBlocksManager

#pragma mark - Init & Dealloc
-(instancetype)init {
  self = [super init];
  if (self) {
    self.mapBlocks            = [NSMapTable weakToStrongObjectsMapTable];
    //    [self SH_memoryDebugger];
  }
  
  return self;
}
+(instancetype)sharedManager {
  static SHTabBarControllerBlocksManager *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[SHTabBarControllerBlocksManager alloc] init];
    
  });
  
  return _sharedInstance;
  
}

#pragma mark - Debugger
-(void)SH_memoryDebugger {
  __weak typeof(self) weakSelf = self;
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    NSLog(@"MAP %@",weakSelf.mapBlocks);
    [weakSelf SH_memoryDebugger];
  });
}

#pragma mark - Setter
-(void)setMapTable:(NSMapTable *)theMapTable forObject:(id)theObject {
  [[[SHTabBarControllerBlocksManager sharedManager] mapBlocks] setObject:theMapTable
                                       forKey:theObject];
}

#pragma mark - Getter

-(NSMapTable *)mapTableForObject:(id)theObject {
  return [self.mapBlocks objectForKey:theObject];
}

#pragma mark - <UITabBarControllerDelegate>

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
  
  BOOL shouldSelectViewController = YES;
  SHTabBarControllerPredicateBlock block = [[self mapTableForObject:tabBarController]
                                            objectForKey:completionBlockShouldSelectViewController];
  if(block) shouldSelectViewController = block(tabBarController, viewController);
  return shouldSelectViewController;
  
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
  
  SHTabBarControllerBlock block = [[self mapTableForObject:tabBarController]
                                            objectForKey:completionBlockDidSelectViewController];
  if(block) block(tabBarController, viewController);
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers NS_AVAILABLE_IOS(3_0) {
  
  SHTabBarControllerCustomizingBlock block = [[self mapTableForObject:tabBarController]
                                            objectForKey:completionBlockWillBeginCustomizingViewControllers];
  if(block) block(tabBarController, viewControllers);
  
}
- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed NS_AVAILABLE_IOS(3_0) {
  
  SHTabBarControllerCustomizingWithChangeBlock block = [[self mapTableForObject:tabBarController]
                                            objectForKey:completionBlockWillEndCustomizingViewControllers];
  if(block) block(tabBarController, viewControllers, changed);
  
}
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
  
  SHTabBarControllerCustomizingWithChangeBlock block = [[self mapTableForObject:tabBarController]
                                            objectForKey:completionBlockDidEndCustomizingViewControllers];
  if(block) block(tabBarController, viewControllers, changed);
  
}

- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                      interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController NS_AVAILABLE_IOS(7_0) {

  SHTabBarControllerInteractiveControllerBlock block = [[self mapTableForObject:tabBarController]
                                                        objectForKey:completionBlockInteractiveController];
  id<UIViewControllerInteractiveTransitioning> transition = nil;
  if(block) transition = block(tabBarController, animationController);
  return transition;
  
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {

  SHTabBarControllerAnimatedControllerBlock block = [[self mapTableForObject:tabBarController]
                                                        objectForKey:completionBlockAnimatedController];
  id<UIViewControllerAnimatedTransitioning> transition = nil;
  if(block) transition = block(tabBarController, fromVC, toVC);
  return transition;
  
}




@end



@interface UITabBarController (Private)
@property(nonatomic,readonly) NSMapTable * mapBlocks;
-(void)setBlock:(id)theBlock forKey:(NSString *)theKey;
@end



@implementation UITabBarController (SHTabBarControllerBlocks)

#pragma mark - Setters
-(void)completionSetShouldSelectViewControllerBlock:(SHTabBarControllerPredicateBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockShouldSelectViewController];
}

-(void)completionSetDidSelectViewControllerBlock:(SHTabBarControllerBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockDidSelectViewController];
}

-(void)completionSetWillBeginCustomizingViewControllersBlock:(SHTabBarControllerCustomizingBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockWillBeginCustomizingViewControllers];
}

-(void)completionSetWillEndCustomizingViewControllersBlock:(SHTabBarControllerCustomizingWithChangeBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockWillEndCustomizingViewControllers];
}

-(void)completionSetDidEndCustomizingViewControllersBlock:(SHTabBarControllerCustomizingWithChangeBlock)theBlock{
  [self setBlock:theBlock forKey:completionBlockDidEndCustomizingViewControllers]; 
}

-(void)completionSetInteractiveControllerBlock:(SHTabBarControllerInteractiveControllerBlock)theBlock {
  [self setBlock:theBlock forKey:completionBlockInteractiveController];
}

-(void)completionSetAnimatedControllerBlock:(SHTabBarControllerAnimatedControllerBlock)theBlock{
  [self setBlock:theBlock forKey:completionBlockAnimatedController];
}


#pragma mark - Getters
-(SHTabBarControllerPredicateBlock)completionBlockShouldSelectViewController {
  return [self.mapBlocks objectForKey:completionBlockShouldSelectViewController];
}

-(SHTabBarControllerBlock)completionBlockDidSelectViewController {
  return [self.mapBlocks objectForKey:completionBlockDidSelectViewController];
}

-(SHTabBarControllerCustomizingBlock)completionBlockWillBeginCustomizingViewControllers {
  return [self.mapBlocks objectForKey:completionBlockWillBeginCustomizingViewControllers];
}

-(SHTabBarControllerCustomizingWithChangeBlock)completionBlockWillEndCustomizingViewControllers {
  return [self.mapBlocks objectForKey:completionBlockWillEndCustomizingViewControllers];
}

-(SHTabBarControllerCustomizingWithChangeBlock)completionBlockDidEndCustomizingViewControllers {
  return [self.mapBlocks objectForKey:completionBlockDidEndCustomizingViewControllers];
}


-(SHTabBarControllerInteractiveControllerBlock)completionBlockInteractiveController {
  return [self.mapBlocks objectForKey:completionBlockInteractiveController];
}

-(SHTabBarControllerAnimatedControllerBlock)completionBlockAnimatedController {
  return [self.mapBlocks objectForKey:completionBlockAnimatedController];
}


#pragma mark - Private

#pragma mark - Properties
#pragma mark - setters
-(void)setBlock:(id)theBlock forKey:(NSString *)theKey {
  NSParameterAssert(theKey);
  if(theBlock) [self.mapBlocks setObject:[theBlock copy]  forKey:theKey];
  else         [self.mapBlocks removeObjectForKey:theKey];
}

#pragma mark - Getter
-(NSMapTable *)mapBlocks {
  SHTabBarControllerBlocksManager * manager =[SHTabBarControllerBlocksManager sharedManager];
  self.delegate = manager;
  NSMapTable * mapTable = [manager mapTableForObject:self];
  if(mapTable == nil) mapTable = [NSMapTable strongToStrongObjectsMapTable];
  [manager setMapTable:mapTable forObject:self];
  return mapTable;
  
}

@end

