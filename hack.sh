#! /bin/bash

composer require csineneo/lang-traditional-chinese
composer require csineneo/lang-simplified-chinese
composer require csineneo/vivaldi-club-bbcode

# 用戶端語言識別
sed -i '/private function getDefaultLocale/, $d' \
  vendor/flarum/core/src/Locale/LocaleServiceProvider.php
echo "
    private function getDefaultLocale(): string
    {
        if(isset($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
            preg_match('/^([a-z\-]+)/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $matches);
            $lang = strtolower($matches[1]);
        }
        switch ($lang) {
            case 'en':
            case 'en-us':
                return 'en';
                break;
            case 'zh':
            case 'zh-tw':
                return 'zh-hant';
                break;
            case 'zh-cn':
                return 'zh-hans';
                break;
            default:
                $repo = $this->app->make(SettingsRepositoryInterface::class);
                return $repo->get('default_locale', 'en');
        }
    }
}" >> vendor/flarum/core/src/Locale/LocaleServiceProvider.php

# 簡繁自動轉換
# https://vivaldi.club/d/793/10
mv vendor/flarum/core/src/Api/JsonApiResponse.php vendor/flarum/core/src/Api/JsonApiResponse.php.ori
wget -qO vendor/flarum/core/src/Api/JsonApiResponse.php "https://raw.githubusercontent.com/ProjectFishpond/pfp-docker-config/master/sc/hack/JsonApiResponse.php"

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
sed -i 's#t>=1e3#t>=1e4#; s#(t\/1e3)#(t/1e4)#' \
  vendor/flarum/core/js/dist/admin.js \
  vendor/flarum/core/js/dist/forum.js
sed -i -r 's#(kilo_text: )千#\1萬#' \
  vendor/csineneo/lang-traditional-chinese/locale/core.yml
sed -i -r 's#(kilo_text: )千#\1万#' \
  vendor/csineneo/lang-simplified-chinese/locale/core.yml

# 首頁節點列表不顯示次節點
sed -i 's#o.splice(0,3).forEach(s),##' \
  vendor/flarum/tags/js/dist/forum.js

# 啟用 Pusher 後不隱藏刷新按鈕
sed -i 's#Object(o.extend)(p.a.prototype,"actionItems",function(e){e.remove("refresh")}),##' \
  vendor/flarum/pusher/js/dist/forum.js
