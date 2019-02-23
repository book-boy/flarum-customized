GITHUB_ROOT="https://raw.githubusercontent.com/book-boy/flarum-customized/master/"
cd ../ && chmod -R 777 flarum && cd flarum
echo "开始优化支持代码"
echo "允许注册中文名"
sed -i "s#a-z0-9_-#-_a-z0-9\\\x7f-\\\xff#" \
  vendor/flarum/core/src/User/UserValidator.php
echo "支持@中文名"
sed -i "s#a-z0-9_-#-_a-zA-Z0-9\\\x7f-\\\xff#" \
  vendor/flarum/mentions/src/Listener/FormatPostMentions.php \
  vendor/flarum/mentions/src/Listener/FormatUserMentions.php
echo "取消标题及用户名最小长度限制"
sed -i 's#min:3#min:1#' \
  vendor/flarum/core/src/User/UserValidator.php \
  vendor/flarum/core/src/Discussion/DiscussionValidator.php
echo "取消帖文字数限制"
sed -i 's#65535#2147483647#' \
  vendor/flarum/core/src/Post/PostValidator.php
echo "不限制管理员灌水"
sed -i -r "s#(isFlooding = )#\1\$actor->id == '1' ? false : #" \
  vendor/flarum/core/src/Post/Floodgate.php
echo "支持vivaldi://scheme"
sed -i "/Autoemail/i\\\t\\t\$configurator->urlConfig->allowScheme('vivaldi');" \
  vendor/s9e/text-formatter/src/Configurator/Bundles/Fatdown.php
sed -i "/new SchemeList/a\\\t\\t\$this->allowedSchemes[] = 'vivaldi';" \
  vendor/s9e/text-formatter/src/Configurator.php
sed -i 's#ftp|https#ftp|vivaldi|https#g' \
  vendor/s9e/text-formatter/src/Bundles/Fatdown.php
echo "透过VivaldiPO文享专属banner"
sed -i -r "s#(t.stopPropagation\(\)}}\)\))#\1,/Vivaldi/.test(t.data.attributes.userAgent)?m('img',{className:'viv-icon',src:'assets/images/viv-badge.png'}):''#" \
	vendor/flarum/core/js/dist/forum.js
echo "URL美化，移除slug"
sed -i -r 's#(discussion->id).*$#\1#' \
  vendor/flarum/core/views/frontend/content/index.blade.php
sed -i 's#+(i.trim()?"-"+i:"")##' \
  vendor/flarum/core/js/dist/forum.js
echo "使用UID访问页面"
sed -i 's#t.route("user",{username:e.username#t.route("user",{username:e.id#' \
  vendor/flarum/core/js/dist/forum.js
echo "允许长度小于字符的ID"
sed -i 's#length>=2\&#length>=1\&#' \
  vendor/flarum/core/js/dist/forum.js
echo "在用户卡片及页面中展示UID"
sed -i -r 's#(UserCard-info"},)#\1Object(T.a)("UID：\\t\\t"+t.id()),#' \
  vendor/flarum/core/js/dist/forum.js
echo "以绝对时间显示"
sed -i "s#-2592e6#-864e5#; s#D MMM#LLLL#; s#MMM 'YY#LLLL#" \
  vendor/flarum/core/js/dist/forum.js \
	vendor/flarum/core/js/dist/admin.js
sed -i 's#D MMM#L#g' \
	vendor/flarum/statistics/js/dist/admin.js
echo "使用中文数位记法"
sed -i 's#t>=1e3#t>=1e4#; s#(t\/1e3)#(t/1e4)#; s#kilo_text#ten_kilo_text#' \
  vendor/flarum/core/js/dist/admin.js \
  vendor/flarum/core/js/dist/forum.js
sed -i '/kilo_text/a\      ten_kilo_text: 0K' \
	vendor/flarum/lang-english/locale/core.yml
echo "為頭像增加彩色邊框"
sed -i -r 's#"(}\),Object\(Ot)# uid-"+e.id(),style:"border:solid "+e.color()\1#' \
	vendor/flarum/core/js/dist/forum.js
echo "首頁節點列表不顯示次節點"
sed -i 's#o.splice(0,3).forEach(s),##' \
  vendor/flarum/tags/js/dist/forum.js
echo "啟用 Pusher 後不隱藏刷新按鈕"
sed -i 's#Object(o.extend)(p.a.prototype,"actionItems",function(e){e.remove("refresh")}),##' \
  vendor/flarum/pusher/js/dist/forum.js
echo "固頂貼不顯示預覽"
sed -i "/'includeFirstPost'/d" \
	vendor/flarum/sticky/src/Listener/AddApiAttributes.php
sed -i 's#Object(f.extend)(S.a.prototype,"requestParams",function(t){t.include.push("firstPost")}),##' \
	vendor/flarum/sticky/js/dist/forum.js
echo "确保货币与等级的计算方式保持一致"
sed -i -r 's#(money\]",)(this.props.user.data.attributes.)money#\1\2discussionCount*5+\2commentCount#' \
	vendor/antoinefr/flarum-ext-money/js/dist/forum.js
sed -i -r 's#21.*(t.discussionCount)#t.commentCount()+5*\1#' \
	vendor/reflar/level-ranks/js/dist/forum.js
echo "更改等级升級经验算法为log(n)"
sed -i 's#r\/135),s=100\/135\*(r-135\*n)#Math.log(r)),s=Math.log(r).toFixed(4).split(".")[1]/100#' \
	vendor/reflar/level-ranks/js/dist/forum.js
echo "使得tooltip在滑鼠右侧弹出避免遮挡"
sed -i -r 's#(placement:")top#\1right#' \
	vendor/flarum/core/js/dist/forum.js
echo "更改网站地图，移除slug，使用UID访问用户页面"
sed -i "s# . '-' . \$discussion->slug##; s#username#id#" \
	vendor/flagrow/sitemap/src/SitemapGenerator.php
echo "更改上传文件大小为二进制前綴"
sed -i 's#kB#KiB#; s#MB#MiB#; s#GB#GiB#; s#TB#TiB#; s#PB#PiB#; s#EB#EiB#; s#ZB#ZiB#; s#YB#YiB#' \
	vendor/flagrow/upload/src/File.php
echo "为异常提示增加MimeType"
sed -i -r "s#(this type)#\1 ('.\$upload->getClientMimeType().')#" \
	vendor/flagrow/upload/src/Commands/UploadHandler.php
echo "阻止分割帖子生成slug"
sed -i 's#-{\$slug}##' \
	vendor/flagrow/split/src/Posts/DiscussionSplitPost.php
sed -i 's#-{\$event->discussion->slug}##' \
	vendor/flagrow/split/src/Listeners/UpdateSplitTitleAfterDiscussionWasRenamed.php  
echo "阻止fof/secure-https代理HTTPS內容，并清理原始码"
sed -i -e '/proxyUrl.urlencode/d; /proxyUrl/a\\t\t\t\treturn substr(\$attrValue, 0, 5 ) === "http:" ? \$proxyUrl . urlencode(\$attrValue) : \$attrValue;' \
	vendor/fof/secure-https/src/Listeners/ModifyContentHtml.php
sed -i "/Nginx/, /http/d; s#\$imgurl, -3#strrchr(\$imgurl, '.'), 1#" \
	vendor/fof/secure-https/src/Api/Controllers/GetImageUrlController.php
echo "定义表情"	
sed -i "s#title: \"Diversity\"#title: \"种族\"#; \
    s#title: \"Recent\"#title: \"最近\"#; \
    s#title: \"Smileys & People\"#title: \"笑脸与人\"#; \
    s#title: \"Animals & Nature\"#title: \"动物与自然\"#; \
    s#title: \"Food & Drink\"#title: \"食物与饮品\"#; \
    s#title: \"Activity\"#title: \"活动\"#; \
    s#title: \"Travel & Places\"#title: \"旅游与景点\"#; \
    s#title: \"Objects\"#title: \"物体\"#; \
    s#title: \"Symbols\"#title: \"符号\"#; \
    s#title: \"Flags\"#title: \"国旗\"#" \
    vendor/clarkwinkelmann/flarum-ext-emojionearea/js/forum/dist/extension.js
echo "定制上传內容展示模板"
for f in \
	flagrow/upload/resources/templates/text.blade.php \
	flagrow/upload/resources/templates/image.blade.php \
	flagrow/upload/resources/templates/audio.blade.php \
	flagrow/upload/resources/templates/video.blade.php \
	flagrow/upload/src/Templates/AudioTemplate.php \
	flagrow/upload/src/Templates/VideoTemplate.php \
	flagrow/upload/src/Templates/ImageTemplate.php \
	flagrow/upload/src/Templates/TextTemplate.php \
	flagrow/upload/src/Providers/DownloadProvider.php
do
	wget -qO "vendor/$f" "$GITHUB_ROOT/$f"
done
echo "端语言识别"
sed -i '/private function getDefaultLocale/, $d' \
  vendor/flarum/core/src/Locale/LocaleServiceProvider.php
wget -qO "vendor/flarum/core/src/Locale/LocaleServiceProvider.php" \
	"$GITHUB_ROOT/flarum/core/src/Locale/LocaleServiceProvider.php"
echo "定制页面模板"
wget -qO "vendor/flarum/core/views/frontend/app.blade.php" \
	"$GITHUB_ROOT/flarum/core/views/frontend/app.blade.php"
echo "定制页面模板css"
wget -qO "assets/css/flarum.ext.css" \
	"$GITHUB_ROOT/flarum.ext.css"
echo "定制页面模板js"
wget -qO "assets/js/webpjs-0.0.2.min.js" \
	"$GITHUB_ROOT/webpjs-0.0.2.min.js"
echo "优化完成"