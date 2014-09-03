//
//  UniversalUrl.m
//  Mera Parivar
//
//  Created by Prajas on 4/18/14.
//  Copyright (c) 2014 Prajas. All rights reserved.
//

#import "UniversalUrl.h"

NSString * facebookBigImage = @"http://graph.facebook.com/ID/picture?type=normal";
NSString * facebookID = @"";
NSString * facebookGender = @"";
NSString * facebookFirst_name = @"";
NSString * facebookLast_name = @"";
NSString * SaveData = @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/insertdata/insertuserdata?secret=prajas&userid=AAA&url=BBB&name=CCC&surname=DDD&age=EEE&gender=FFF&father=GGG&mother=HHH&spouse=III&fb_id=JJJ&tree_name=KKK";
NSString * GetData = @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/get_user/get_specific_user?secret=prajas&userid=AAA";
NSString * UpdateData = @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/updatedata/updateuserdata?secret=prajas&userid=AAA&url=BBB&name=CCC&surname=DDD&age=EEE&gender=FFF&father=GGG&mother=HHH&spouse=III&fb_id=JJJ";
NSString * CheckStatus = @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/checkuser/checkuserexist?secret=prajas&userid=AAA";
NSString * UploadImage = @"http://prajas.com/familytree/insert_data/image1.php";
NSString * SeverImageName = @"";
NSString * GetServerImage = @"http://prajas.com/familytree/insert_data/images/";
NSString * GetUserId = @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/get_id/get_id_by_fbid?secret=prajas&fb_id=";
NSString * GetUserChild = @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/get_rel/get_relationship?secret=prajas&root_id=";
NSMutableArray * First_Name;
NSMutableArray * Last_Name;
NSMutableArray * Image_Url;
NSMutableArray * User_Relation;
NSMutableArray * User_Friend_Id;
NSMutableArray * User_Friend_Name;
//URL
NSString * insert_URL = @"http://prajas.com/familytree/myself.php";
NSString * getdata_URL = @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/get_f_data/get_familytree_data?secret=prajas&devicetoken=";
NSString * parent_URL = @"http://prajas.com/familytree/add_parent.php";
NSString * sibling_URL = @"http://prajas.com/familytree/add_sibling.php";
NSString * child_URL = @"http://prajas.com/familytree/add_child.php";
NSString * get_persnoal_URL = @"http://prajas.com/familytree/getdata.php?fb_id=FBID&ids=AAA";

NSString *CheckUserValidation_url= @"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/checklogin/checklogin?secret=prajas&fb_id=USER";
NSString *Share_URL=@"http://prajas.com/familytree/PHP-Data-Services-master/services/data/family_tree/family_tree_service/add_sharetree/insert_share_tree_data?secret=prajas&editable=EDIT&from_device=FROM&to_device=TO";

NSString *SpouseAdd_URL=@"http://prajas.com/familytree/add_spouse.php";
@implementation UniversalUrl

@end
