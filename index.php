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
</body>

</html>
<?php
/* Lesson 8: Arrays in PHP
    ### Arrays:
      - Lists with numeric keys
      - Example: $fruits = ["Apple", "Banana", "Orange"];

    ### Associative Arrays:
      - Key-value pairs
      - Example: $person = ["name" => "John", "age" => 25];

    ### Traversing Arrays:
      - Example: foreach ($array as $value) {
        echo $value . "<br>";
      }

    ### Traversing Associative Arrays:
      - Example: foreach ($array as $key => $value) {
        echo "{$key} = {$value} <br>";
      }

    ### Array Functions:
      - count() - counts the number of elements in an array - count( mixed $array_or_countable [, int $mode = COUNT_NORMAL ]): int
      - sort() - sorts an array by value - sort( array $array [, int $sort_flags = SORT_REGULAR ]): bool
      - array_push() - adds one or more elements to the end of an array - array_push( array $array [, mixed $... ]): int
      - array_pop() - removes the last element of an array - array_pop( array $array ): array
      - array_shift() - Shift an element off the beginning of array - array_shift( array $array ): array
      - array_unshift() - Prepend one or more elements to the beginning of an array - array_unshift( array $array [, mixed $... ]): int
      - array_merge() - merges one or more arrays - array_merge( array $array1 [, array $... ]): array
      - array_search() - searches the array for a value and returns the first corresponding key if successful
      - in_array() - checks if a value exists in an array
      - array_keys() - returns all the keys of an array
      - array_values() - returns all the values of an array
      - array_filter() - filters the elements of an array using a callback function
*/

// array
$foods = ["Apple", "Banana", "Orange"];
echo "{$foods[0]} <br>";

// associative array
$person = ["name" => "John", "age" => 25];
echo "{$person["name"]} <br>";

$students = [["John", "A"], ["Mary", "B"]];
echo "{$students[0][0]} <br>";

// traversing array
echo "<h3>Traversing Array:</h3>";
foreach ($foods as $food) {
  echo "{$food} <br>";
}

// traversing associative array
echo "<h3>Traversing Associative Array:</h3>";
foreach ($person as $key => $value) {
  echo "{$key} = {$value} <br>";
}

// array functions
echo "<h2>Array Functions</h2>";
echo "Count: " . count($foods) . "<br>";
echo "Sort: " . sort($foods) . "<br>";
echo "Array Push: " . array_push($foods, "Kiwi") . " ---> ";
print_r($foods);
echo "<br>";
echo "Array Pop: " . array_pop($foods) . "--->";
print_r($foods);
echo "<br>";
?>