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

@interface SBMultiLevelTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIView *sb_contentView;

- (void)setNode:(SBMultiLevelTableNode *)node;

+ (NSValue *)cellSizeWithNode:(SBMultiLevelTableNode *)node
                      maxSize:(NSValue *)maxSizeValue;

@end

@interface SBMultiLevelTableView : UITableView <UITableViewDelegate, UITableViewDataSource>


// 是否支持折叠展开，默认yes
@property (nonatomic, assign) BOOL canFoldAndExpand;

- (id)initWithFrame:(CGRect)frame
          cellClass:(Class)cellClass
              nodes:(NSArray*)nodes
         rootNodeID:(NSString*)rootID
   needPreservation:(BOOL)need 
        selectBlock:(SBMultiLevelTableSelectBlock)block;

@end
