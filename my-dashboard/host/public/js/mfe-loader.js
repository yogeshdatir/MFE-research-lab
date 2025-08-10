// simple loader that injects remote script and calls a global mount function
(function () {
  function loadRemoteScript(url, onload, onerror) {
    const s = document.createElement('script');
    s.src = url;
    s.async = true;
    s.onload = onload;
    s.onerror =
      onerror ||
      function () {
        console.error('Failed to load', url);
      };
    document.head.appendChild(s);
  }

  // mount if host page set config vars for nav3
  if (window.__nav3_remote_url__ && window.__nav3_mount_fn__) {
    loadRemoteScript(window.__nav3_remote_url__, function () {
      const fn = window[window.__nav3_mount_fn__];
      if (typeof fn === 'function') {
        fn('nav3-root');
      } else {
        console.error(
          'nav3 mount function not found:',
          window.__nav3_mount_fn__
        );
      }
    });
  }

  if (window.__nav4_remote_url__ && window.__nav4_mount_fn__) {
    loadRemoteScript(window.__nav4_remote_url__, function () {
      const fn = window[window.__nav4_mount_fn__];
      if (typeof fn === 'function') {
        fn('nav4-root');
      } else {
        console.error(
          'nav4 mount function not found:',
          window.__nav4_mount_fn__
        );
      }
    });
  }
})();
