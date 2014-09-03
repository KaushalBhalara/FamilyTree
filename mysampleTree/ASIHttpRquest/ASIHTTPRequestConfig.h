//
//  ASIHTTPRequestConfig.h
//  Created by My Mac on 3/22/13.
//  Copyright (c) 2013 __Prajas Infoway__. All rights reserved.
//


#ifndef ASI_DEBUG_LOG
    #define ASI_DEBUG_LOG NSLog
#endif

// When set to 1 ASIHTTPRequests will print information about what a request is doing
#ifndef DEBUG_REQUEST_STATUS
	#define DEBUG_REQUEST_STATUS 0
#endif

// When set to 1, ASIFormDataRequests will print information about the request body to the console
#ifndef DEBUG_FORM_DATA_REQUEST
	#define DEBUG_FORM_DATA_REQUEST 0
#endif

// When set to 1, ASIHTTPRequests will print information about bandwidth throttling to the console
#ifndef DEBUG_THROTTLING
	#define DEBUG_THROTTLING 0
#endif

// When set to 1, ASIHTTPRequests will print information about persistent connections to the console
#ifndef DEBUG_PERSISTENT_CONNECTIONS
	#define DEBUG_PERSISTENT_CONNECTIONS 0
#endif

// When set to 1, ASIHTTPRequests will print information about HTTP authentication (Basic, Digest or NTLM) to the console
#ifndef DEBUG_HTTP_AUTHENTICATION
    #define DEBUG_HTTP_AUTHENTICATION 0
#endif
