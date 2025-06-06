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
