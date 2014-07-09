

#pragma mark - Block Def
typedef void (^SHWebViewBlock)(UIWebView * theWebView);

typedef void (^SHWebViewBlockWithError)(UIWebView * theWebView, NSError * theError);

typedef BOOL (^SHWebViewBlockWithRequest)(UIWebView * theWebView, NSURLRequest * theRequest,UIWebViewNavigationType theNavigationType);

@interface UIWebView (SHWebViewBlocks)


#pragma mark - Helpers
-(void)SH_loadRequestWithString:(NSString *)theString;


#pragma mark - Properties


#pragma mark - Setters


-(void)completionShouldStartLoadWithRequestBlock:(SHWebViewBlockWithRequest)theBlock;

-(void)completionDidStartLoadBlock:(SHWebViewBlock)theBlock;

-(void)completionDidFinishLoadBlock:(SHWebViewBlock)theBlock;

-(void)completionDidFailLoadWithErrorBlock:(SHWebViewBlockWithError)theBlock;





#pragma mark - Getters

@property(nonatomic,readonly) SHWebViewBlockWithRequest SH_blockShouldStartLoadingWithRequest;

@property(nonatomic,readonly) SHWebViewBlock SH_blockDidStartLoad;

@property(nonatomic,readonly) SHWebViewBlock SH_blockDidFinishLoad;

@property(nonatomic,readonly) SHWebViewBlockWithError SH_blockDidFailLoadWithError;

@end