import java.util.Scanner;
import java.sql.* ;
public class Soccer {
    public static void main(String[] args)  throws SQLException{
        int sqlCode=0;      // Variable to hold SQLCODE
        String sqlState="00000";  // Variable to hold SQLSTATE

        // Register the driver.  You must register the driver before you can use it.
        try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
        catch (Exception cnfe){ System.out.println("Class not found"); }

        // This is the url you must use for DB2.
        //Note: This url may not valid now ! Check for the correct year and semester and server name.
        String url = "jdbc:db2://winter2023-comp421.cs.mcgill.ca:50000/cs421";

        //REMEMBER to remove your user id and password before submitting your code!!
        String your_userid ="cs421g138";
        String your_password ="Project2421data";
        //AS AN ALTERNATIVE, you can just set your password in the shell environment in the Unix (as shown below) and read it from there.
        //$  export SOCSPASSWD=yoursocspasswd
        if(your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null)
        {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }
        if(your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null)
        {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }
        Connection con = DriverManager.getConnection (url,your_userid,your_password) ;
        Statement statement = con.createStatement ( ) ;

        Scanner reader = new Scanner(System.in);
        while (true){
            System.out.println("Soccer Main Menu");
            System.out.println("1. List information of matches of a country");
            System.out.println("2. Insert initial player information for a match");
            System.out.println("3. Update a goal scorer");
            System.out.println("4. Exit application");
            System.out.println("Please Enter Your Option:");
            String input=reader.nextLine();
            if(input.equals("1")){
                while(true) {
                    System.out.println("Please enter a country name");
                    String country = reader.nextLine();

                    // Querying a table
                    try {
                        String querySQL = "SELECT DISTINCT c1.country country_a,c2.country country_b,m.dateTime,m.round,count(DISTINCT g1.OCCURANCE) num_goals_a,count(DISTINCT g2.OCCURANCE) num_goals_b,count(DISTINCT t.VERIFICATIONNUMBER) num_tickets\n" +
                                "FROM playersInGame c1,playersInGame c2,Matches m,goalsScored g1,goalsScored g2,tickets t\n" +
                                "WHERE m.IDENTIFIER=c1.identifier AND c1.IDENTIFIER=c2.identifier AND c1.COUNTRY<>c2.COUNTRY AND c1.COUNTRY='" + country + "' AND g1.IDENTIFIER=c1.IDENTIFIER AND g1.NUMBER=c1.NUMBER and t.IDENTIFIER=c1.IDENTIFIER AND g2.IDENTIFIER=c2.IDENTIFIER AND g2.NUMBER=c2.NUMBER\n" +
                                "GROUP BY c1.country, c2.country, m.dateTime, m.round";
                        System.out.println(querySQL);
                        java.sql.ResultSet rs = statement.executeQuery(querySQL);

                        while (rs.next()) {
                            String ca = rs.getString(1);
                            String cb = rs.getString(2);
                            String date = rs.getString(3);
                            String round = rs.getString(4);
                            String goalsa = rs.getString(5);
                            String goalsb = rs.getString(6);
                            String tickets = rs.getString(7);
                            System.out.println(ca + "  " + cb + "  " + date + "  " + round + "  " + goalsa + "  " + goalsb + "  " + tickets);
                        }
                    } catch (SQLException e) {
                        sqlCode = e.getErrorCode(); // Get SQLCODE
                        sqlState = e.getSQLState(); // Get SQLSTATE
                        // Your code to handle errors comes here;
                        // something more meaningful than a print would be good
                        System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                        System.out.println(e);
                    }
                    System.out.println("Enter [A] to find matches of another country, [P] to go to the previous menu:");
                    String in = reader.nextLine();
                    if (in.equals("A"))
                        continue;
                    else if (in.equals("P"))
                        break;

                }
            }
            if(input.equals("2")){
                try {
                    String querySQL = "SELECT DISTINCT m.identifier,t1.COUNTRY,t2.COUNTRY, m.dateTime,m.round\n" +
                            "FROM Matches m,team t1,team t2\n" +
                            "WHERE m.IDENTIFIER=t1.IDENTIFIER AND t1.IDENTIFIER=t2.IDENTIFIER AND t1.COUNTRY<>t2.COUNTRY AND m.DATETIME between '2023-02-23 00:00:00.000000' and '2023-02-26 00:00:00.000000'";
                    System.out.println(querySQL);
                    java.sql.ResultSet rs = statement.executeQuery(querySQL);

                    while (rs.next()) {
                        String id = rs.getString(1);
                        String ca = rs.getString(2);
                        String cb = rs.getString(3);
                        String date = rs.getString(4);
                        String round = rs.getString(5);
                        System.out.println( "Match id:"+id+ "  " + ca + "  " + cb + "  " + date + "  " + round);
                    }

                } catch (SQLException e) {
                    sqlCode = e.getErrorCode(); // Get SQLCODE
                    sqlState = e.getSQLState(); // Get SQLSTATE
                    // Your code to handle errors comes here;
                    // something more meaningful than a print would be good
                    System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                    System.out.println(e);
                }


                    System.out.println("Please enter a match id");
                    String matchid = reader.nextLine();
                    System.out.println("Please enter a country name");
                    String country = reader.nextLine();
                while(true ) {
                    // Querying a table
                    try {
                        String querySQL = "Select p2.name,p.number,p.DETAILEDPOSITION,p.MINUTEENTERED,p.MINUTELEFT,p.NUMBEROFYELLOWCARDS,p.REDCARD\n" +
                                "FROM playersInGame p, players p2\n" +
                                "WHERE p.number=p2.number AND p.identifier='" + matchid + "' AND p.country='" + country + "'\n";
                        System.out.println(querySQL);
                        java.sql.ResultSet rs = statement.executeQuery(querySQL);

                        System.out.println("The following players from " + country + " are already entered for match " + matchid + ":");
                        int count=0;
                        while (rs.next()) {
                            count++;
                            String name = rs.getString(1);
                            String number = rs.getString(2);
                            String pos = rs.getString(3);
                            String min1 = rs.getString(4);
                            String min2 = rs.getString(5);
                            String yellow = rs.getString(6);
                            String red = rs.getString(7);

                            System.out.println(name + "  " + number + "  " + pos + "  From minute: " + min1 + "  to minute: " + min2 + "  yellow:" + yellow + "  red:" + red);
                        }
                        if(count>=3){
                            System.out.println("Maximum number of players reached. Can't insert any more players into this team for this match");
                            break;
                        }
                    } catch (SQLException e) {
                        sqlCode = e.getErrorCode(); // Get SQLCODE
                        sqlState = e.getSQLState(); // Get SQLSTATE
                        // Your code to handle errors comes here;
                        // something more meaningful than a print would be good
                        System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                        System.out.println(e);
                    }

                    // Querying a table
                    try {
                        String querySQL = "SELECT DISTINCT p.number,p.name,p.position\n" +
                                "FROM players p, PLAYERSINGAME p2\n" +
                                "WHERE p.country='" + country + "' AND p.IDENTIFIER='" + matchid + "'  AND p.number NOT IN (SELECT NUMBER\n" +
                                "                                                  FROM PLAYERSINGAME)";
                        System.out.println(querySQL);
                        java.sql.ResultSet rs = statement.executeQuery(querySQL);

                        System.out.println("Possible players from " + country + " not yet selected:");
                        while (rs.next()) {
                            String name = rs.getString(1);
                            String number = rs.getString(2);
                            String pos = rs.getString(3);
                            System.out.println(name + "  " + number + "  " + pos);
                        }
                    } catch (SQLException e) {
                        sqlCode = e.getErrorCode(); // Get SQLCODE
                        sqlState = e.getSQLState(); // Get SQLSTATE
                        // Your code to handle errors comes here;
                        // something more meaningful than a print would be good
                        System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                        System.out.println(e);
                    }

                    System.out.println("Enter number of player you want to insert or [P] to go to the previous menu:");
                    String in = reader.nextLine();
                    if (in.equals("P"))
                        break;
                    else {
                        System.out.println("Enter the specific position of player " + in);
                        String pos = reader.nextLine();
                        String temp2 = "'" + pos + "'";
                        String temp3 = "'" + country + "'";
                        // Inserting Data into the table
                        try {
                            String insertSQL = "INSERT INTO PlayersInGame VALUES (" + in + ",0,FALSE,0,NULL," + temp2 + ",'FNB Stadium'," + matchid + "," + temp3 + ")";
                            System.out.println(insertSQL);
                            statement.executeUpdate(insertSQL);
                        } catch (SQLException e) {
                            sqlCode = e.getErrorCode(); // Get SQLCODE
                            sqlState = e.getSQLState(); // Get SQLSTATE
                            // Your code to handle errors comes here;
                            // something more meaningful than a print would be good
                            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                            System.out.println(e);
                        }
                    }
                }
            }
            if(input.equals("3")){

                try {
                    String querySQL = "SELECT DISTINCT m.IDENTIFIER,c1.country country_a,c2.country country_b,m.dateTime,m.round,count(DISTINCT g1.OCCURANCE) num_goals_a,count(DISTINCT g2.OCCURANCE) num_goals_b\n" +
                            "FROM playersInGame c1,playersInGame c2,Matches m,goalsScored g1,goalsScored g2\n" +
                            "WHERE m.IDENTIFIER=c1.identifier AND c1.IDENTIFIER=c2.identifier AND c1.COUNTRY<>c2.COUNTRY AND g1.IDENTIFIER=c1.IDENTIFIER AND g1.NUMBER=c1.NUMBER and g2.IDENTIFIER=c2.IDENTIFIER AND g2.NUMBER=c2.NUMBER AND m.DATETIME BETWEEN '2002-02-23 00:00:00.000000' and '2023-02-23 00:00:00.000000'\n" +
                            "GROUP BY m.identifier,c1.country, c2.country, m.dateTime, m.round";
                    System.out.println(querySQL);
                    java.sql.ResultSet rs = statement.executeQuery(querySQL);

                    while (rs.next()) {
                        String id = rs.getString(1);
                        String ca = rs.getString(2);
                        String cb = rs.getString(3);
                        String date = rs.getString(4);
                        String round = rs.getString(5);
                        String goalsa = rs.getString(6);
                        String goalsb = rs.getString(7);

                        System.out.println("Match id: "+id + "  " + ca + "  " + cb + "  " + date + "  " + round + "  " + goalsa + "  " + goalsb);
                    }

                } catch (SQLException e) {
                    sqlCode = e.getErrorCode(); // Get SQLCODE
                    sqlState = e.getSQLState(); // Get SQLSTATE
                    // Your code to handle errors comes here;
                    // something more meaningful than a print would be good
                    System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                    System.out.println(e);
                }

                System.out.println("Please enter a match id");
                String matchid = reader.nextLine();
                System.out.println("Please enter a country name");
                String country = reader.nextLine();
                int count=0;
                while(true) {
                    // Querying a table
                    if(count>=2){
                        System.out.println("Maximum number of updates reached to prevent abuse of this feature. Will be sent back to the main menu ");
                        break;
                    }
                    try {
                        String querySQL ="SELECT DISTINCT p.number,g.occurance\n" +
                                "FROM playersInGame p,GOALSSCORED g\n" +
                                "WHERE p.COUNTRY='"+country+"' AND p.IDENTIFIER="+matchid+" AND p.NUMBER=g.NUMBER";
                        System.out.println(querySQL);
                        java.sql.ResultSet rs = statement.executeQuery(querySQL);

                        System.out.println("Goals scored by " + country + " in match " + matchid + ":");

                        while (rs.next()) {
                            String num = rs.getString(1);
                            String occur = rs.getString(2);

                            System.out.println(  "Player number:  " + num + " at occurence of:  " + occur);
                        }

                    } catch (SQLException e) {
                        sqlCode = e.getErrorCode(); // Get SQLCODE
                        sqlState = e.getSQLState(); // Get SQLSTATE
                        // Your code to handle errors comes here;
                        // something more meaningful than a print would be good
                        System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                        System.out.println(e);
                    }
                    // Querying a table
                    try {
                        String querySQL ="Select number,DETAILEDPOSITION\n" +
                                "FROM PLAYERSINGAME\n" +
                                "WHERE IDENTIFIER="+matchid+" AND country='"+country+"'";
                        System.out.println(querySQL);
                        java.sql.ResultSet rs = statement.executeQuery(querySQL);

                        System.out.println("Possible players from " + country + " not yet selected:");
                        while (rs.next()) {
                            String num = rs.getString(1);
                            String pos = rs.getString(2);
                            System.out.println("Player number:  " + num + " is a  " + pos);
                        }
                    } catch (SQLException e) {
                        sqlCode = e.getErrorCode(); // Get SQLCODE
                        sqlState = e.getSQLState(); // Get SQLSTATE
                        // Your code to handle errors comes here;
                        // something more meaningful than a print would be good
                        System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                        System.out.println(e);
                    }

                    System.out.println("Enter number of player who's goal you want to update or [P] to go to the previous menu:");
                    String in = reader.nextLine();
                    if (in.equals("P"))
                        break;
                    else {
                        System.out.println("Enter the specific occurance of the goal: ");
                        String occur = reader.nextLine();
                        System.out.println("Enter the player's number for the new goal scorer: ");
                        String up = reader.nextLine();


                        // Updating Data of the table
                        try {
                            String insertSQL = "UPDATE GOALSSCORED\n" +
                                    "SET NUMBER="+up+"\n" +
                                    "WHERE NUMBER="+in+" AND OCCURANCE="+occur;
                            System.out.println(insertSQL);
                            statement.executeUpdate(insertSQL);
                        } catch (SQLException e) {
                            sqlCode = e.getErrorCode(); // Get SQLCODE
                            sqlState = e.getSQLState(); // Get SQLSTATE
                            // Your code to handle errors comes here;
                            // something more meaningful than a print would be good
                            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
                            System.out.println(e);
                        }
                    }
                    count++;
                }
            }
            if(input.equals("4")){
                break;
            }
        }
        // Finally but importantly close the statement and connection
        statement.close ( ) ;
        con.close ( ) ;
    }
}
