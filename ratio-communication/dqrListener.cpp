#include "dqrListener.h"

const char * Listener::_socket_name = "/tmp/unix-socket";

Listener::Listener() {
    // setup variables
    _buflen = 1024;
    _buf = new char[_buflen+1];

	// setup handler Control-C
    struct sigaction sigIntHandler;
    sigIntHandler.sa_handler = interrupt;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;
    sigaction(SIGINT, &sigIntHandler, NULL);
}

Listener::~Listener() {
    delete _buf;
}

void Listener::run() {
    // create and run the Listener
	printf("[Listener] Started\n");
    create();
    serve();
}

void Listener::create() {
	struct sockaddr_un server_addr;

    // setup socket address structure
    bzero(&server_addr,sizeof(server_addr));
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path,_socket_name,sizeof(server_addr.sun_path) - 1);
	unlink(_socket_name);
	
    // create socket
    _server = socket(PF_UNIX,SOCK_STREAM,0);
    if (!_server) {
        perror("[Listener] Cannot create socket");
        exit(-1);
    }

    // call bind to associate the socket with the UNIX file system
    if (bind(_server,(const struct sockaddr *)&server_addr,sizeof(server_addr)) < 0) {
        perror("[Listener] Cannot bind to socket");
        exit(-1);
    }

    // convert the socket to listen for incoming connections
    if (listen(_server,SOMAXCONN) < 0) {
        perror("[Listener] Cannot accept connections on socket");
        exit(-1);
    }
}

void Listener::close_socket() {
	unlink(_socket_name);
}

void Listener::interrupt(int) {
    unlink(_socket_name);
	exit(0);
}

void Listener::setPipes(int chi2par[2], int par2chi[2]) {
	// descriptors for IPC with parent process (mesh master)
    _send_fd = chi2par[1];
	_receive_fd = par2chi[0];
}

void Listener::serve() {
    // setup client
    int client;
    struct sockaddr_in client_addr;
    socklen_t clientlen = sizeof(client_addr);
	
    // accept clients
	printf("[Listener] Waiting for requests...\n");
    while ((client = accept(_server,(struct sockaddr *)&client_addr,&clientlen)) > 0) {
		printf("[Listener] Sender connected: %d\n", client);
        handle(client);
    }
    close_socket();
}

void Listener::handle(int client) {
    bool result_ok = true;
	operation_t operation;
	int response_from_master;
	string response_to_client;
	
	// get first request from client
	string request = get_request(client);
    while (!request.empty() && result_ok) {    		
		// Processing sender request
		if (parse_request(request,&operation)) {
			printf("[Listener] Received request: %s", request.c_str());
			write(_send_fd, &operation, sizeof(operation_t));
			
			// send response
			read(_receive_fd, &response_from_master, sizeof(response_from_master));
			if (response_from_master == 0)
				response_to_client = RESPONSE_OK;
			else
				response_to_client = RESPONSE_FAIL;
			response_to_client += REQUEST_STREAM_END;
			result_ok = send_response(client,response_to_client);
			
			// get next request to process
			if (result_ok)
				request = get_request(client);
		} else {
			printf("[Listener] Received Invalid request: %s", request.c_str());			
			result_ok = send_response(client,RESPONSE_FAIL + string(REQUEST_STREAM_END));
			
			// get next request to process
			if (result_ok)
				request = get_request(client);
		}
    }
    close(client);
}

string Listener::get_request(int client) {
    string request = "";
    // read until REQUEST_STREAM_END
    while (request.find(REQUEST_STREAM_END) == string::npos) {
        int nread = recv(client,_buf,1024,0);
        if (nread < 0) {
			// an error occurred...
            if (errno == EINTR)
                // retry when interrupted socket call
                continue;
            else
                return "";
        } else if (nread == 0) {
            // socket closed
            return "";
        }
        request.append(_buf,nread);
    }
    return request;
}

bool Listener::send_response(int client, string response) {
    const char* ptr = response.c_str();
    int nleft = response.length();
    int nwritten;

    while (nleft) {
        if ((nwritten = send(client, ptr, nleft, 0)) < 0) {
			// an error occurred...
            if (errno == EINTR) {
                // retry when interrupted socket call
                continue;
            } else {
                perror("[Listener] Socket write");
                return false;
            }
        } else if (nwritten == 0) {
            // socket closed
            return false;
        }
        nleft -= nwritten;
        ptr += nwritten;
    }
    return true;
}

bool Listener::parse_request(string str, operation_t * operation) {
	string delimiter = " ";
	string aux;
	
	// parsing request type and parameters
	string::size_type i = 0;
	string::size_type j = str.find(delimiter);
	aux = str.substr(i, j-i);
	if (aux == S_REQUEST_MSG) {
		// word #1 in request is type S
		operation->type = S_REQUEST_COD[0];
		i = ++j;
		aux = str.substr(i, str.length()-i-1);
		if (isNumber(aux) && atoi(aux.c_str()) > 0) {
			// word #2 in request is valid deviceId => request OK
			operation->deviceId = atoi(aux.c_str());
			return true;
		}
	} else if (aux == A_REQUEST_MSG) {
		// word #1 in request is type A
		operation->type = A_REQUEST_COD[0];
		i = ++j;
		j = str.find(delimiter, j);
		aux = str.substr(i, j-i);
		if (isNumber(aux)) {
			// word #2 in request is valid deviceId
			operation->deviceId = atoi(aux.c_str());
			i = ++j;
			j = str.find(delimiter, j);
			aux = str.substr(i, j-i);
			if (isNumber(aux)) {
				// word #3 in request is valid moduleId
				operation->moduleId = atoi(aux.c_str());
				i = ++j;
				j = str.find(delimiter, j);
				aux = str.substr(i, str.length()-i-1);
				if (aux == STATE_ON || aux == STATE_OFF) {
					// word #4 in request is valid state => request OK
					operation->desiredState = atoi(aux.c_str());
					return true;
				}
			}
		}
	}
	
	return false;
}

bool Listener::isNumber(string & str) {
	for (int i=0;i<str.length();i++) {
		if (!isdigit(str.at(i)))
			return false;
	}
	return true;
}
