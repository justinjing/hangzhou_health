//
//  FoodAllTableViewController.m
//  Demo
//
//  Created by llbt_wgh on 14-4-3.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "SprotsOneTableViewController.h"
#import "JSONKit.h"
#import "FoodOneMoreTableViewController.h"
#import "DBHelper.h"
#import "UIDevice+IdentifierAddition.h"
@interface SprotsOneTableViewController ()
{
    NSArray *_dataArray;
}
@end

@implementation SprotsOneTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//返回到上个页面
-(void)backViewUPloadView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"运动建议";
    DBHelper *helper =[[DBHelper alloc]init];
    _dataArray=[[NSArray alloc]initWithArray:[helper getAllSprotsName:_nameStr]];
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *leftBarItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backView.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewUPloadView)];
        self.navigationItem.leftBarButtonItem=leftBarItem;
    }else
    {
        UIButton *btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame=CGRectMake(0, 0, 12, 20);
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"backView.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(backViewUPloadView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    }
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor=HEX(@"#ffffff");
    UIImageView *iamgev=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    iamgev.backgroundColor=[UIColor clearColor];
    iamgev.image=[UIImage imageNamed:@"fooType.png"];
    [view addSubview:iamgev];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 20)];
    label.text=@" 选择运动种类";
    [view addSubview:label];
    
    UIImageView *seper = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    seper.backgroundColor=HEX(@"#5ec4fe");
    [view addSubview:seper];
    self.tableView.tableHeaderView=view;
    
}
- (NSArray *)allPlacesInfoWithStr:(NSString*)str
{
    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"json"];
    NSStringEncoding coding = NSUTF8StringEncoding;
    NSString *infoString = [NSString stringWithContentsOfFile:path usedEncoding:&coding error:nil];
    NSArray *result = [infoString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return result;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr =@"allFoodType";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text=_dataArray[indexPath.row][@"sportName"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *sportParamValueID=_nameStr;
    NSMutableDictionary *sendDic =[NSMutableDictionary dictionaryWithDictionary:_dataArray[0]];
    [sendDic setObject:sportParamValueID forKey:@"sportParamValueID"];
    [[NSNotificationCenter defaultCenter]postNotificationName:getKCFoodNotific object:sendDic userInfo:nil];
    [self backViewUPloadView];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:getKCFoodNotific object:nil];
}
@end
