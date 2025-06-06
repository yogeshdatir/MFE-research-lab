# PHP Learning

## Lesson 1: Basic PHP Syntax

- PHP files typically have a .php extension
- PHP code is embedded in HTML using <?php and ?>
- Comments can be single-line (//) or multi-line (/_ multi-lines comments _/)
- Use echo to output text to the browser
- PHP is executed on the server

## Lesson 2: PHP Variables and Data Types

### Introduction to PHP Variables

- Variables are used to store data that can be used and manipulated throughout your PHP script.
- They allow you to create dynamic content and manage data effectively.
- PHP Variables declared with a dollar sign ($) followed by the name of the variable.
- Variable names can contain letters, numbers, and underscores, but cannot start with a number.
- Variables can be assigned values using the assignment operator (=).
- PHP variables are case-sensitive, meaning $Variable and $variable are different variables.

### Data Types in PHP

- PHP is a dynamically typed language, meaning you do not need to specify the data type of a variable when you declare it.
- The data type of a variable is determined by the value it holds.
- PHP automatically converts between data types as needed, a feature known as type juggling.
- PHP supports several data types including strings, integers, floats, booleans, arrays, and objects.  
  We will cover arrays and objects in later lessons.  
  NULL is also a special data type that represents a variable with no value.
- Common data types in PHP:
  1. String: A sequence of characters enclosed in quotes.
  2. Integer: A whole number without a decimal point.
  3. Float (or Double): A number with a decimal point.
  4. Boolean: Represents two possible values: true or false.
  5. NULL: Represents a variable with no value.

## Lesson 3: Arithmetic in PHP

### Arithmetic Operators

- Addition: `+`
- Subtraction: `-`
- Multiplication: `*`
- Division: `/`
- Modulus: `%`
- Exponentiation: `**`
- Increment: `++`
- Decrement: `--`

### Operator Precedence

- Parentheses `()`
- Exponentiation `**`
- Multiplication `*`, Division `/`, Modulus `%`
- Addition `+`, Subtraction `-`

  #### Example of Operator Precedence

  The expression `10 + 5 - 2 * 3 / 2 % 4 ** 2` is evaluated as follows:

  1. Exponentiation: `4 ** 2` is evaluated first.
  2. Then, multiplication, division, and modulus are evaluated from left to right.
  3. Finally, addition and subtraction are evaluated from left to right.
