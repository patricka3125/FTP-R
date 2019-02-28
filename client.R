otpClient <- function(h, p) {
    con <- socketConnection(host=h, port=p, blocking=TRUE, server=FALSE)

    while(TRUE) {
        cat("#otp ")

        f <- file("stdin")
        buf <- readLines(f,n=1)

        serialize(buf,con)
        if(buf=="exit") {
            break
        }

        # Tokenize input buffer, return a vector 
        # TODO: Account for invalid inputs
        input <- strsplit(buf, " ")[[1]]
        cmd <- input[1]
        obj <- input[2]
    }

    close(con)
}

otpClient("localhost",6011)
