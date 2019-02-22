<!doctype html>
<!-----------------------------------------------------------------
-------------------------------------------------------------------
                       .__                                 
          _____________|__| ____   ____       ____   ____  
         /  ___/\_  __ \  |/    \ /    \    _/ ___\ /    \ 
         \___ \  |  | \/  |   |  \   |  \   \  \___|   |  \
        /____  > |__|  |__|___|  /___|  / /\ \___  >___|  /
             \/                \/     \/  \/     \/     \/  
-------------------------------------------------------------------
------------------------------------------------------------------>
<html lang="zh">
<head>
<title>{{ $title }}</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="author" content="Srinn Game Team">
<meta name="keywords" content="SRINN,散人客栈,武侠论坛,BBS,Flarum">
<meta name="apple-mobile-web-app-title" content="SRINN GAME TEAM">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="application-name" content="SRINN GAME TEAM">
<meta name="mobile-web-app-capable" content="yes">
<meta name="msapplication-TileColor" content="{{ array_get($forum, 'attributes.themePrimaryColor') }}">
<meta name="msapplication-TileImage" content="https://forum.srinn.cn/assets/icons/icon.png">
<meta property="og:site_name" content="SRINN GAME TEAM" />
<meta name="twitter:card" content="summary" />
<meta name="twitter:image" content="https://forum.srinn.cn/assets/icons/icon.png" />
<meta property="og:image" content="https://forum.srinn.cn/assets/icons/icon.png" />
<meta property="og:url" content="https://forum.srinn.cn/" />
<meta name="twitter:url" content="https://forum.srinn.cn/" />
<meta property="og:title" content="{{ $title }}" />
<meta name="twitter:title" content="{{ $title }}" />
<meta property="og:description" content="江湖游侠,四海为家。云集客栈,论剑天下。" />
<meta name="twitter:description" content="江湖游侠,四海为家。云集客栈,论剑天下。" />
<link rel="icon" type="image/png" href="https://forum.srinn.cn/assets/icons/icon.png">
<link rel="shortcut icon" type="image/x-icon" href="https://forum.srinn.cn/assets/icons/favicon.ico">
<link rel="mask-icon" href="https://forum.srinn.cn/assets/icons/icon.svg" color="%%PRIMARY_COLOR%%">
{!! $head !!}
<link rel="stylesheet" href="https://forum.srinn.cn/assets/css/flarum.ext.css">
<script type="text/javascript" src="https://forum.srinn.cn/assets/js/webpjs-0.0.2.min.js"></script>
<!--<script type="text/javascript">
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
</script>-->
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
  <p style="font-size:12px; text-align:center;">SRINN GAME TEAM <a href="https://www.srinn.cn/?bbs" target="_blank">散人客栈</a> 技术支持</p>
</footer>
{!! $foot !!}
<!--<noscript><p><img src="//m.awk.tw/m.php?idsite=1&amp;rec=1" style="border:0;" alt="" /></p></noscript>-->
</body>
</html>
