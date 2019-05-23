查看pod版本：
pod --version
升级：
sudo gem install cocoapods// sudo gem install cocoapods --pre（升级至beta版本）

podfile升级之后到1.0.0版本之后，pod里的内容必须明确指出所用第三方库的target，否则会出现错误：
“The dependency `AFNetworking (~> 2.6.3)` is not used in any concrete target.”

解决办法：
target 'MyApp' do//替换MyApp为你的project名称
  pod 'AFNetworking', '~> 2.5'
end


使用Podfile管理Pods依赖库版本
引入依赖库时，需要显示或隐式注明引用的依赖库版本，具体写法和表示含义如下：
pod 'AFNetworking'      //不显式指定依赖库版本，表示每次都获取最新版本  
pod 'AFNetworking', '2.0'     //只使用2.0版本  
pod 'AFNetworking', '> 2.0'     //使用高于2.0的版本  
pod 'AFNetworking', '>= 2.0'     //使用大于或等于2.0的版本  
pod 'AFNetworking', '< 2.0'     //使用小于2.0的版本  
pod 'AFNetworking', '<= 2.0'     //使用小于或等于2.0的版本  
pod 'AFNetworking', '~> 0.1.2'     //使用大于等于0.1.2但小于0.2的版本  
pod 'AFNetworking', '~>0.1'     //使用大于等于0.1但小于1.0的版本  
pod 'AFNetworking', '~>0'     //高于0的版本，写这个限制和什么都不写是一个效果，都表示使用最新版本  

建议指定一个特定的版本号，这样防止依赖库更新时造成的不兼容问题。


如果你的项目中有多个project，可以使用这个写法：
def pods
    pod 'Kanna', '1.0.2'
    pod 'Navi'
    pod 'Appsee'
    pod 'Alamofire'
    pod 'DeviceGuru'
    pod '1PasswordExtension'
    pod 'KeyboardMan'
    pod 'Ruler'
    pod 'Proposer'
    pod 'FXBlurView'
    pod 'Kingfisher'
    pod 'TPKeyboardAvoiding'
end

target 'Yep' do
    pods//代表上面def pods...end 中的内容

    target 'YepTests' do
        inherit! :search_paths
    end
end

target 'YepConfig' do
    pod 'Ruler'
    pod 'Kingfisher'
end

target 'FayeClient' do
    pod 'SocketRocket'
    pod 'Base64'
end