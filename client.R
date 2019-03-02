otpClient <- function(h, p) {
    con <- socketConnection(host=h, port=p, blocking=TRUE, server=FALSE)

    while(TRUE) {
        cat("#otp ")

        f <- file("stdin")
        buf <- readLines(f,n=1)
        serialize(buf, con)

        if(buf == "exit") {
            break
        }
        if(buf == "get") {
            print("Object to get: ")
            buf <- readLines(f, n=1)
            serialize(buf, con)
        }else if(buf == "put") {
            print("Object to put : ")
            buf <- readLines(f, n=1)
            serialize(buf, con)
        }

        resp <- unserialize(con)

        if(resp=="exit") {
            break
        }
        
        print(resp)
    }

    close(con)
}

otpClient("localhost",6011)
