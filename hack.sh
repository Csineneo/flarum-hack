#! /bin/bash

# 用戶端語言識別
sed -i '/private function getDefaultLocale/, $d' \
  vendor/flarum/core/src/Locale/LocaleServiceProvider.php
mv vendor/flarum/core/src/Locale/LocaleServiceProvider.php vendor/flarum/core/src/Locale/LocaleServiceProvider.php.ori
wget -qO vendor/flarum/core/src/Locale/LocaleServiceProvider.php "https://raw.githubusercontent.com/Csineneo/flarum-hack/master/LocaleServiceProvider.php"

# 簡繁自動轉換
# https://vivaldi.club/d/793/10
mv vendor/flarum/core/src/Api/JsonApiResponse.php vendor/flarum/core/src/Api/JsonApiResponse.php.ori
wget -qO vendor/flarum/core/src/Api/JsonApiResponse.php "https://raw.githubusercontent.com/Csineneo/flarum-hack/master/JsonApiResponse.php"

# 允許註冊中文名
sed -i "s#a-z0-9_-#-_a-z0-9\\\x7f-\\\xff#" \
  vendor/flarum/core/src/User/UserValidator.php

# 支援 @ 中文名
sed -i "s#a-z0-9_-#-_a-zA-Z0-9\\\x7f-\\\xff#" \
  vendor/flarum/mentions/src/Listener/FormatPostMentions.php \
  vendor/flarum/mentions/src/Listener/FormatUserMentions.php

# 取消標題及用戶名最小長度限制
sed -i 's#min:3#min:1#' \
  vendor/flarum/core/src/User/UserValidator.php \
  vendor/flarum/core/src/Discussion/DiscussionValidator.php

# 取消貼文字數限制
sed -i 's#65535#2147483647#' \
  vendor/flarum/core/src/Post/PostValidator.php

# 不限制管理員灌水
sed -i -r "s#(isFlooding = )#\1\$actor->id == '1' ? false : #" \
  vendor/flarum/core/src/Post/Floodgate.php

# 支援 vivaldi:// scheme
sed -i "/Autoemail/i\\\t\\t\$configurator->urlConfig->allowScheme('vivaldi');" \
  vendor/s9e/text-formatter/src/Configurator/Bundles/Fatdown.php
sed -i "/new SchemeList/a\\\t\\t\$this->allowedSchemes[] = 'vivaldi';" \
  vendor/s9e/text-formatter/src/Configurator.php
sed -i 's#ftp|https#ftp|vivaldi|https#g' \
  vendor/s9e/text-formatter/src/Bundles/Fatdown.php

# 透過 Vivaldi PO 文享專屬 banner
sed -i -r "s#(t.stopPropagation\(\)}}\)\))#\1,/Vivaldi/.test(t.data.attributes.userAgent)?m('img',{className:'viv-icon',src:'https://awk.tw/assets/images/viv-badge.png'}):''#" \
	vendor/flarum/core/js/dist/forum.js

# 顯示發帖人 UA
# SQL: ALTER TABLE tbl_posts ADD user_agent varchar(255);
sed -i 's#\$ipAddress)#\$ipAddress\, string \$userAgent)#; /->ipAddress/a\\t\t\t\t$this->userAgent = $userAgent;' \
	vendor/flarum/core/src/Discussion/Command/StartDiscussion.php
	sed -i -r '/new PostReply/s/(ipAddress)/\1, $userAgent/; /->ipAddress/a\\t\t\t\t$userAgent = $command->userAgent;' \
	vendor/flarum/core/src/Discussion/Command/StartDiscussionHandler.php
sed -i -e '/StartDiscussion/s/)$/, \$userAgent)/' \
	-e "/ipAddress =/a\\\t\t\t\t\$userAgent = array_get(\$request->getServerParams(), 'HTTP_USER_AGENT', '');" \
	vendor/flarum/core/src/Api/Controller/CreateDiscussionController.php
sed -i -r 's#(ipAddress = null)#\1, string $userAgent#; /->ipAddress/a\\t\t\t\t$this->userAgent = $userAgent;' \
	vendor/flarum/core/src/Post/Command/PostReply.php
sed -i -r 's#(ipAddress)$#\1,#; /ipAddress/a\\t\t\t\t\t\t$command->userAgent' \
	vendor/flarum/core/src/Post/Command/PostReplyHandler.php
sed -i -e 's#ipAddress)#ipAddress, $userAgent)#' \
	-e "/ADDR/a\\\t\t\t\t\$userAgent = array_get(\$request->getServerParams(), 'HTTP_USER_AGENT', '');" \
	vendor/flarum/core/src/Api/Controller/CreatePostController.php
sed -i -e '/ip_address/a\\t\t\t\t$post->user_agent = $userAgent;' \
	-e 's#ipAddress)#ipAddress, $userAgent)#' \
	vendor/flarum/core/src/Post/CommentPost.php
sed -i "/contentHtml/a\\\t\t\t\t\t\t\$attributes['userAgent'] = \$post->user_agent;" \
	vendor/flarum/core/src/Api/Serializer/PostSerializer.php
sed -i -r 's#(footerItems\(\).toArray\(\)\)\))#\1,m("small",{className:"ua"},e.props.post.data.attributes.userAgent\)#' \
	vendor/flarum/core/js/dist/forum.js

# URL 美化，移除 slug
sed -i -r 's#(discussion->id).*$#\1#' \
  vendor/flarum/core/views/frontend/content/index.blade.php
sed -i 's#+(i.trim()?"-"+i:"")##' \
  vendor/flarum/core/js/dist/forum.js

# 改為使用 UID 訪問用戶頁面
sed -i 's#t.route("user",{username:e.username#t.route("user",{username:e.id#' \
  vendor/flarum/core/js/dist/forum.js

# 允許搜尋長度小於三個字符的 ID
sed -i 's#length>=3\&#length>=1\&#' \
  vendor/flarum/core/js/dist/forum.js

# 在用戶卡片及用戶頁面中展示 UID
sed -i -r 's#(UserCard-info"},)#\1Object(T.a)("UID：\\t\\t"+t.id()),#' \
  vendor/flarum/core/js/dist/forum.js

# 新增 UID 至 PostStream
sed -i -r 's#(=i.contentType)#\1(),u["user-id"]=i.user().id#' \
  vendor/flarum/core/js/dist/forum.js

# 以絕對時間顯示
sed -i "s#-2592e6#-864e5#; s#D MMM#LLLL#; s#MMM 'YY#LLLL#" \
  vendor/flarum/core/js/dist/forum.js

# 使用中文數位記法
sed -i 's#t>=1e3#t>=1e4#; s#(t\/1e3)#(t/1e4)#; s#kilo_text#ten_kilo_text#' \
  vendor/flarum/core/js/dist/admin.js \
  vendor/flarum/core/js/dist/forum.js
sed -i '/kilo_text/a\      ten_kilo_text: 0K' \
	vendor/flarum/lang-english/locale/core.yml

# 為頭像增加彩色邊框
sed -i -r 's#"(}\),Object\(Ot)# uid-"+e.id(),style:"border:solid "+e.color()\1#' \
	vendor/flarum/core/js/dist/forum.js

# 首頁節點列表不顯示次節點
sed -i 's#o.splice(0,3).forEach(s),##' \
  vendor/flarum/tags/js/dist/forum.js

# 啟用 Pusher 後不隱藏刷新按鈕
sed -i 's#Object(o.extend)(p.a.prototype,"actionItems",function(e){e.remove("refresh")}),##' \
  vendor/flarum/pusher/js/dist/forum.js

#	固頂貼不顯示預覽
sed -i "/'includeFirstPost'/d" \
	vendor/flarum/sticky/src/Listener/AddApiAttributes.php
sed -i 's#Object(f.extend)(S.a.prototype,"requestParams",function(t){t.include.push("firstPost")}),##' \
	vendor/flarum/sticky/js/dist/forum.js

# 確保 antoinefr/flarum-ext-money 與 reflar/level-ranks 的計算方式保持一致
# n = 5*discussionCount + commentCount
sed -i -r 's#(money\]",)(this.props.user.data.attributes.)money#\1\2discussionCount*5+\2commentCount#' \
	vendor/antoinefr/flarum-ext-money/js/dist/forum.js
sed -i -r 's#21.*(t.discussionCount)#t.commentCount()+5*\1#' \
	vendor/reflar/level-ranks/js/dist/forum.js

# 調整 reflar/level-ranks 升級經驗算法為 log(n)
sed -i 's#r\/135),s=100\/135\*(r-135\*n)#Math.log(r)),s=Math.log(r).toFixed(4).split(".")[1]/100#' \
	vendor/reflar/level-ranks/js/dist/forum.js

# 客制 flagrow/upload 圖片模板
echo '<figure class="upl-image-tpl" data-uuid="{@uuid}">
  <img src="{@url}" alt="{SIMPLETEXT1}">
  <figcaption>
    <span class="upl-image-title"><i class="far fa-file-image"></i>{SIMPLETEXT1}</span>
    <span class="upl-image-size"><i class="fas fa-cloud-download-alt"></i>{SIMPLETEXT2}</span>
    <span class="upl-image-link"><a href="{@url}" title="{SIMPLETEXT1}" target='_blank'><i class="fas fa-external-link-alt"></i></a></span>
  </figcaption>
</figure>' > vendor/flagrow/upload/resources/templates/image.blade.php

# 簡繁語言包及 BBCode
composer require csineneo/lang-traditional-chinese
composer require csineneo/lang-simplified-chinese
composer require csineneo/vivaldi-club-bbcode
