#pragma mark - UIPageViewControllerDelegate


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.animatingPage = YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSwipedAnyQuote"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.animatingPage = false;
    [self didReadQuote];
    [LRFeedManager sharedManager].currentIndex = ((LRQuoteViewController *)self.pageViewController.viewControllers.firstObject).index;
    [LRAnalytics logEvent:@"Swiped Quote"];
    
    

    // Show the like hint pop-up
    [self showLikeHint];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    LRQuoteViewController *currentViewController = (LRQuoteViewController *)viewController;
    if ([currentViewController index] == 0)
    {
        return nil;
    }
    return [self quoteViewControllerForIndex:currentViewController.index-1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    LRQuoteViewController *currentViewController = (LRQuoteViewController *)viewController;
    return [self quoteViewControllerForIndex:currentViewController.index+1];
}

#pragma mark - Timer

- (void)onTimer
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSwipedAnyQuote"]) {
        [self showSwipeHint];
    }
    [self.hintTimer invalidate];
    self.hintTimer = nil;
}

@end
