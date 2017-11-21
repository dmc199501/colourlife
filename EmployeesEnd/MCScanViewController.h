//
//  MCScanViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/10.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCBarCodeViewController.h"
#import "MCWebViewController.h"

@interface MCScanViewController : MCRootViewControler
{
    ZBarReaderView  *readerView;
}
- (void)startScan;
- (void)stopScan;
@end
