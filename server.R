objList <- data.frame(cbind(c(1),c(1),c(1)))
names(objList) <- c("ObjectName","NBytes","ObjectClass")

otpServer <- function(nclnt, p) {
    con_list <- vector("list", nclnt)

    if(nclnt < 1) {
        print("Invalid nclnt argument")
        return
    }

    for(i in 1:nclnt) {
        con_list[[i]] <- socketConnection(host="localhost", port=p,
                                          blocking=TRUE, server=TRUE)
    }


    while(TRUE) {
        if(length(con_list) == 0) break

        i <- 1 # index counter
        for(con in con_list) {
            data <- unserialize(con)

            print(data)
            if(data == "exit") {
                close(con)
                con_list[[i]] <- NULL
                break
            }
            if(data=="ol") {
                writeLines("Received request for object list", con)
                next
            }

            i <- i+1
        }
    }
}

otpServer(1,6011)
