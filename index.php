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
    <input type="text" name="number" placeholder="Enter a number">
    <input type="submit" value="Submit">
  </form>
</body>

</html>
<?php
/* Lesson 7: Loops in PHP
    ### for loop:
      - Used when you know the number of iterations in advance
      - Syntax:
        for (initialization; condition; increment/decrement) {
          // code to execute
        }
      - Example:
        for ($i = 0; $i < 10; $i++) {
          echo $i;
        }
    ### while loop:
      - Used when you don't know the number of iterations in advance
      - Syntax:
        while (condition) {
          // code to execute
        }
      - Example:
        $i = 0;
        while ($i < 10) {
          echo $i;
          $i++;
        }
    ### do-while loop:
      - Similar to while loop but guaranteed to execute at least once
      - Syntax:
        do {
          // code to execute
        } while (condition);
      - Example:
        $i = 0;
        do {
          echo $i;
          $i++;
        } while ($i < 10);
    ### break:
      - Used to exit a loop or switch statement
      - Syntax:
        break;
      - Example:
        for ($i = 0; $i < 10; $i++) {
          if ($i == 5) {
            break;
          }
          echo $i;
        }
    ### continue:
      - Used to skip the current iteration of a loop
      - Syntax:
        continue;
      - Example:
        for ($i = 0; $i < 10; $i++) {
          if ($i == 5) {
            continue;
          }
          echo $i;
        }
*/

$number = $_GET['number'];

// for loop
echo "<h1>For loop: </h1>";
for ($i = 0; $i < $number; $i++) {
  echo "{$i}<br>";
}

// while loop
echo "<h1>While loop: </h1>";
$i = 0;
while ($i < $number) {
  echo "{$i}<br>";
  $i++;
}

// do-while loop
echo "<h1>Do-while loop: </h1>";
$i = 0;
do {
  echo "{$i}<br>";
  $i++;
} while ($i < $number);

// break
echo "<h1>Break: </h1>";
for ($i = 0; $i < $number; $i++) {
  if ($i == 5) {
    break;
  }
  echo "{$i}<br>";
}

// continue
echo "<h1>Continue: </h1>";
for ($i = 0; $i < $number; $i++) {
  if ($i == 5) {
    continue;
  }
  echo "{$i}<br>";
}

?>