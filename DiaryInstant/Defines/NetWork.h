//
//  NetWork.h
//  DiaryInstant
//
//  Created by George on 2019/3/16.
//  Copyright © 2019 George. All rights reserved.
//

#ifndef NetWork_h
#define NetWork_h

#define head @"http://di.leizhenxd.com"

/* 登录*/
#define cmd_login @"/api/user/login"
/* 注册*/
#define cmd_register @"/api/user/register"

/*添加好友*/
#define cmd_add_friend @"/api/friend/add"

#define cmd_add_resoursc @"/api/resource/add"

#define cmd_query_resourse @"/api/resource/query"

#define cmd_share @"/api/share/share"

#define cmd_share_me @"/api/share/shareToMe"

#define cmd_edit_user @"/api/user/edit"

#define cmd_getFriends @"/api/user/getMyFriends"

#endif /* NetWork_h */
