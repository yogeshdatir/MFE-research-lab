<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <form>
    <label for="workedHours">Worked Hours:</label>
    <input type="number" id="workedHours" name="workedHours"><br><br>

    <label for="hourlyRate">Hourly Rate:</label>
    <input type="number" id="hourlyRate" name="hourlyRate"><br><br>

    <input type="checkbox" id="bonus" name="bonus" value=true>
    <label for="bonus">Eligible for Bonus</label><br><br>

    <input type="submit" value="Calculate Salary">
  </form>
</body>

</html>
<?php
/* Lesson 6: Logical Operators in PHP
  ### Common logical operators:
  - `&&` (AND): True if both operands are true.
  - `||` (OR): True if at least one operand is true.
  - `!` (NOT): True if the operand is false.
*/

$workedHours = $_GET['workedHours'];
$hourlyRate = $_GET['hourlyRate'];
$salary = 0;
$is_eligibleForBonus = $_GET['bonus'];
$bonus = 100;

if ($workedHours < 0 || $hourlyRate < 0) {
  echo "Worked hours and hourly rate must be non-negative.";
  exit;
} else if ($workedHours >= 0 && $workedHours <= 40) {
  $salary = $workedHours * $hourlyRate; // Regular pay for up to 40 hours
} else if ($workedHours <= 60) {
  $overtimeHours = $workedHours - 40;
  $salary = (40 * $hourlyRate) + ($overtimeHours * $hourlyRate * 1.5); // Overtime pay for hours over 40
} else {
  $overtimeHours = $workedHours - 40;
  $salary = (40 * $hourlyRate) + (20 * $hourlyRate * 1.5) + ($overtimeHours * $hourlyRate * 2); // Double time for hours over 60
}

if ($is_eligibleForBonus) {
  $salary += $bonus; // Add bonus if eligible
}

echo "Worked Hours: $workedHours<br>";
echo "Hourly Rate: $hourlyRate<br>";
echo "Salary: $salary<br>";
?>