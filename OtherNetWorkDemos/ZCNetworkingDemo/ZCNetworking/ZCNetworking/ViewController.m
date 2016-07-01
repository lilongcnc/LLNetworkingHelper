//
//  ViewController.m
//  ZCNetworking
//
//  Created by charles on 16/4/15.
//  Copyright © 2016年 charles. All rights reserved.
//

#import "ViewController.h"
#import "ZCApiLauncher.h"
#import "MenuView.h"


//避免宏循环引用
#define LLWeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define LLStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


#define LLKeyWindowSize [UIScreen mainScreen].bounds.size


static NSDictionary *dictFromData(NSData *returnData){
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
    return content;
    
}


@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) MenuView *menuView;

@end

@implementation ViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSubViews];
    
    //在app delegate里面设置比较好,任意地点设置也没问题,不过需要在调用api之前设置
    [[ZCApiRunner sharedInstance] startWithDebugDomain:@"http://192.168.1.194:1800" releaseDomain:@"http://192.168.1.194:1800/deal.ashx"];

    [[ZCApiRunner sharedInstance] codeKey:@"msgCode"];
    [[ZCApiRunner sharedInstance] successCodes:@[@"1001"]];
    [[ZCApiRunner sharedInstance] warningReturnCodes:@[@"10011"] withHandler:^(NSString *code) {
    if ([code isEqualToString:@"10011"]) {
        //做自己的操作,例如登录等
        NSLog(@"%s",__FUNCTION__);
    }
    }];
}



- (void)initSubViews{
    
    _menuView = ({
        MenuView *menuView = [[MenuView alloc] initWithFrame:(CGRect){0,0,LLKeyWindowSize.width,LLKeyWindowSize.height}];
        [self.view addSubview:menuView];
        @LLWeakObj(self);
        [menuView setMenuViewOnClick:^(NSString *title) {
            @LLStrongObj(self);
            if ([title isEqualToString:@"登录"]) {
                [self ll_loginRequest];
            }else if ([title isEqualToString:@"签到"]) {
                [self ll_doSignRequest];
            }
            else if ([title isEqualToString:@"单图上传"]) {
                [self ll_uploadOnePicture];
            }else if ([title isEqualToString:@"多图上传"]) {
                [self ll_morePicturesUpload];
            }else if ([title isEqualToString:@"单个图片下载"]) {
                [self ll_downLoadOnePictureRequest];
            }else if ([title isEqualToString:@"batch"]) {
                [self ll_batchRequest];
            }else if ([title isEqualToString:@"chain"]) {
                [self ll_chainRequest];
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }

        }];
        menuView;
    });
    
}



#pragma mark - 使用说明

/**
 *  一切全局的设置,可有可没有.
    一般api会返回一个code表示api逻辑是否成功.
    如果有设置了codekey,则需要设置成功code.当api返回时,会根据code key和success code的设置进行判定进入success还是failure回调
    是否成功仅仅依赖success codes,不依赖warning codes.
    对于一些全局的warning codes,可以设置handler.比如登录失效,可以设置一个handler进行登录.
 */
- (void)globleSettings {
    [[ZCApiRunner sharedInstance] codeKey:@"code"];
    [[ZCApiRunner sharedInstance] successCodes:@[@"0"]];
    [[ZCApiRunner sharedInstance] warningReturnCodes:@[@"-1"] withHandler:^(NSString *code) {
        if ([code isEqualToString:@"-1"]) {
            //做自己的操作,例如登录等
        }
    }];
}

/**
 *  api from 百思不得姐,随时失效.请用有效的api进行测试
    这是普通的api请求,获取数据.ZCApiAction中有更多的属性可以设置.
 */
- (void)nomarlActionTest {
    ZCApiAction *action = [[ZCApiAction alloc] initWithURL:@"api/api_open.php"];
    //参数
    action.params[@"a"] = @"user_login_report";
    action.params[@"appname"] = @"baisishequ";
    action.params[@"c"] = @"user";
    action.params[@"client"] = @"iphone";
    
    //可选属性
    action.showLog = YES;
    action.actionWillInvokeBlock = ^{
        NSLog(@"will start");
    };
    
    action.actionDidInvokeBlock = ^(BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"success");
        }
        else {
            NSLog(@"failure");
        }
    };
    
    [[ZCApiRunner sharedInstance] runAction:action success:^(id object) {
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  没有相关的api,只能做个使用示例
 */
- (void)uploadActionTest {
    ZCApiUploadAction *action = [[ZCApiUploadAction alloc] initWithURL:@"xxx"];
    //参数,同普通action一样
    action.params[@""] = @"";
    
    //根据上传任务调整timeout
    action.timeout = 300;
    
    //上传必要参数,由server端提供
    action.data = [NSData data];
    action.fileName = @"xxx";
    action.uploadName = @"xxx";
    action.mimeType = @"xxx";
    
    /*
     如果是多data上传(例如一个身份证上传api,需要上传身份证正反面)
     可以使用数组形式的参数,不过单个data上传和多个data上传需要互斥
     并且多个data上传,需要统一,也就是data/filename/uploadname/mimetype的数组数量一致
     因为是通过index来进行匹配的.
     */
//    action.dataArray = @[];
//    action.uploadNameArray = @[];
//    action.fileNameArray = @[];
//    action.mimeTypeArray = @[];
    
    [[ZCApiRunner sharedInstance] uploadAction:action progress:nil success:^(id object) {
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark +++++++++++++++++++++++++++++++++++++++++++++++++++ 华丽的分割线  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

- (void)ll_loginRequest {
    //htt://192.168.1.194:1800/JoinCustomer.ashx?action=login&userAccount=15801538221&Passwd=E10ADC3949BA59ABBE56E057F20F883E&version=1.0&BusinessAreaID=
    
    //单个登录
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"login",@"action",
                                       @"15801538221",@"userAccount",
                                       @"E10ADC3949BA59ABBE56E057F20F883E",@"Passwd",
                                       @"1.0",@"version",
                                       nil];
    
        [[ZCNetworking sharedInstance] sendRequestWithURL:@"http://192.168.1.194:1800/JoinCustomer.ashx" method:@"POST" params:params success:^(id object) {
            NSLog(@"%s  %@",__FUNCTION__,object);
            NSLog(@"%s  %@",__FUNCTION__,dictFromData(object));
    
        } failure:^(NSError *error) {
            NSLog(@"%s  %@",__FUNCTION__,error);
        }];
    
    
}


- (void)ll_downLoadOnePictureRequest{
    //下载测试
    @LLWeakObj(self);
    [[ZCNetworking sharedInstance] downloadFileByURL:@"http://www.lilongcnc.cc/lauren_picture/20160119/1.jpg" savePath:[self getDownloadPath] process:^(NSProgress *downloadProgress) {
        NSLog(@"%@",downloadProgress);

    } success:^{
        NSLog(@"successed");


        UIImage *icon = [UIImage imageWithContentsOfFile:[self getDownloadPath]];
        NSLog(@"%@",[UIImage imageWithContentsOfFile:[self getDownloadPath]]);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @LLStrongObj(self);

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 350, 100)];
            imageView.image = icon;
            [self.view addSubview:imageView];
        });

    } failure:^(NSError *error) {
        NSLog(@"failed");
    }];

}


- (void)ll_uploadOnePicture{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.delegate = self;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark UIImagePickerControllerDelegate
//当选择的类型是图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"selected images ->%@",info);
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageDatass = UIImagePNGRepresentation(image);
        
        //        Printing description of parameters:
        //        {
        //            CustomerID = "C0016050400001",
        //            Type = "OfflineProduct",
        //            flowId = "160627134348962",
        //            action = "uploadphoto",
        //        }
        
//        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @"uploadphoto",@"action",
//                                    @"C0016050400001",@"CustomerID",
//                                    @"OfflineProduct",@"Type",
//                                    @"160627134348962",@"flowId",
//                                    nil];
        
        ZCApiUploadAction *upload = [[ZCApiUploadAction alloc] initWithURL:@"/deal.ashx"];
//        upload.params = [NSMutableDictionary dictionaryWithDictionary:parameters];
        upload.params[@"action"] = @"uploadphoto";
        upload.params[@"CustomerID"] = @"C0016050400001";
        upload.params[@"Type"] = @"OfflineProduct";
        upload.params[@"flowId"] = @"160628100654295";
        
        
        upload.showLog = YES;
        upload.data = imageDatass;
        upload.uploadName = @"data";
        upload.fileName = @"photo.png";
        upload.mimeType = @"image/png";
        

        
        [[ZCApiRunner sharedInstance] uploadAction:upload progress:^(NSProgress *uploadProgress) {
            NSLog(@"🐱🐱🐱progress: %@",uploadProgress);
            
        } success:^(id object) {
            NSLog(@"🐷🐷🐷upload successed:%@",object);
            
            
        } failure:^(NSError *error) {
            NSLog(@"🐶🐶🐶upload failed:%@",error);
        }];
        
    }
    
}


- (void)ll_morePicturesUpload{
    
    NSData *imageData1 = UIImagePNGRepresentation([UIImage imageNamed:@"1"]);
    NSData *imageData2 = UIImagePNGRepresentation([UIImage imageNamed:@"2"]);
    NSData *imageData3 = UIImagePNGRepresentation([UIImage imageNamed:@"3"]);
    NSData *imageData4 = UIImagePNGRepresentation([UIImage imageNamed:@"4"]);
    NSData *imageData5 = UIImagePNGRepresentation([UIImage imageNamed:@"5"]);
    NSData *imageData6 = UIImagePNGRepresentation([UIImage imageNamed:@"6"]);
    NSData *imageData7 = UIImagePNGRepresentation([UIImage imageNamed:@"7"]);
    NSData *imageData8 = UIImagePNGRepresentation([UIImage imageNamed:@"8"]);
    NSData *imageData9 = UIImagePNGRepresentation([UIImage imageNamed:@"9"]);

    
    
    
    ZCApiUploadAction *upload = [[ZCApiUploadAction alloc] initWithURL:@"/deal.ashx"];
    //        upload.params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    upload.params[@"action"] = @"uploadphoto";
    upload.params[@"CustomerID"] = @"C0016050400001";
    upload.params[@"Type"] = @"OfflineProduct";
    upload.params[@"flowId"] = @"160628100654295";
//    upload.params[@"data"] = imageData1;
    
    upload.showLog = YES;
    
    /*
     如果是多data上传(例如一个身份证上传api,需要上传身份证正反面)
     可以使用数组形式的参数,不过单个data上传和多个data上传需要互斥
     并且多个data上传,需要统一,也就是data/filename/uploadname/mimetype的数组数量一致
     因为是通过index来进行匹配的.
     */
    upload.showLog = YES;
    upload.dataArray = @[imageData1,imageData2,imageData3,imageData4,imageData5,imageData6,imageData7,imageData8,imageData9];
    upload.uploadNameArray = @[@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data",@"data"];
    upload.fileNameArray = @[@"photo.png",@"photo.png",@"photo.png",@"photo.png",@"photo.png",@"photo.png",@"photo.png",@"photo.png",@"photo.png"];
    upload.mimeTypeArray = @[@"image/png",@"image/png",@"image/png",@"image/png",@"image/png",@"image/png",@"image/png",@"image/png",@"image/png"];
    
    
    [[ZCApiRunner sharedInstance] uploadAction:upload progress:^(NSProgress *uploadProgress) {
        NSLog(@"🐱🐱🐱progress: %@",uploadProgress);
        
    } success:^(id object) {
        NSLog(@"🐷🐷🐷upload successed:%@",object);
        
    } failure:^(NSError *error) {
        NSLog(@"🐶🐶🐶upload failed:%@",error);
    }];

    
}

#pragma mark ================ 工具方法 ================
- (NSString *)getDownloadPath {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"text.png"];
    NSLog(@"save image path->%@",filePath);
    return filePath;
}



-(void)ll_doSignRequest{
    //手动签到结果
//    Printing description of arges:
//    {
//        action = "signin",
//        CustomerID = "C0016050400001",
//        PosType = "1",
//        fromAPP = "IOS",
//        flowId = "160630152906958",
//        version = "2.0",
//    }


    //单个登录
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"signin",@"action",
                                   @"160630152906958",@"flowId",
                                   @"C0016050400001",@"CustomerID",
                                   @"1",@"PosType",
                                   @"IOS",@"fromAPP",
                                   @"2.0",@"version",
                                   nil];
    
    [[ZCNetworking sharedInstance] sendRequestWithURL:@"http://192.168.1.194:1800/deal.ashx" method:@"POST" params:params success:^(id object) {
//        NSLog(@"%s  %@",__FUNCTION__,object);
        NSLog(@"%s  %@",__FUNCTION__,dictFromData(object));
        
    } failure:^(NSError *error) {
        NSLog(@"%s  %@",__FUNCTION__,error);
    }];

}


- (void)ll_batchRequest{
    
    NSArray<ZCApiAction *> *actionArray = [self getZCApiActionArray];
    
    [[ZCApiRunner sharedInstance] batchTasksWithActions:actionArray success:^(NSDictionary *dict) {
        NSLog(@"%s  %@",__FUNCTION__,dict);
        
    } failure:^(NSError *error) {
        NSLog(@"%s  %@",__FUNCTION__,error);
    }];
}


- (void)ll_chainRequest{

    NSArray<ZCApiAction *> *actionArray = [self getZCApiActionArray];
    
    
    [[ZCApiRunner sharedInstance] chainTasksWithActions:actionArray success:^(NSDictionary *dict) {
        NSLog(@"%s  %@",__FUNCTION__,dict);
    } failure:^(NSError *error) {
        NSLog(@"%s  %@",__FUNCTION__,error);
    }];
    
    
}



// 获取NSArray <ZCApiAction *>数组
- (NSArray *)getZCApiActionArray{
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                   @"login",@"action",
    //                                   @"15801538221",@"userAccount",
    //                                   @"E10ADC3949BA59ABBE56E057F20F883E",@"Passwd",
    //                                   @"1.0",@"version",
    //                                   nil];
    ZCApiAction *action1 = [[ZCApiAction alloc] initWithURL:@"/JoinCustomer.ashx"];
    action1.params[@"action"] =  @"login";
    action1.params[@"userAccount"] =  @"15801538221";
    action1.params[@"Passwd"] =  @"E10ADC3949BA59ABBE56E057F20F883E";
    action1.params[@"version2"] =  @"1.0";
    action1.actionWillInvokeBlock = ^{
        NSLog(@"1 - will start");
    };
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                   @"signin",@"action",
    //                                   @"160630152906958",@"flowId",
    //                                   @"C0016050400001",@"CustomerID",
    //                                   @"1",@"PosType",
    //                                   @"IOS",@"fromAPP",
    //                                   @"2.0",@"version",
    //                                   nil];
    ZCApiAction *action2 = [[ZCApiAction alloc] initWithURL:@"/deal.ashx"];
    action2.params[@"action"] =  @"signin";
    action2.params[@"flowId"] =  @"160630152906958";
    action2.params[@"CustomerID"] =  @"C0016050400001";
    action2.params[@"PosType"] =  @"1";
    action2.params[@"fromAPP"] =  @"IOS";
    action2.params[@"version"] =  @"2.0";
    action2.actionWillInvokeBlock = ^{
        NSLog(@"2 - will start");
    };
    
    return @[action1,action2];
}
@end
