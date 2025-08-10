<section>
  <h2>Nav 3 (React MFE)</h2>
  <div id="nav3-root"></div>

  <!-- Load the remote script and call its global mount function -->
  <script>
    // path to remote dev server file (dev) or CDN/prod URL later
    window.__nav3_remote_url__ = 'http://localhost:3001/remoteEntry.js';
    window.__nav3_mount_fn__ = 'renderNav3';
  </script>
</section>
