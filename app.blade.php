<!doctype html>
<html lang="zh">
<head>
<title>{{ $title }}</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="author" content="Csineneo" />
<meta name="keywords" content="Vivaldi, Opera, vivaldi browser, vivaldi snapshot, 瀏覽器, 中文, 下载, 維瓦爾第, 韋瓦第, Flarum">
<meta name="apple-mobile-web-app-title" content="Vivaldi Club">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="application-name" content="Vivaldi Club">
<meta name="mobile-web-app-capable" content="yes">
<meta name="msapplication-TileColor" content="{{ array_get($forum, 'attributes.themePrimaryColor') }}">
<meta name="msapplication-TileImage" content="https://awk.tw/assets/icons/icon.png">
<meta property="og:site_name" content="Vivaldi Club" />
<meta name="twitter:card" content="summary" />
<meta name="twitter:image" content="https://awk.tw/assets/icons/icon.png" />
<meta property="og:image" content="https://awk.tw/assets/icons/icon.png" />
<meta property="og:url" content="https://vivaldi.club/" />
<meta name="twitter:url" content="https://vivaldi.club/" />
<meta property="og:title" content="{{ $title }}" />
<meta name="twitter:title" content="{{ $title }}" />
<meta property="og:description" content="非官方 Vivaldi 瀏覽器中文討論區，我們永遠熱愛並追隨老譚的腳步" />
<meta name="twitter:description" content="非官方 Vivaldi 瀏覽器中文討論區，我們永遠熱愛並追隨老譚的腳步" />
<link rel="icon" type="image/png" href="https://awk.tw/assets/icons/icon.png">
<link rel="shortcut icon" type="image/x-icon" href="https://awk.tw/assets/icons/favicon.ico">
<link rel="mask-icon" href="https://awk.tw/assets/icons/icon.svg" color="%%PRIMARY_COLOR%%">
<link rel="alternate" type="application/rss+xml" title="Vivaldi Snapshot" href="https://awk.tw/rss/snapshot.rss" />
{!! $head !!}
<link rel="stylesheet" href="https://awk.tw/assets/css/flarum.ext.css">
<script type="text/javascript" src="https://awk.tw/assets/js/webpjs-0.0.2.min.js"></script>
<script type="text/javascript">
  var _paq = _paq || [];
  /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
  var u="//m.awk.tw/";
  _paq.push(['setTrackerUrl', u+'m.php']);
  _paq.push(['setSiteId', '1']);
  var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
  g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'m.js'; s.parentNode.insertBefore(g,s);
  })();
</script>
</head>

<body>
{!! $layout !!}

<div id="modal"></div>
<div id="alerts"></div>

<script>
  document.getElementById('flarum-loading').style.display = 'block';
  var flarum = {extensions: {}};
</script>

{!! $js !!}

<script>
  document.getElementById('flarum-loading').style.display = 'none';

  try {
    flarum.core.app.load(@json($payload));
    flarum.core.app.bootExtensions(flarum.extensions);
    flarum.core.app.boot();
  } catch (e) {
    var error = document.getElementById('flarum-loading-error');
    error.innerHTML += document.getElementById('flarum-content').textContent;
    error.style.display = 'block';
    throw e;
  }
</script>
<footer id="footer">
  <p>非官方 Vivaldi 瀏覽器中文討論區，我們永遠熱愛並追隨<a href="https://twitter.com/jonsvt" target="_blank">老譚</a>的腳步</p>
  <p><a href="https://t.me/Csineneo" target="_blank">@Csineneo</a></p>
</footer>
{!! $foot !!}
<noscript><p><img src="//m.awk.tw/m.php?idsite=1&amp;rec=1" style="border:0;" alt="" /></p></noscript>
</body>
</html>
