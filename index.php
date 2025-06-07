<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      background-color: darkgray;
    }
  </style>
  <title>Document</title>
</head>

<body>
  <form action="index.php" method="get">
    <input type="text" name="grade" placeholder="Enter your grade">
    <input type="submit" value="Submit">
  </form>
</body>

</html>
<?php
/* Lesson 7: Switch Statements in PHP
    ### Switch Statement:
    - Used when you need to compare a single value against multiple possible values
    - More efficient than multiple if-else statements for this purpose
    - Uses 'case' and 'break' keywords
    - Can include a 'default' case for unmatched values
    - Syntax:
      switch (expression) {
        case value1:
          // code to execute if expression equals value1
          break;
        case value2:
          // code to execute if expression equals value2
          break;
        // ... more cases ...
        default:
          // code to execute if expression does not match any case
          break;
      }
*/

$grade = strtoupper($_GET['grade']);

switch ($grade) {
  case 'A':
    echo "A grade: You are a genius";
    break;
  case 'B':
    echo "B grade: You are a good student";
    break;
  case 'C':
    echo "C grade: You are a good student";
    break;
  case 'D':
    echo "D grade: You are a bad student";
    break;
  default:
    echo "{$grade} grade: You are a bad student, you need to improve your grade";
    break;
}

?>