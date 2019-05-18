---
title: 数据持久化-Core Data
date: 2015-11-17
desc: iOS 开发
---

什么是 Core Data, 简单来讲，它就是一个面向对象的数据库，它把 SQL 等数据库的操作封装起来，所以你可以把它理解为面向对象领域同数据库领域之间的桥梁。

我们从下面的一个例子讲起：

### 创建一个模型
如下新建一个 Data Model, 命名为 CoreDump。

![](https://ws1.sinaimg.cn/large/006tNc79gy1fj7vovpbqgj30k50bimxb.jpg)

这个模型文件将会被编译成后缀名为 .momd 类型的文件，它会被放在和你稍后创建的数据库的同一个目录下。我们将会在运行时加载这个文件来为持久化存储创建需要用的 NSManagedObjectModel，模型的源码是简单的 XML。

一旦你创建了模型，你就可以增加实体，实体将会映射成为我们需要的对象，在数据库中，它被称之为表。点击 Model.xcdatamodeld 左下方的 Add Entity, 分别为这个 Model 新建以下两个实体。

![](https://ws2.sinaimg.cn/large/006tNc79gy1fj7vov8k2uj30jf084jrf.jpg)

如上，我们新建了两个名为 Bug 和 Prohect 的实体，点击 Attributes 下方的加号按钮为分别为其增加如上图所示的属性，它将会映射成为我们需要的对象的属性，而在数据库中，它就像是数据库中的列。

我们还可以为这两个实体增加下面的依赖关系，如下图所示，我们希望一个项目可以有多个 bug，每个 bug 都属于每个独立的项目，所以点击 Relationships 下方的加号按钮并为其建立如下图的依赖关系。设置它们为彼此相反的关系。


![](https://ws3.sinaimg.cn/large/006tNc79gy1fj7voupfdgj30pq06d0sq.jpg)

![](https://ws1.sinaimg.cn/large/006tNc79gy1fj7vou2t3jj30qd05ojrd.jpg)

关系也是一种属性，只不过它是一种指向数据库中的其它对象的指针。

注意，我们希望一个项目可以有多个 bug，所以我们可以点击具体的 Relationships 并修改其属性中的 Type 为 To Many，这样就建立了一对多的依赖关系。

点击 Editor style 的右边按钮，可以以图形化的方式查看实体的属性以及实体间的依赖关系，如下：

![](https://ws4.sinaimg.cn/large/006tNc79gy1fj7vot9lr5j30cj06pwec.jpg)


注意到上面那些箭头没，双箭头表示一对多的关系。实际上你也可以通过拖拽的方式为两个实体间建立关系。


### 配置 managed object context

![](https://ws4.sinaimg.cn/large/006tNc79gy1fj7vosyfahj30uk0ga74j.jpg)

如上图看到的，模型层的对象-NSManaged Object 存在于一个 context 内。对象和它们的 context 是相关联的。每个*被管理*的对象都知道自己属于哪个 context，并且每个 context 都知道自己管理着哪些对象。
我们把左边部分称之为堆栈，另一部分就是持久了，即 Core Data 从文件系统中读或写数据。每个持久化存储协调器（persistent store coordinator）都有一个属于自己的*持久化存储（persistent store）*，并且这个 store 在文件系统中与 SQLite 数据库交互。为了支持更高级的设置，Core Data 可以将多个 stores 附属于同一个持久化存储协调器，并且除了存储 SQL 格式外，还有很多存储类型可供选择。

在大多数的设置中，存在一个 context ，并且所有的对象存在于那个 context 中。不过 Core Data 也支持多个 contexts，这对于更高级的使用情况才会用到。

#### 初始化
managed object context 很重要，我们需要通过它在数据库中完成创建对象，删除对象，查询对象，修改对象属性等操作，我们创建一个独立的类来完成这个操作：
1. 将上一步所定义好的数据模型文件合并成为一个 NSManagedObjectModel。
2. 用数据模型来创建 NSPersistentStoreCoordinator，此时就具备了创建表的能力。
3. 为存储调度添加持久化的数据存储（SQLite 数据库）。
4. 增加一个 undo manager

ContextSetup.m
```
- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL{
    self = [super init];
    if (self) {
        _storeURL = storeURL;
        _modelURL = modelURL;
        [self setupManagedObjectContext];
    }
    return self;
}

//设置 Core Data 堆栈(相当于建立数据库)：为其提供一个 Core Data 模型和一个文件名，会返回一个 managed object context。该堆栈拥有持久化存储协调器的 managed object context。
- (void)setupManagedObjectContext {
    //初始化：在比较老的代码中，你可能见到 [[NSManagedObjectContext alloc] init]。现在你应该用 initWithConcurrencyType: 初始化，以明确你是使用基于队列的并发模型。
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //设置持久化存储协调器
    _managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError* error;
    [_managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                   configuration:nil
                                                                             URL:self.storeURL
                                                                         options:nil
                                                                           error:&error];
    //当Core Data数据模型改变时，就会暂停操作。你可以通过设置选项来告诉Core Data在遇到这种情况后怎么做.例如删掉原有的数据库重新建立等。
    if (error) {
        NSLog(@"error: %@", error);
    }
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (NSManagedObjectModel*)managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    return _managedObjectModel;
}
```

#### UIManagedDocument

事实上，如果你新建过程时（看第一张图），你勾选了 Use Core Data 的选项后并且选择了 Master-Detail Application 时，XCode 会自动为你生成类似上面的那些代码，上面的代码只不过进行了一层封装。Stanford CS193p 教程上，老头子推荐使用 UIManagedDocument 来完成上面那些操作。

```
#pragma mark -- UIManagedDocument

- (void)setupManagedObjectContextUsingManagedDocument{
self.document = [[UIManagedDocument alloc]initWithFileURL:self.storeURL];
// 判断是否存在于磁盘中
if ([[NSFileManager defaultManager] fileExistsAtPath:[self.storeURL path]]) {
	[_document openWithCompletionHandler:^(BOOL success) {// 如果存在，打开 document
		// 因为是异步操作，所以可能会收到干扰打开失败所以需要相应的处理
		if (success) [self documentIsReady];
		if (!success) NSLog(@"couldn’t open document at %@", self.storeURL);
		}];
} else {
	[_document saveToURL:self.storeURL forSaveOperation:UIDocumentSaveForCreating
	completionHandler:^(BOOL success) {
		if (success) [self documentIsReady];
		if (!success) NSLog(@"couldn’t create document at %@", self.storeURL);
		}];
	}
}

- (void)documentIsReady{
	if (self.document.documentState == UIDocumentStateNormal) {
		_managedObjectContext = self.document.managedObjectContext;
	}
/*
其它状态：
UIDocumentStateClosed， UIDocumentStateSavingError，UIDocumentStateEditingDisabled，UIDocumentStateInConflict 
*/    
}
```

对于 UIManagedDocument，它有如下特点 :
1. 自动保存；
2. 自动关闭，(当没有强指针指向它时)，不过也可以手动异步地关闭它。

```
[self.document closeWithCompletionHandler:^(BOOL success) {
	if (!success) NSLog(@“failed to close document %@”, self.document.localizedName); 
}];
```

如果在同一个 document 下有多个 UIManagedDocument 如何处理？一个 url 可以生成多个 UIManagedDocument，这样的话它们会各自管理自身的 context。不过如果你想生成多个 UIManagedDocument 的话，你要确保只有一个可写，其它只读，这样才不会在多个 UIManagedDocument 中产生冲突。
如果你在其中一个 UIManagedDocument 做修改，其它 UIManagedDocument 并不能看到，因为它们有各自的 context，不过你确实仍然是在修改同一份文档。那如何知道另一份文档是否修改了呢，恩，你可以使用 NSNotification:

```
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[center addObserver:self
	selector:@selector(contextChanged:)
	name:NSManagedObjectContextDidSaveNotification
	object:document.managedObjectContext];
}
- (void)viewWillDisappear:(BOOL)animated{
	[center removeObserver:self
	name:NSManagedObjectContextDidSaveNotification
	object:document.managedObjectContext];
	[super viewWillDisappear:animated];
}

```
notification.userInfo 对象包含了 NSInsertedObjectsKey ，NSUpdatedObjectsKey，NSDeletedObjectsKey 可以返回相应的插入、更新、删除数组。

合并修改：
如果你得到另外一个 NSManagedObjectContext 修改了数据库的通知，你可以重新抓取数据或者合并数据：

```
- (void)mergeChangesFromContextDidSaveNotification:(NSNotification *)notification;
```
我个人理解 UIManagedDocument 较适合用在有多个 context 的场景。


#### 生成 NSManagedObject subclass

我们通过上面创建的实体来生成对应的 NSManagedObject 子类。你可以新建一个 NSManagedObject subclass 来生成，也可以从菜单中选择 Editor> NSManagedObject subclass...，创建一个绑定到实体的 NSManagedObject 的子类，这将会创建 4 个文件：Bug.h/Bug.m 和 Project.h/Project.m.

注意，一旦你更新了 Model.xcdatamodeld 中的实体，你需要重新生成对应的 NSManagedObject 子类来更新它。

事实上你也可以不生成这 4 个文件，我们也可以通过 KVC 的方式来访问我们在 Model 中创建的实体，例如：

```
NSManagedObjectContext *context = self.managedObjectContext;
NSManagedObject *project = [NSEntityDescription insertNewObjectForEntityForName:@“Project”
inManagedObjectContext:context];
[project setValue:@"CoreDataDemo" forKey:@"name"];
```

只不过生成上述文件使得我们可以通过访问属性的方法来访问对象。如下：

```
NSManagedObjectContext *context = self.managedObjectContext;
NSManagedObject *project = [NSEntityDescription insertNewObjectForEntityForName:@“Project”
inManagedObjectContext:context];
[project.name = @"CoreDataDemo"];
```

现在你明白我们生成这些文件的作用了吧。一般来讲我们都会选择生成这些文件，通过访问属性的方式可以在未编译时检测对象类型，在复杂的增删查改操作中会显得更加友好。

### 增删查改
#### 创建
上面你已经看到了，我们一般通过下面的方式来创建对象

```
NSManagedObjectContext *context = self.managedObjectContext;
NSManagedObject *project = [NSEntityDescription insertNewObjectForEntityForName:@“Project”
inManagedObjectContext:context];
[project.name = @"CoreDataDemo"];
```

#### 保存更改

在保存之后，所有修改操作才会生效。保存过程一般是这样的：
1). 首先是 managed object context 计算出改变的内容。这是 context 的职责，追踪出任何你在 context 管理对象中做出的改变。

2).Managed object context 将这些改变传给持久化存储协调器，让它将这些改变传给 store。持久化存储协调器会协调  SQL 数据库来将我们插入的对象写入到磁盘上的 SQL 数据库。NSPersistentStore 类管理着和 SQLite 的实际交互，并且产生需要被执行的 SQL 代码。持久化存储协调器的角色就是简化调整 store 和 context 之间的交互过程。

我们一般会手动保存并进行错误处理。

```
if (managedObjectContext != nil) {
NSError *error = nil;
if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
	NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	abort();
	}
}
```

#### 删除

```
[aDocument.managedObjectContext deleteObject:project];
```

如果你删除了 book，那么与它有依赖关系的 project 默认会被设置为 nil，不过这取决于你的删除策略，如下图中的 Delete Rule：

![](https://ws2.sinaimg.cn/large/006tNc79gy1fj7vorxl3rj30b60483yd.jpg)

注意：如果 project 有一个强指针引用，那么在执行上述的删除之后，最好把它设置为 nil。

在你执行了 deleteObject 的操作后以及最后数据被删除前，以下方法被调用：

```
- (void)prepareForDeletion{
//
}
```

我们可以在这个方法中执行一些操作，例如通知计算 project 的数量的方法去更新计数等。

#### 获取对象

我们通过生成一个 NSFetchRequest 来执行我们的查询操作：

```
//1. 抓取的实体名称 (required)
NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@“Book”];
//2. 每次抓取的数量和总抓取限制
request.fetchBatchSize = 20;
request.fetchLimit = 100;
//3. 抓取得到的数组的排序方式
request.sortDescriptors = @[sortDescriptor];
//4. 谓词，指定抓取时的匹配规则
request.predicate = ...;

// 执行操作
NSError *error; 
NSArray *persons = [context executeFetchRequest:request error:&error]; 
```

1） sortDescriptors, 排序方式

```
//localizedStandardCompare: 它排序的方式和 Finder 一样
NSSortDescriptor *sortDescriptor =
[NSSortDescriptor sortDescriptorWithKey:@“project”
ascending:YES
selector:@selector(localizedStandardCompare:)];
```

2） predicate, 谓词

```
// 找出包含 z 字母的项目名字：
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@", z];

// 找出等于 z 的项目 bug 名字：
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"book.name = %@",  z];

// 找出购买日期在昨天之后的书籍：
NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-24*60*60]; !
request.predicate = [NSPredicate predicateWithFormat:@“any 
books.buyDate > %@”, yesterday];
```

甚至可以使用 KVC 进行更高级的查询 , 例如：

```
@“bugs.@count > 5”
```

可以合并两个查询条件：

```
@“(name = %@) OR (url = %@)”!
// 或者使用 NSCompoundPredicate
NSArray *array = @[predicate1, predicate2];
NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:array];
```

3）还可以使用 NSExpression(正则表达式) 来查询：setPropertiesToFetch

```
NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@“...”]; !
[request setResultType:NSDictionaryResultType];
[request setPropertiesToFetch:@[@“name”, expression, etc.]];
```

### Thread Safety
你可能会想到在多线程技术中使用 Core Data，不过很遗憾它不是 Thread safe 的，所以你并不能在多线程中使用它，不过你可以线程安全地访问它。

不过，你可以使用以下方法 , 它会自动为你选择合适的安全队列去执行数据库操作：

```
[context performBlock:^{

}]; 
```

### 程序入口
上文我们讲过了在 ContextSetup 中配置我们的 context，我们一般会在程序的入口处：AppDelegate 生成我们需要的 NSManagedObjectContext，并把它传递给 rootViewController。在 AppDelegate 中生成 NSManagedObjectContext 主要是因为我们可以在这里处理程序进入后台或突入中断时的手动保存，如下：

```
// 保存
- (void)applicationDidEnterBackground:(UIApplication *)application{
	[self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[self saveContext];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
	NSManagedObjectContext *managedObjectContext = self.databaseContext;
	if (managedObjectContext != nil) {
		NSError *error = nil;
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}
```

生成 NSManagedObjectContext, 并把它传递给 rootViewController:
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    self.contextSetup = [[ContextSetup alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.databaseContext = self.contextSetup.managedObjectContext;
    controller.managedObjectContext = self.databaseContext;
    application.applicationSupportsShakeToEdit = YES;
    return YES;
}
```

### Fetched Results Controller

下一步是创建一个 root view controller：一个从 NSFetchedResultsController 读取数据的 table view。Fetched results controller 可以管理你的读取请求，如果你为它分配一个 delegate，那么在 managed object context 中发生的任何改变都会通知你。实际上，这意味着如果你实现了 delegate 方法，当数据模型中发生相关变化时，你可以自动更新你的 table view。比如，你在后台线程同步，并且把变化存储到数据库中，那么你的 table view 将会自动更新。


从很大程度上来看，NSFetchedResultsController 是为了响应 Model 层的变化而设计的。
在使用 NSFetchedResultsController 之前，我们需要为其设置一个 NSFetchRequest，且这个 fetchRequest 必须得有一个 sortDescriptor，而过滤条件 predicate 则是可选的。
接着，还需要一个操作环境，即 NSManagedObjectContext, 它会从 AppDelegate 传递给我们的 root view controller。
通过设置 keyPath，就是将要读取的 entity 的（间接）属性，来作为 section 分类 key。
之后，我们为其设置可选的 cache 名称，以避免执行一些重复操作。
最后，可以设置 delegate，用来接收响应变化的通知。


```
#pragma mark - Fetched results controller delegate
// 当我们设置 fetch results controller 时，我们需要设置自己为 delegate，并且执行初始化的 fetch 操作
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[ nameSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
   
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
} 
```

设置 fetch results controller 后，我们需要实现 fetch results controller 的代理方法来监听 Model 层的改变，例如插入新的对象，删除对象会使我们的代理方法被执行，我们可以通知 TableView 进行相关的操作。
```
//监听改变:确保 table view 会为新创建的 project 插入一行,使用 fetched results controller 的代理方法：
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

//section变化的delegate
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

//row变化的delegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}
```

### UISearchController
我们加上一个 UISearchController 来之处查询操作：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    [self setupSearchController];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.delegate = self;
    self.definesPresentationContext = YES;
}

- (void)setupSearchController{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
}
```

实现 SearchController 代理方法 UISearchResultsUpdating, 每当我们在搜索框输入就会触发代理方法更新 tableView。

```
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
NSString *searchText = self.searchController.searchBar.text;
self.searchPredicate = searchText.length == 0 ? nil : [NSPredicate predicateWithFormat:@"name contains[c] %@ or url contains[c] %@", searchText, searchText];

[self.tableView reloadData];
}
```

### UITableView 代理方法
现在我们可以将 self.fetchedResultsController 作为 UITableView 的数据源，以下实现数据源的代理方法：

```
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.searchPredicate == nil ? [[self.fetchedResultsController sections] count] : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchPredicate == nil) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
    } else {
    return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchPredicate == nil) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
    } else {
    return [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:self.searchPredicate] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Project *project = nil;
    if (self.searchPredicate == nil) {
        project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    } else {
        project = [self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:self.searchPredicate][indexPath.row];
    }
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.url;
}

```

### 创建对象

我们新建一个 ProjectViewController 来创建 project 对象，通过下面这个方法来传递 rootViewController 上的 fetchedResultsController：

```
- (id)initWithProject:(Project *)project fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    self = [super init];
    if (self) {
    self.project = project;
    self.fetchedResultsController = fetchedResultsController;
    }
    return self;
}
```
rootViewController 上上点击加号按钮进入新的控制器并传值：
```
- (IBAction)insertNewObject:(UIBarButtonItem *)sender {
	ProjectViewController *projectViewController = [[ProjectViewController alloc] initWithProject:nil fetchedResultsController:self.fetchedResultsController];
	[self presentViewController:projectViewController animated:YES completion:nil];
}
```

然后我们可以继续输入操作并保存：

```
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.project != nil) {
    self.name.text = self.project.name;
    self.url.text = self.project.url;
    }
}
- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];

    if (self.project == nil) {
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
      
    self.project = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }

    self.project.name = self.name.text;
    self.project.url = self.url.text;

    // 保存操作
    NSError *error = nil;
    if (![context save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

```

### 编辑对象
为了编辑我们已创建的对象，我们只需要进入新的控制器改变对象属性即可：

```
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (tableView.editing) {
		Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
		ProjectViewController *projectViewController = [[ProjectViewController alloc] initWithProject:project fetchedResultsController:self.fetchedResultsController];
		[self presentViewController:projectViewController animated:YES completion:nil];
	}
}
```

### 增加删除操作
为了支持删除，首先，我们需要确信我们的 table view 支持删除。第二，我们需要从 core data 中删除对象，并且保证我们的排序是正确的。

为了支持滑动删除，我们需要在 data source 中实现两个方法：

```
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.searchPredicate == nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}
```
这样，当执行删除操作时，fetch results controller 的代理方法会被调用，更新 tableView：

```
case NSFetchedResultsChangeDelete:
[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
break;
```

### 增加 Undo 支持

Core Data 优点之一就是集成了 undo 支持。我们将为增加晃动撤销功能，第一步就是在 AppDelegate 中告诉程序我们可以这么做：

```
application.applicationSupportsShakeToEdit = YES;
```

现在只要抖动就会触发 Undo，程序将会向 first responder 请求 undo manager，并且执行一次 undo 操作。在我们的 view controller 中，我们重写来自 UIResponder 类中的两个方法

```
- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (NSUndoManager*)undoManager{
	return self.managedObjectContext.undoManager;
}

@end
```

现在，当一个抖动发生时，managed object context 的 undo manager 将会得到一个 undo 消息，并且撤销最后一次改变。


### 传递 Model 对象

我们将在新建一个 DetailViewController 中展示上面我们创建的 Model 对象 :

```
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		Project *project = nil;
		if (self.searchPredicate == nil) {
			project = [self.fetchedResultsController objectAtIndexPath:indexPath];
		} else {
			project = [self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:self.searchPredicate][indexPath.row];
		}
		[[segue destinationViewController] setProject:project];
	}
}
```
在上一篇文章中我们讲到，Project 对象和 Bug 对象之间是一对多的关系，所以在我们的 DetailViewController.m 中我们可以新建 Bug 对象 :

```
- (IBAction)insertNewObject:(UIBarButtonItem *)sender {
	BugViewController *bugViewController = [[BugViewController alloc] initWithBug:nil project:self.project];
	[self presentViewController:bugViewController animated:YES completion:nil];
}
```
bugViewController 中的操作和 projectViewController 类似。


