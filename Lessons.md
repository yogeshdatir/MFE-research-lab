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

  The expression `10 + 5 - 2 3 / 2 % 4 *2` is evaluated as follows:

  1. Exponentiation: `4 *2` is evaluated first.
  2. Then, multiplication, division, and modulus are evaluated from left to right.
  3. Finally, addition and subtraction are evaluated from left to right.

## Lesson 4: `$_GET` and `$_POST` Superglobals

### `$_GET`:

- Used to collect data sent in the URL query string.
- Data is appended to the URL after a question mark (?), with each key-value pair separated by an ampersand (&).
- Example: `index.php?name=John&age=30`
- Data is visible in the URL, making it suitable for non-sensitive data.
- Data can be cached, bookmarked, and logged in the browser history.
- Commonly used for search queries, filters, and pagination.
- Bookmarked URLs can include the data, allowing users to return to the same state of the application and can be shared easily.
- Example Usage:
  - Used for search forms, filters, and pagination.
  - Example: `index.php?search=keyword&page=2`

### `$_POST`:

- Used to collect data sent in the body of an HTTP request.
- Data is not visible in the URL, making it suitable for sensitive data like passwords.
- Example: Data is sent when a form is submitted with method="POST".
- Data is not cached, bookmarked, or logged in the browser history.
- Commonly used for form submissions that require data security, such as login forms, registration forms, and data updates.
- Data is sent in the request body, making it more secure for sensitive information.
- Example Usage:
  - Used for login forms, registration forms, and data submission that requires security.
  - Example: A form that submits user credentials or sensitive information.

### Differences:

- Visibility: `$_GET` data is visible in the URL, while `$_POST` data is not.
- Data Size: `$_GET` has size limitations (typically around 2000 characters), while `$_POST` can handle larger amounts of data.
- Use Cases: `$_GET` is often used for search queries and navigation, while `$_POST` is used for form submissions that require data security.
- Security: `$_POST` is generally more secure for sensitive data, as it does not expose data in the URL.
- Example Usage:
  - `$_GET`: Used for search forms, filters, and pagination.
  - `$_POST`: Used for login forms, registration forms, and data submission that requires security.

## Lesson 5: if-else statement

### if-else statement syntax:

```
  if (condition) {
  // code to execute if condition is true
  } else if (condition) {
  // code to execute if condition is false
  } else {
  // code to execute if condition is false
  }
```

## Lesson 6: Logical Operators in PHP

### Common logical operators:

- `&&` (AND): True if both operands are true.
- `||` (OR): True if at least one operand is true.
- `!` (NOT): True if the operand is false.

## Lesson 7: Switch Statements in PHP

### Switch Statement:

- Used when you need to compare a single value against multiple possible values
- More efficient than multiple if-else statements for this purpose
- Uses 'case' and 'break' keywords
- Can include a 'default' case for unmatched values
- Syntax:
  ```
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
  ```

## Lesson 7: Loops in PHP

### 1. for loop:

- Used when you know the number of iterations in advance
- Syntax:

  ```
  for (initialization; condition; increment/decrement) {
    // code to execute
  }
  ```

- Example:
  ```
  for ($i = 0; $i < 10; $i++) {
    echo $i;
  }
  ```

### 2. while loop:

- Used when you don't know the number of iterations in advance
- Syntax:
  ```
  while (condition) {
    // code to execute
  }
  ```
- Example:
  ```
  $i = 0;
  while ($i < 10) {
    echo $i;
    $i++;
  }
  ```

### 3. do-while loop:

- Similar to while loop but guaranteed to execute at least once
- Syntax:
  ```
  do {
    // code to execute
  } while (condition);
  ```
- Example:
  ```
  $i = 0;
  do {
    echo $i;
    $i++;
  } while ($i < 10);
  ```

### 4. break:

- Used to exit a loop or switch statement
- Syntax:
  `break;`
- Example:
  ```
  for ($i = 0; $i < 10; $i++) {
    if ($i == 5) {
      break;
    }
    echo $i;
  }
  ```

### 5. continue:

- Used to skip the current iteration of a loop
- Syntax:
  `continue;`
- Example:
  ```
  for ($i = 0; $i < 10; $i++) {
    if ($i == 5) {
      continue;
    }
    echo $i;
  }
  ```

## Lesson 8: Arrays in PHP

### Arrays:

- Lists with numeric keys
- Example: `$fruits = ["Apple", "Banana", "Orange"];`

### Associative Arrays:

- Key-value pairs
- Example: `$person = ["name" => "John", "age" => 25];`

### Traversing Arrays:

- Example:
  ```
  foreach ($array as $value) {
    echo $value;
  }
  ```

### Traversing Associative Arrays:

- Example:
  ```
  foreach ($array as $key => $value) {
    echo "{$key} = {$value} <br>";
  }
  ```

### Array Functions:

- `count()`
  - counts the number of elements in an array
  - `count( mixed $array_or_countable [, int $mode = COUNT_NORMAL ]): int`
- `sort()`
  - sorts an array by value
  - `sort( array $array [, int $sort_flags = SORT_REGULAR ]): bool`
- `array_push()`
  - adds one or more elements to the end of an array
  - `array_push( array $array [, mixed $... ]): int`
- `array_pop()`
  - removes the last element of an array `array_pop( - array $array ): array`
- `array_shift()`
  - Shift an element off the beginning of array
  - `array_shift( array $array ): array`
- `array_unshift()`
  - Prepend one or more elements to the beginning of an array
  - `array_unshift( array $array [, mixed $... ]): int`
- `array_merge()`
  - merges one or more arrays
  - `array_merge( array $array1 [, array $... ]): array`
- `array_search()`
  - searches the array for a value and returns the first
  - corresponding key if successful
- `in_array()`
  - checks if a value exists in an array
- `array_keys()`
  - returns all the keys of an array
- `array_values()`
  - returns all the values of an array
- `array_filter()`
  - filters the elements of an array using a callback function

## Lesson 9: `isset()` & `empty()` functions & Processing radio buttons and checkboxes in PHP

### `isset()`

- `isset( mixed $var [, mixed $... ]): bool`
- Returns TRUE if a variable is declared and not null

### `empty()`

- `empty( mixed $var ): bool`
- Returns TRUE if a variable if not declared, false, null, ""
