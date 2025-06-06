<?php
  /* Lesson 2: PHP Variables and Data Types
    -- Introduction to PHP Variables
    * Variables are used to store data that can be used and manipulated throughout your PHP script.
    * They allow you to create dynamic content and manage data effectively.
    * PHP Variables declared with a dollar sign ($) followed by the name of the variable.
    * Variable names can contain letters, numbers, and underscores, but cannot start with a number.
    * Variables can be assigned values using the assignment operator (=).
    * PHP variables are case-sensitive, meaning $Variable and $variable are different variables.

    -- Data Types in PHP
    * PHP is a dynamically typed language, meaning you do not need to specify the data type of a variable when you declare it.
    * The data type of a variable is determined by the value it holds.
    * PHP automatically converts between data types as needed, a feature known as type juggling.
    * PHP supports several data types including strings, integers, floats, booleans, arrays, and objects. We will cover arrays and objects in later lessons. NULL is also a special data type that represents a variable with no value.
    * Common data types in PHP:
      - String: A sequence of characters enclosed in quotes.
      - Integer: A whole number without a decimal point.
      - Float (or Double): A number with a decimal point.
      - Boolean: Represents two possible values: true or false.
      - NULL: Represents a variable with no value.
  */

  $name = "John Doe"; // String variable
  $age = 30; // Integer variable
  $height = 5.9; // Float variable
  $is_student = false; // Boolean variable
  $is_minor = true; // Another Boolean variable

  // Displaying the variables
  // Using curly braces to enclose variable names in strings for clarity

  echo "Lesson 2: PHP Variables and Data Types<br><br>";
  echo "Variable Examples:<br><br>";
  echo "Name: {$name}<br>"; // Name: John Doe
  echo "Age: {$age}<br>"; // Age: 30
  echo "Height: {$height} feet<br>"; // Height: 5.9 feet

  // Boolean values will be displayed as 1 (true) or nothing (false)
  echo "Is Student: {$is_student} <br>"; // Is Student:
  echo "Is Minor: {$is_minor} <br>"; // Is Minor: 1

  $product = "Laptop";
  $price = 999.99;
  $quantity = 5;
  $total_cost = null;

  $total_cost = $price * $quantity; // Calculating total cost

  // Escape sequences are used to format the output with dollar sign
  echo "<br>Total Cost of {$quantity} {$product}(s): \${$total_cost}<br>"; // Total Cost of 5 Laptop(s): $4999.95
?>