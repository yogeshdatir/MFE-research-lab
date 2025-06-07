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
  <form action="index.php" method="POST">
    <legend>Sign In</legend>
    <label>Username:
      <input type="text" name="username" />
    </label>
    <label>Password:
      <input type="text" name="password" />
    </label>
    <input type="submit" name="signin" value="Sign In" />
  </form>

  <form action="index.php" method="POST">
    <legend>Select a card type:</legend>
    <label>Visa:
      <input type="radio" name="card_type" value="Visa" />
    </label>
    <label>Mastercard:
      <input type="radio" name="card_type" value="Mastercard" />
    </label>
    <label>American Express:
      <input type="radio" name="card_type" value="American Express" />
    </label>
    <input type="submit" name="confirm" value="Confirm" />
  </form>

  <form action="index.php" method="POST">
    <legend>Select fruits:</legend>
    <label>
      <input type="checkbox" name="fruits[]" value="Banana" />
      Banana
    </label>
    <br>
    <label>
      <input type="checkbox" name="fruits[]" value="Apple" />
      Apple
    </label>
    <br>
    <label>
      <input type="checkbox" name="fruits[]" value="Orange" />
      Orange
    </label>
    <br>
    <input type="submit" name="submit" value="Submit" />
  </form>
</body>

</html>
<?php
/* Lesson 9: isset() & empty() functions & Processing radio buttons and checkboxes in PHP
    ### isset()
      - isset( mixed $var [, mixed $... ]): bool
      - Returns TRUE if a variable is declared and not null

    ### empty()
      - empty( mixed $var ): bool
      - Returns TRUE if a variable if not declared, false, null, ""
*/

$v1 = "";
$v2 = null;
$v3 = false;
// undeclared $v4

if (!isset($_POST["confirm"]) && !isset($_POST["submit"])) {
  echo "<h4>Variable declarations:</h4>";
  echo '$v1 = "";<br>
    $v2 = null;<br>
    $v3 = false;<br>
    // undeclared $v4<br>';

  echo "<h4>Testing isset function:</h4>";
  echo "isset(\$v1): " . isset($v1) . " for empty string value<br>";
  echo "isset(\$v2): " . isset($v2) . " for null<br>";
  echo "isset(\$v3): " . isset($v3) . " for false<br>";
  echo "isset(\$v4): " . isset($v4) . " for undeclared variable<br>";

  echo "<h4>Testing empty function:</h4>";
  echo "empty(\$v1): " . empty($v1) . " for empty string value<br>";
  echo "empty(\$v2): " . empty($v2) . " for null<br>";
  echo "empty(\$v3): " . empty($v3) . " for false<br>";
  echo "empty(\$v4): " . empty($v4) . " for undeclared variable<br>";
}


if (isset($_POST["signin"])) {
  echo "<h3>Sign In:</h3>";

  if (empty($_POST["username"])) {
    echo "Username is missing";
  } else if (empty($_POST["password"])) {
    echo "Password is missing";
  } else {
    echo "Welcome!";
  }
}

// Processing radio buttons and checkboxes
if (isset($_POST["confirm"])) {
  echo "<h3>Processing radio button:</h3>";

  $card_type = null;

  if (isset($_POST["card_type"])) {
    $card_type = $_POST["card_type"];
  }

  switch ($card_type) {
    case "Visa":
      echo "You selected Visa";
      break;
    case "Mastercard":
      echo "You selected Mastercard";
      break;
    case "American Express":
      echo "You selected American Express";
      break;
    default:
      echo "Please select a card type...";
  }
}

if (isset($_POST["submit"])) {
  echo "<h3>Processing checkboxes:</h3>";

  $fruits = null;

  if (isset($_POST["fruits"])) {
    $fruits = $_POST["fruits"];
  }

  foreach ($fruits as $fruit) {
    echo $fruit . "<br>";
  }
}
?>