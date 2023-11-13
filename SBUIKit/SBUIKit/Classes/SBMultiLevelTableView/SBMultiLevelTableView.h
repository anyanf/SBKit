//
//  SBMultiLevelTableView.h
//  SBMultiLevelTableView
//
//  Created by ankang on 23/11/13.
//  Copyright © 2016年 ankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBMultiLevelTableNode.h"

typedef void(^SBMultiLevelTableSelectBlock)(SBMultiLevelTableNode *node);

@interface SBMultiLevelTableView : UITableView

- (id)initWithFrame:(CGRect)frame nodes:(NSArray*)nodes rootNodeID:(NSString*)rootID needPreservation:(BOOL)need selectBlock:(SBMultiLevelTableSelectBlock)block;

@end
