## Flarum安装前准备
----
安装环境面板
```
宝塔面板、Appnode面板，均集成compose安装。自行参考官方安装
```
添加linux用户
```
adduser sroot   //添加sroot用户
passwd sroot  //设置sroot用户密码
vi /etc/sudoers  //编辑授权文件
sroot    ALL=(ALL)        PASSWD:ALL  //找到root    ALL=(ALL)    ALL下加入
```
运行composer提示
```
错误
/usr/bin/env: php: 没有那个文件或目录
解决
ln -s /opt/appnode/appnode-php73/root/usr/bin/php /usr/local/bin/php  //root运行添加软连接

其中 /opt/appnode/appnode-php73/root/usr/bin/php请参考对应版本安装路径！
```
执行composer安装
```
su - sroot  //切换到sroot用户
cd /data/.../www  //进入站点运行目录
sh install.sh   //执行安装命令
或
./install.sh  //执行安装命令
```
下载一键安装命令
```
flarum+中文简繁语言包
wget https://raw.githubusercontent.com/book-boy/Flarum-install/master/install.sh

flarum插件包
wget https://raw.githubusercontent.com/book-boy/Flarum-install/master/Extensions.sh

flarum中文优化
wget https://raw.githubusercontent.com/book-boy/Flarum-install/master/optimization.sh
```

## 规划规划
----
### 板块武林大烩
```
名称：武林大烩
目录：Wulin_stew 
简介：说书唱戏劝人方，三条大道走中央。
```
- 子板块
```
名称：大杂烩 
目录：Hodgepodge
简介：
```
### 板块Flarum
```
名称：Flarum
目录：flarum
简介：Flarum
```
- 子板块
```
名称：FAQ
目录：fqa
简介：
```
```
名称：Update
目录：update
简介：本站程式修复更新内容细节
```
## composer 基础命令
----
依赖安装
```
composer require xxx/xxx
```
更新
```
composer update xxx/xxx
```
移除
```
composer remove xxx/xxx
```
迁移及缓存清理
```
php flarum migrate
php flarum cache:clear
```
## 修复：主题关注、回复、提及（@）发送邮件中文内容
---
- 关注邮件提醒
邮件标题
修改 vendor/flarum/subscriptions/src/Notification/NewPostBlueprint.php中71行英文内容为：
```
      return "您关注的主题《{$this->post->discussion->title}》有了新评论";
```
邮件内容
修改 vendor/flarum/subscriptions/views/emails/newPost.blade.php中英文内容为：
```
嘿 {!! $user->display_name !!}!

         {!! $blueprint->post->user->display_name !!} 在您关注的主题《{!! $blueprint->post->discussion->title !!}》中发表了新评论。
         -----------------------------------------------

           {!! strip_tags($blueprint->post->contentHtml) !!}

         {!! app()->url() !!}/d/{!! $blueprint->post->discussion_id !!}/{!! $blueprint->post->number !!}
         -----------------------------------------------
           没有新的评论前，不会再收到有关此讨论的任何通知。
                       系统邮件请勿回复！
```
- 回复邮件提醒
邮件标题
修改 vendor/flarum/mentions/src/Notification/PostMentionedBlueprint.php中77行英文内容为：
```
   return "{$this->reply->user->username} 在主题《{$this->post->discussion->title}》中回复了您";
```
邮件内容
修改 vendor/flarum/mentions/views/emails/postMentioned.blade.php中英文内容为：
```
嘿 {!! $user->username !!}!

         {!! $blueprint->reply->user->username !!} 回复了您在主题《{!! $blueprint->post->discussion->title !!}》中发表于(#{!! $blueprint->post->number !!})楼的评论。
         -----------------------------------------------

             {!! strip_tags($blueprint->reply->contentHtml) !!}

         {!! app()->url() !!}/d/{!! $blueprint->reply->discussion_id !!}/{!! $blueprint->reply->number !!}
         -----------------------------------------------
                       系统邮件请勿回复！
```
- 提及邮件提醒
邮件标题
修改 vendor/flarum/mentions/src/Notification/UserMentionedBlueprint.php中69行英文内容为：
```
     return "{$this->post->user->username} 在主题《{$this->post->discussion->title}》中提及了您";
```
邮件内容
修改 vendor/flarum/mentions/views/emails/userMentioned.blade.php中英文内容为：
```
嘿 {!! $user->username !!}!

         {!! $blueprint->post->user->username !!} 在文章《{!! $blueprint->post->discussion->title !!}》中提及了您。
         -----------------------------------------------

         {!! strip_tags($blueprint->post->contentHtml) !!}

         {!! app()->url() !!}/d/{!! $blueprint->post->discussion_id !!}/{!! $blueprint->post->number !!}
         -----------------------------------------------
                       系统邮件请勿回复！                     
```
### 问题：发送邮件支持html（插件）
---
中文插件：csineneo/lang-simplified-chinese
    修改vendor/csineneo/lang-simplified-chinese/locale/中activate_account激活帐户、 confirm_email验证邮箱、 reset_password重设密码下subject邮件主题、body邮件内容
body下加入html邮箱模板
```
activate_account:
      subject: 激活帐户
      body: |
        <b>你好，{username}！

        你在 {forum} 进行了注册，若确定是你本人注册的，请点击下面的链接激活你的帐户：

        {url}

        若非你本人注册，请忽略此邮件。</b>


    confirm_email:
      subject: 验证邮箱
      body: |
        <b>你好，{username}!

        你在 {forum} 的邮箱被更改为此邮箱，若确定是你本人进行的更改，请点击下面的链接完成邮箱验证：

        {url}

        若非你本人行为，请忽略此邮件。</b>

    reset_password:
      subject: => core.ref.reset_your_password
      body: |
        <b>你好，{username}！

        你在 {forum} 请求重设密码，若确定是你本人进行的更改，请点击下面的链接重设密码：

        {url}

        若非你本人行为，请忽略此邮件。</b>
```
修改vendor/flarum/core/src/Api/Controller/SendConfirmationEmailController.php中90行以下代码：
```
$this->mailer->raw($body, function (Message $message) use ($actor, $data) {
            $message->to($actor->email);
            $message->subject('['.$data['{forum}'].'] '.$this->translator->trans('core.email.activate_account.subject'));
        });
```
  改为
```
  $this->mailer->send(['html' => $body], [], function (Message $message) use ($actor, $data) {
            $message->to($actor->email);
            $message->subject('['.$data['{forum}'].'] '.$this->translator->trans('core.email.activate_account.subject'));
```
修改vendor/illuminate/mail/Mailer.php中213行以下代码：
```
 $data['message'] = $message = $this->createMessage();

        // Once we have retrieved the view content for the e-mail we will set the body
        // of this message using the HTML type, which will provide a simple wrapper
        // to creating view based emails that are able to receive arrays of data.
        $this->addContent($message, $view, $plain, $raw, $data);
```
为
```
 $message = $this->createMessage();
        $this->addContent($message, $view, $plain, $raw, $data);
        $data['message'] = $message;
```
298行以下代码：
```
$message->setBody($this->renderView($view, $data), 'text/html');
```
为
```
 if ($data) {
                $message->setBody($this->getView($view, $data), 'text/html');
            } else {
                $message->setBody($view, 'text/html');
            }
```
  参考：http://discuss.flarum.org.cn/d/862
### 修复：首页动态公告内容(插件)
---
插件 zerosonesfun/flarum-ext-fickle-announcement
修改assets/extensions/zerosonesfun-fickle-announcement/fickle.js中7行英文内容为
```
newEl.innerHTML = '<p class="fickle">这是一个全选的谈论站点！</p>';
```
### 修复：增加支持顶部导航栏
---
增加顶部导航
修改vendor/flarum/core/views/frontend/forum.blade.php中21行
```
               <div id="header-primary" class="Header-primary"></div>

```
为
```
                <div class="Header-primary">
                    <ul class="Header-controls">
                     <li><a href="http://flarum.org.cn" class="Button Button--link" target="_blank">首页</a></li>
                     <li><a href="http://flarum.org.cn/docs/" class="Button Button--link" target="_blank">文档</a></li>
                     <li><a href="https://github.com/justjavac/flarum/releases" class="Button Button--link" target="_blank">下载</a></li>
                    </ul>
                    <div id="header-primary"><ul class="Header-controls"></ul></div>
              </div>
```

参看：http://discuss.flarum.org.cn/d/114

### 更新记录
---
 1. 修复：主题关注、回复、提及（@）发送邮件中文内容 https://discuss.srinn.cn/d/7
 2. 修复：首页动态公告内容(插件) https://discuss.srinn.cn/d/9
 3. 修复：增加支持顶部导航栏 https://discuss.srinn.cn/d/11
 
 ---
 
- [ ] 
- [x] 

![book.boy](https://avatars0.githubusercontent.com/u/47053228?s=96&v=4){:height="50" width="50"}
> * 整理知识，学习笔记
> 请保留此份说明，如需撰写新稿件，点击顶部工具栏右侧的 <i class="icon-file"></i> **新文稿** 或者使用快捷键 `Ctrl+Alt+N`。


| 项目        | 价格   |  数量  |
| --------   | -----:  | :----:  |
| 计算机     | \$1600 |   5     |
| 手机        |   \$12   |   12   |
| 管线        |    \$1    |  234  |


#### 插件
|插件名|安装包|版本|
|-|-|-|
|Flarum|flarum/flarum-beta|v0.1.0-beta.8.1|
|中文简体|csineneo/lang-simplified-chinese||
|中文繁体|csineneo/lang-traditional-chinese||
|最佳答案|wiwatsrt/flarum-ext-best-answer||
|货币积分|antoinefr/flarum-ext-money||
|等级排名|reflar/level-ranks||
|夜间模式|reflar/nightmode||
|热度排名|reflar/gamification||
|清理帖子|reflar/clean-profile-posts||
|邀请码|reflar/doorman||
|更改图像|fof/secure-https||
|封禁用户|fof/spamblock||
|头像剪切|fof/profile-image-crop||
|自定义页面|fof/pages||
|自定义页脚|fof/custom-footer||
|默认分组|fof/default-group||
|默认通知|fof/default-user-preferences||
|回复可见|kvothe/reply-to-see||
|表格|kvothe/pipetables||
|用户条款|flagrow/terms||
|私密帖子|flagrow/byobu||
|分割帖子|flagrow/split||
|网站地图|flagrow/sitemap||
|广告位置|flagrow/ads||
|扩展市场|flagrow/bazaar||
|上传扩展|flagrow/upload||
|注册按钮|kvothe/signup-button||

