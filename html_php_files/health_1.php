<head>
 <title>Health Option 1</title>
 <link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>
<?php


function outputResultsTableHeader() {
   echo "<tr>";
   echo "<th> Country </th>";
   echo "<th> Health Expenditure<br />(% of total govt. exp.) </th>";
   echo "<th> Physicians Per 1000<br /> </th>";
   echo "<th> Percentage of Population with Access to Safe Sanitation Facilities<br />(%) </th>";
   echo "<th> Percentage of Population with Access to Safe Water Facilities<br />(%) </th>";
   echo "<th> Number of Confimed Cases </th>";
   echo "<th> Number of Deaths </th>";
   echo "<th> Number of Recovered Cases </th>";
   echo "</tr>";
}


// Open a database connection
// The call below relies on files named open.php and dbase-conf.php
// It initializes a variable named $mysqli, which we use below
include 'open.php';

// Configure error reporting settings
ini_set('error_reporting', E_ALL); // report errors of all types
ini_set('display_errors', true);   // report errors to screen (don't hide from user)

// Collect the data input posted here from the calling page
// The associative array called S_POST stores data using names as indices
$countries = $_POST['country'];
$countries_list = implode(', ', $countries);


echo "<h2> Option 2: Query health data by country </h2>";
echo "<div class='container row'>";
echo "<h3> Countries of Interest: ";
echo $countries_list;
echo "</h3>";

echo "<table border=\"1px solid black\">";
outputResultsTableHeader();

// Retrieving each selected option
foreach ($countries as $country) {
  // It returns true if first statement executed successfully; false otherwise.
  // Results of first statement are retrieved via $mysqli->store_result()
  // from which we can call ->fetch_row() to see successive rows
  if ($mysqli->multi_query("CALL HealthByCountry('".$country."');")) {
     // Check if a result was returned after the call
     if ($result = $mysqli->store_result()) {
	      $row = $result->fetch_row();
        // If the result is empty, then there was no data for this country
        if (strcmp($row[0], '') == 0) {
          echo "<tr>";
          echo "<td>";
          echo $country;
          echo "</td>";
          echo "<td> No data </td>";
          echo "<td> No data </td>";
          echo "<td> No data </td>";
          echo "<td> No data </td>";
          echo "<td> No data </td>";
          echo "<td> No data </td>";
          echo "<td> No data </td>";
          echo "</tr>";
        // Otherwise, we received real results, so output table
        } else {
          // Output each row of resulting relation
          echo "<tr>";
          for($i = 0; $i < sizeof($row); $i++){
            echo "<td>" . $row[$i] . "</td>";
          }
          echo "</tr>";
        }
        $result->close();
        $mysqli->next_result();
     }
  // The "multi_query" call did not end successfully, so report the error
  // This might indicate we've called a stored procedure that does not exist,
  // or that database connection is broken
  } else {
     printf("<br>Error: %s\n", $mysqli->error);
  }
}
echo "</table>";

// Close the connection created above by including 'open.php' at top of this file
mysqli_close($mysqli);
echo "</div>";

?>
</body>
