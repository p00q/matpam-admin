(function () {
  if (window.nhn && window.nhn.husky && window.nhn.husky.EZCreator) {
    return;
  }

  var cdnSrc = 'https://cdn.jsdelivr.net/gh/naver/smarteditor2@2.10.0/workspace/static/js/service/HuskyEZCreator.js';
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.charset = 'utf-8';
  script.src = cdnSrc;
  script.onerror = function () {
    console.error('Failed to load SmartEditor HuskyEZCreator.js from CDN:', cdnSrc);
  };
  document.head.appendChild(script);
})();
