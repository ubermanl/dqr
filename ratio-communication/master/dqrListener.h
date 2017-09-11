#include <errno.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <signal.h>
#include <sys/un.h>

#include <string>

/*** Ratio IPC ***/
#include "dqrIPC.h"


using namespace std;

class Listener {
public:
    Listener();
    ~Listener();

	void setPipes(int *, int *);
    void run();
    
protected:
    void create();
    void close_socket();
    void serve();
    void handle(int);
    string get_request(int);
    bool send_response(int, string);
	bool isNumber(string &);
	bool parse_request(string, operation_t *);

    int _server;
    int _buflen;
    char * _buf;
	int _send_fd;
	int _receive_fd;
	
private:
	static void interrupt(int);
	static const char * _socket_name;
};