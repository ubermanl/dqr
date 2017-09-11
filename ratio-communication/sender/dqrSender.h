#include <errno.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/un.h>

#include <fstream>
#include <iostream>
#include <string>

/*** Ratio IPC ***/
#include "dqrIPC.h"


using namespace std;

class Client {
public:
    Client();
    ~Client();

    void create();
	void send_message(string);
	string parse_args(int, char **);

protected:

    void close_socket();
    bool send_request(string);
    bool get_response();
	void show_help();
	bool isNumber(char *);

    int server_;
    int buflen_;
    char* buf_;

private:
	const char* socket_name_;
}; 