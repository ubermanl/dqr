/*** Ratio IPC Protocol definitions & types ***/
#ifndef MESSAGING_PROTOCOL
#define MESSAGING_PROTOCOL
struct operation_t {
    int deviceId;
    int moduleId;
    char type;
    int desiredState;
};
#define REQUEST_STREAM_END "\n"
#define RESPONSE_OK "0"
#define RESPONSE_FAIL "1"
#define S_REQUEST_MSG "STATE_INFORMATION"
#define S_REQUEST_COD "S"
#define A_REQUEST_MSG "STATE_MODIFICATION"
#define A_REQUEST_COD "A"
#define STATE_ON "1"
#define STATE_OFF "0"
#endif