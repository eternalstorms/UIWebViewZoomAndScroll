//
//  ActionViewController.m
//  UIWebViewZoomAndScrollActionExtension
//
//  Created by Matthias Gansrigler on 29.01.2015.
//  Copyright (c) 2015 Eternal Storms Software. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	BOOL foundDictionary = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems)
	{
        for (NSItemProvider *itemProvider in item.attachments)
		{
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList])
			{
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *dictionary, NSError *error) {
                    if (dictionary != nil)
					{
						[[NSOperationQueue mainQueue] addOperationWithBlock:^{
							NSDictionary *jsDict = dictionary[NSExtensionJavaScriptPreprocessingResultsKey];
							if (jsDict != nil)
							{
								//we're getting these from the Action.js Java Script
								self._pageXOffset = [jsDict[@"pageXOffset"] integerValue];
								self._pageYOffset = [jsDict[@"pageYOffset"] integerValue];
								self._pageScale = ([jsDict[@"pageScale"] doubleValue]);
								NSString *urlStr = jsDict[@"baseURI"];
								[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
								//we're loading, so we disable scrolling and zooming for now
								self.webView.scrollView.minimumZoomScale = 1.0;
								self.webView.scrollView.maximumZoomScale = 1.0;
								self.webView.scrollView.scrollEnabled = NO;
							}
                        }];
                    }
                }];
				
                foundDictionary = YES;
                break;
            }
        }
        
        if (foundDictionary)
            break;
    }
}

#pragma mark - UIWebView Delegate Methods

//This is the kicker, 'white rabbit object'. whatever it did, it did it all
//in all seriousness though, this is where it all happens
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	if (self.webView.loading) //make sure the page is done loading
		return;
	
	//loading done, enable scrolling again
	self.webView.scrollView.scrollEnabled = YES;
	
	//enable zooming again
	self.webView.scrollView.minimumZoomScale = 1.0;
	self.webView.scrollView.maximumZoomScale = 50.0;
	
	//have to do this twice, otherwise the page is blurred
	self.webView.scrollView.zoomScale = 1.0;
	self.webView.scrollView.zoomScale = self._pageScale-(0.001f);
	[self.webView.scrollView setZoomScale:self._pageScale
								 animated:YES];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //had to do this; otherwise, after the 4th time, it wouldn't work so well
		//we're doing this in dispatch_after because if we didn't, after the 4th time or so, it wouldn't work so well anymore
		//this is a javascript that is run on the website loaded into our webView to tell it to scroll to the x and y offset we got from the Action.js Java Script
		[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(%ld,%ld)",self._pageXOffset,self._pageYOffset]];
	});
}

- (IBAction)done
{
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
