#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <stdexcept>
/* uncomment for applications that use vectors */
/*#include <vector>*/

#include "mysql_connection.h"
#include <mysql_driver.h>
#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

#define EXAMPLE_HOST "localhost"
#define EXAMPLE_USER "root"
#define EXAMPLE_PASS ""
#define EXAMPLE_DB "ecobici"

using namespace std;

int main(int argc, const char **argv)
{
  string url(argc >= 2 ? argv[1] : EXAMPLE_HOST);
  url = "tcp://" + url + ":3306";
  const string user(argc >= 3 ? argv[2] : EXAMPLE_USER);
  const string pass(argc >= 4 ? argv[3] : EXAMPLE_PASS);
  const string database(argc >= 5 ? argv[4] : EXAMPLE_DB);

  cout << "Connector/C++ tutorial framework..." << endl;
  cout << endl;

  sql::mysql::MySQL_Driver *driver;
  sql::Connection *con;
  sql::Statement *stmt;
  sql::ResultSet  *res;

  try {
	driver = sql::mysql::get_mysql_driver_instance();
	con = driver->connect(url, user, pass);
	con->setSchema(EXAMPLE_DB);
	
	stmt = con->createStatement();	
	
	stmt->execute("START TRANSACTION");
	
	stmt->execute("INSERT INTO estacion (nombre, fecha_alta) VALUES ('nombre1',NOW())");
	std::cin.ignore();
	stmt->execute("INSERT INTO estacion (nombre, fecha_alta) VALUES ('nombre1',NOW())");
	res = stmt->executeQuery("SELECT LAST_INSERT_ID()");
	res->next();
	cout << "last id: " << res->getInt(1) << endl;
	
	con->commit();
	/*
	res = stmt->executeQuery("SELECT id, nombre FROM estacion");
	while (res->next()) {
		// You can use either numeric offsets...
		cout << "id = " << res->getInt(1); // getInt(1) returns the first column
		// ... or column names for accessing results.
		// The latter is recommended.
		cout << ", nombre = '" << res->getString("nombre") << "'" << endl;
	}
	delete res;
	*/
	delete stmt;
	delete con;

  } catch (sql::SQLException &e) {
    /*
      MySQL Connector/C++ throws three different exceptions:

      - sql::MethodNotImplementedException (derived from sql::SQLException)
      - sql::InvalidArgumentException (derived from sql::SQLException)
      - sql::SQLException (derived from std::runtime_error)
    */
    cout << "# ERR: SQLException in " << __FILE__;
    cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
    /* what() (derived from std::runtime_error) fetches error message */
    cout << "# ERR: " << e.what();
    cout << " (MySQL error code: " << e.getErrorCode();
    cout << ", SQLState: " << e.getSQLState() << " )" << endl;

    return EXIT_FAILURE;
  }

  cout << "Done." << endl;
  return EXIT_SUCCESS;
}