<?php
  /* Lesson 3: Arithmetic in PHP
    ## Arithmetic Operators
    - Addition: `+`
    - Subtraction: `-`
    - Multiplication: `*`
    - Division: `/`
    - Modulus: `%`
    - Exponentiation: `**`
    - Increment: `++`
    - Decrement: `--`

    ## Operator Precedence
    - Parentheses `()`
    - Exponentiation `**`
    - Multiplication `*`, Division `/`, Modulus `%`
    - Addition `+`, Subtraction `-`

    ## Example of Operator Precedence
    - The expression `10 + 5 - 2 * 3 / 2 % 4 ** 2` is evaluated as follows:
      1. Exponentiation: `4 ** 2` is evaluated first.
      2. Then, multiplication, division, and modulus are evaluated from left to right.
      3. Finally, addition and subtraction are evaluated from left to right.
  */

  $total = 10 + 5 - 2 * 3 / 2 % 4 ** 2;
  // The above expression evaluates as follows:
  // Exponentiation: 4 ** 2 = 16 --> 10 + 5 - 2 * 3 / 2 % 16
  // Multiplication: 2 * 3 = 6 --> 10 + 5 - 6 / 2 % 16
  // Division: 6 / 2 = 3 --> 10 + 5 - 3 % 16
  // Modulus: 3 % 16 = 3 --> 10 + 5 - 3
  // Addition & Subtraction: 10 + 5 = 15 --> 15 - 3 = 12
  echo "The total is: $total"; // Output: The total is: 12
?>