#import "FMDB/FMDB.h"
//#include <string.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define elif else if

@interface IMChat
  @property (nonatomic,readonly) unsigned long long messageCount;
  @property (nonatomic,retain) NSString * guid;
  @property (nonatomic,retain) NSMutableSet * _guids;
  -(id)loadMessagesBeforeDate:(id)arg1 limit:(unsigned long long)arg2 loadImmediately:(BOOL)arg3 ;
@end

@interface CKConversation
  @property (nonatomic,retain) IMChat * chat;
@end

// @interface CKTranscriptRecipientsController : UITableViewController
//   -(double)tableView:(id)arg1 heightForHeaderInSection:(long long)arg2;
//   @property (nonatomic,retain) CKConversation * conversation;
// @end

@interface CKTranscriptDetailsResizableCell : UITableViewCell
@end

@interface CKDetailsController : UITableViewController
  -(double)tableView:(id)arg1 heightForHeaderInSection:(long long)arg2;
  -(CKTranscriptDetailsResizableCell*)locationSendCell;
  @property (nonatomic,retain) CKConversation * conversation;
@end

@interface CKConversationListController : UITableViewController
  -(void)initCounters;
@end

// @interface UINavigationItemView: UIView
// @end
