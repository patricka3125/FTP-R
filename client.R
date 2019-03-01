otpClient <- function(h, p) {
    con <- socketConnection(host=h, port=p, blocking=TRUE, server=FALSE)

    while(TRUE) {
        cat("#otp ")

        f <- file("stdin")
        buf <- readLines(f,n=1)

        writeLines(buf, con)
        #serialize(buf,con)
        if(buf=="exit") {
            break
        }

        resp <- readLines(con)
        print(resp)

        # Tokenize input buffer, return a vector 
        #input <- strsplit(buf, " ")[[1]]
        #cmd <- input[1]
        #obj <- input[2]
    }

    close(con)
}

otpClient("localhost",6011)
