<?php
require_once __DIR__ . '/lib/smarty-5.5.1/libs/Smarty.class.php';

$smarty = new Smarty\Smarty();
$smarty->setTemplateDir(__DIR__ . '/templates');
$smarty->setCompileDir(__DIR__ . '/templates_c');

// Decide page from query param, default nav1
$page = $_GET['nav'] ?? 'nav1';
$smarty->assign('page', $page);
$smarty->assign('pageTitle', 'My Dashboard');

$smarty->display('layout.tpl');
