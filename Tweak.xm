#import "CountMyMessages.h"

%hook CKConversationListController

-(void)viewDidLoad {
	%orig();

	int total = 0;
	int sent = 0;
	int received = 0;
	FMDatabase *db = [FMDatabase databaseWithPath:@"/var/mobile/Library/SMS/sms.db"];
	[db open];

	FMResultSet *s = [db executeQuery:@"SELECT * FROM deleted_messages"];
	NSMutableArray *deletedMessages = [[NSMutableArray alloc] init];
	while ([s next]) {
		[deletedMessages addObject:[s stringForColumn:@"guid"]];
	}

	// Get the chat index
	s = [db executeQuery:@"SELECT * FROM message"];
	while ([s next]) {
		if (![deletedMessages containsObject:[s stringForColumn:@"guid"]]) {
			if ([s boolForColumn:@"is_sent"]) {
				sent += 1;
			} else {
				received += 1;
			}
			total += 1;
		}
	}

	[db close];

	self.title = [NSString stringWithFormat:@"T:%d|S:%d|R:%d", total, sent, received];

}

// -(void)updateNavigationItems {
// 	%orig();
// 	UINavigationItemView* itemView = nil;
// 	for (id v in ((UINavigationController*)self.parentViewController).navigationBar.subviews) {
//
// 		NSString *Msg = [NSString stringWithFormat:@"arg1 %@",v];
// 		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"TextCounter" message:Msg preferredStyle:UIAlertControllerStyleAlert];
// 		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
// 		[alertController addAction:ok];
//
// 		[self presentViewController:alertController animated:YES completion:nil];
//
// 		if (![v isKindOfClass:[%c(_UIBarBackground) class]]) { // iOS 10+
// 			UIView *unknown = (UIView*)v;
// 			// unknown.backgroundColor = [UIColor greenColor];
// 			for (id coolView in unknown.subviews) {
// 				if ([coolView isKindOfClass:[%c(UINavigationItemView) class]]) { // Less than iOS 10
// 					itemView = coolView;
// 					break;
// 				}
// 			}
// 		}
// 	}
//
// 	//OSLog(@"itemView: %@", itemView);
//
// 	if (itemView && !itemView.gestureRecognizers){
// 		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
// 		tapGesture.numberOfTapsRequired=1;
// 		[itemView setUserInteractionEnabled:YES];
// 		[itemView addGestureRecognizer:tapGesture];
// 		[tapGesture release];
// 	} elif (!itemView) {
// 		abort();
// 	}
//
// }

%end


%hook CKDetailsController

-(void)viewDidLoad {
	%orig();

	int total = 0;
	int sent = 0;
	int received = 0;

	FMDatabase *db = [FMDatabase databaseWithPath:@"/var/mobile/Library/SMS/sms.db"];
	[db open];

	total = sent = received = 0;

	for (NSString *guid in self.conversation.chat._guids) {
		// Get the chat index
		FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM chat WHERE guid='%@'", guid]];
		int chatIndex = -1;
		while ([s next]) {
			chatIndex = [s intForColumn:@"ROWID"];
			break;
		}

		if (chatIndex == -1) {
			HBLogError(@"Chat index not found");
			[db close];
			return;
		}

		s = [db executeQuery:@"SELECT * FROM deleted_messages"];
		NSMutableArray *deleted = [[NSMutableArray alloc] init];
		if ([s next]) {
			[deleted addObject:[s stringForColumn:@"guid"]];
		}


		// Get the messages
		s = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM chat_message_join WHERE chat_id='%d'", chatIndex]];
		NSMutableArray *messages = [[NSMutableArray alloc] init];
		while ([s next]) {
			[messages addObject:[s stringForColumn:@"message_id"]];
		}

		total += messages.count;

		// Get sent/received
		for (NSString *message in messages) {
			s = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM message WHERE ROWID='%@'", message]];
			while ([s next]) {
				if (![deleted containsObject:[s stringForColumn:@"guid"]]) {
					if ([s boolForColumn:@"is_sent"]) {
						sent += 1;
					} else {
						received += 1;
					}
				}
			}
		}
	}

	[db close];

	self.title = [NSString stringWithFormat:@"T : %d | S : %d | R : %d", total, sent, received];

}

%end
