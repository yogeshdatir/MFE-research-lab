<?php
// Include Smarty library
require_once __DIR__ . '/../my-dashboard/host/lib/smarty-5.5.1/libs/Smarty.class.php';

// Create Smarty instance
$smarty = new Smarty\Smarty();

// Configure Smarty directories
$smarty->setTemplateDir(__DIR__ . '/templates/');
$smarty->setCompileDir(__DIR__ . '/templates_c/');
$smarty->setCacheDir(__DIR__ . '/cache/');
$smarty->setConfigDir(__DIR__ . '/config/');

// Get the current page from URL parameter, default to 'home'
$page = isset($_GET['page']) ? $_GET['page'] : 'home';

// Define valid pages
$valid_pages = ['home', 'tasks', 'dashboard'];

// Check if the requested page is valid
if (!in_array($page, $valid_pages)) {
  $page = 'home';
}

// Set template variables
$smarty->assign('current_page', $page);
$smarty->assign('page_title', ucfirst($page));

// Define menu items
$menu_items = [
  'home' => ['title' => 'Home', 'url' => '?page=home'],
  'tasks' => ['title' => 'Task Manager', 'url' => '?page=tasks'],
  'dashboard' => ['title' => 'Dashboard (Shared Components)', 'url' => '?page=dashboard']
];

$smarty->assign('menu_items', $menu_items);

// Display the template
$smarty->display('layout.tpl');
