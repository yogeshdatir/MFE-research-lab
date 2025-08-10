<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>{$pageTitle}</title>
</head>
<body>
  <header>
    <h1>{$pageTitle}</h1>
    <nav>
      <a href="?nav=nav1">Nav 1</a> |
      <a href="?nav=nav2">Nav 2</a> |
      <a href="?nav=nav3">Nav 3 (React)</a> |
      <a href="?nav=nav4">Nav 4 (React)</a>
    </nav>
    <hr>
  </header>

  <main id="content">
    {include file="{$page}.tpl"}
  </main>

  <!-- Host-side loader helper (keeps host plain PHP) -->
  <script src="public/js/mfe-loader.js"></script>
</body>
</html>
