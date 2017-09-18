#include "dqrSender.h"

Client::Client() {
    // setup variables
    buflen_ = 1024;
    buf_ = new char[buflen_+1];
	
	socket_name_ = "/tmp/unix-socket";
}

Client::~Client() {
}

void Client::create() {
	struct sockaddr_un server_addr;

    // setup socket address structure
    bzero(&server_addr,sizeof(server_addr));
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path,socket_name_,sizeof(server_addr.sun_path) - 1);

    // create socket
    server_ = socket(PF_UNIX,SOCK_STREAM,0);
    if (!server_) {
        perror("[Sender] Cannot create socket");
        exit(-1);
    }

    // connect to server
    if (connect(server_,(const struct sockaddr *)&server_addr,sizeof(server_addr)) < 0) {
        perror("[Sender] Cannot connect to listener");
        exit(-1);
    }
}

void Client::close_socket() {}

void Client::send_message(string msg) {
	if (msg != "") {
		int count = 0;
		bool sent_ok, success = false;
		string response = "";

		msg += REQUEST_STREAM_END;

		while ( !success && count < MAX_SEND_RETRIES ) {
			sent_ok = send_request(msg);
			if (!sent_ok) {
				printf("[Sender] Error while sendind request\n");
			} else {
				success = get_response(response);
			}
			count++;
		}
		if (success)
			printf("%s",response.c_str());
		else
			printf("[Sender] Error detected while sending message to device\n");
	}
	
	close_socket();
}

string Client::parse_args(int argc, char ** argv) {

	string msg = "";
	bool valid = false;
	if (argc == 3 && strcmp(argv[1],S_REQUEST_COD) == 0) {
		valid = isNumber(argv[2]);
		msg = S_REQUEST_MSG + std::string(" ");
		msg += argv[2];
	}
	if ( argc == 6 && strcmp(argv[1],A_REQUEST_COD) == 0 && 
		( strcmp(argv[4],STATE_ON) == 0 || strcmp(argv[4],STATE_OFF) == 0) && (strcmp(argv[5],OVERRIDE_ON) == 0 || strcmp(argv[5],OVERRIDE_OFF) == 0) ) {
		valid = isNumber(argv[2]) && isNumber(argv[3]);
		msg = A_REQUEST_MSG + std::string(" ");
		msg += argv[2] + std::string(" ");
		msg += argv[3] + std::string(" ");
		msg += argv[4] + std::string(" ");
		msg += argv[5];
	}
	if (!valid) {
		perror("[Sender] Invalid arguments!\n");
		show_help();
		exit(1);
	}
	return msg;
}

bool Client::send_request(string request) {
    // prepare to send request
    const char* ptr = request.c_str();
    int nleft = request.length();
    int nwritten;
    // loop to be sure it is all sent
    while (nleft) {
        if ((nwritten = send(server_, ptr, nleft, 0)) < 0) {
            if (errno == EINTR) {
                // the socket call was interrupted -- try again
                continue;
            } else {
                // an error occurred, so break out
                perror("write");
                return false;
            }
        } else if (nwritten == 0) {
            // the socket is closed
            return false;
        }
        nleft -= nwritten;
        ptr += nwritten;
    }
    return true;
}

bool Client::get_response(string & response) {
    // read until we get a newline
    while (response.find(REQUEST_STREAM_END) == string::npos) {
        int nread = recv(server_,buf_,1024,0);
        if (nread < 0) {
            if (errno == EINTR)
                // the socket call was interrupted -- try again
                continue;
            else
                // an error occurred, so break out
                return false;
        } else if (nread == 0) {
            // the socket is closed
            return false;
        }
        // be sure to use append in case we have binary data
        response.append(buf_,nread);
    }
    // a better client would cut off anything after the newline and
    // save it in a cache
    return true;
}

void Client::show_help() {
	printf("Sender Execution help:\n");
	printf("# ./sender message_type device_id module_id desired_state\n");
	printf("  - message_type (S | A)\n");
	printf("  - device_id (positive integer)\n");
	printf("  - [module_id] (positive integer - only valid with type = A)\n");
	printf("  - [desired_state] (0 | 1 - only valid with type = A)\n");
	printf("  - [override] (0 | 1 - only valid with type = A)\n");
}

bool Client::isNumber(char * str) {
	for (unsigned int i=0;i<strlen(str);i++) {
		if (!isdigit(str[i]))
			return false;
	}
	return true;
}

/******* MAIN **********/
int main(int argc, char ** argv)
{
	/** Carga de operaciones temporal:
		argumentos del sender:
			- message_type: S | A
			- device_id: int
			- module_id: int		(solo con type = A)
			- desired_state: 0 | 1	(solo con type = A)
			- override: 0 | 1		(solo con type = A)
	**/
	
	Client client = Client();
	string msg = client.parse_args(argc,argv);
	client.create();
    client.send_message(msg);
}
