<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{$page_title} - Simple Navbar App</title>
    <link rel="stylesheet" href="public/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-logo">
                    <a href="?page=home">
                        <i class="fas fa-code"></i>
                        Simple App
                    </a>
                </div>
                <ul class="nav-menu">
                    {foreach from=$menu_items key=page_key item=menu_item}
                        <li class="nav-item">
                            <a href="{$menu_item.url}" class="nav-link {if $current_page == $page_key}active{/if}">
                                {if $page_key == 'home'}<i class="fas fa-home"></i>{/if}
                                {if $page_key == 'about'}<i class="fas fa-user"></i>{/if}
                                {if $page_key == 'services'}<i class="fas fa-cogs"></i>{/if}
                                {if $page_key == 'portfolio'}<i class="fas fa-briefcase"></i>{/if}
                                {if $page_key == 'contact'}<i class="fas fa-envelope"></i>{/if}
                                {if $page_key == 'mfe-demo'}<i class="fas fa-rocket"></i>{/if}
                                {$menu_item.title}
                            </a>
                        </li>
                    {/foreach}
                </ul>
                <div class="nav-toggle" id="mobile-menu">
                    <span class="bar"></span>
                    <span class="bar"></span>
                    <span class="bar"></span>
                </div>
            </div>
        </nav>
    </header>

    <main class="main-content">
        <div class="container">
            {include file="pages/{$current_page}.tpl"}
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Simple Navbar App. Built with PHP & Smarty.</p>
        </div>
    </footer>

    <script src="public/js/script.js"></script>
</body>
</html>
