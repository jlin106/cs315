<head>
 <title>Labor Force Option 3</title>
 <link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>
<?php


function outputResultsTableHeader() {
   echo "<tr>";
   echo "<th> Country </th>";
   echo "<th> Labor Force Participation Rate<br />(%) </th>";
   echo "<th> Unemployment Rate<br />(%) </th>";
   echo "<th> Percentage Employed in Agriculture<br />(%) </th>";
   echo "<th> Percentage Employed in Industry<br />(%) </th>";
   echo "<th> Percentage Employed in Service<br />(%) </th>";
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
$topbottom = $_POST['topbottom'];
$number = $_POST['number'];
$attribute = $_POST['attribute'];


echo "<h2> Option 3: Query data sorted by labor force data </h2>";
echo "<div class='container row'>";
echo "<h3> Currently showing ";
echo $topbottom;
echo " ";
echo $number;
echo " countries sorted by ";
echo ($attribute == 'laborForceParticipationRate') ? "Labor Force Participation Rate" : "";
echo ($attribute == 'unemploymentRate') ? "Unemployment Rate" : "";
echo ($attribute == 'percentEmplAgriculture') ? "Percentage Employed in Agriculture" : "";
echo ($attribute == 'percentEmplIndustry') ? "Percentage Employed in Industry" : "";
echo ($attribute == 'percentEmplServices') ? "Percentage Employed in Service" : "";
echo "</h3>";

echo "<table border=\"1px solid black\">";

// It returns true if first statement executed successfully; false otherwise.
// Results of first statement are retrieved via $mysqli->store_result()
// from which we can call ->fetch_row() to see successive rows
if ($mysqli->multi_query("CALL LaborForceThree('".$topbottom."','".$number."','".$attribute."');")) {

   // Check if a result was returned after the call
   if ($result = $mysqli->store_result()) {

       echo "<table border=\"1px solid black\">";
       $row = $result->fetch_row();

       // Output appropriate table header row
       outputResultsTableHeader();

       // Output each row of resulting relation
       do {
           echo "<tr>";
           for($i = 0; $i < sizeof($row); $i++){
               echo "<td>" . $row[$i] . "</td>";
           }
           echo "</tr>";
       } while($row = $result->fetch_row());
       echo "</table>";
       $result->close();

   }

// The "multi_query" call did not end successfully, so report the error
// This might indicate we've called a stored procedure that does not exist,
// or that database connection is broken
} else {
       printf("<br>Error: %s\n", $mysqli->error);
}

// Close the connection created above by including 'open.php' at top of this file
mysqli_close($mysqli);
echo "</div>";


?>
</body>
