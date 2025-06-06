/* Lesson 4: $_GET and $_POST Superglobals
  ### $_GET:
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

  ### $_POST:
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
  - Visibility: $_GET data is visible in the URL, while $_POST data is not.
  - Data Size: $_GET has size limitations (typically around 2000 characters), while $_POST can handle larger amounts of data.
  - Use Cases: $_GET is often used for search queries and navigation, while $_POST is used for form submissions that require data security.
  - Security: $_POST is generally more secure for sensitive data, as it does not expose data in the URL.
  - Example Usage:
    - $_GET: Used for search forms, filters, and pagination.
    - $_POST: Used for login forms, registration forms, and data submission that requires security.
*/

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <form action="index.php" method="POST">
    <h1>Welcome to the Form</h1>
    <input type="text" name="username" placeholder="Enter your username" required>
    <input type="password" name="password" placeholder="Enter your password" required>
    <button type="submit">Submit</button>
  </form>

  <form action="index.php" method="GET">
    <h1>Another Form</h1>
    <input type="text" name="anotherField" placeholder="Another field">
    <button type="submit">Submit Another Form</button>
  </form>
</body>

</html>
<?php
  echo "Username: {$_POST['username']}<br>";
  echo "Password: {$_POST['password']}<br>";

  echo "Another Field: {$_GET['anotherField']}<br>";
?>