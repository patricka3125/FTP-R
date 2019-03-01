library(Rdsm)
library(snow)

objList <- data.frame(cbind(c(1),c(1),c(1)))
names(objList) <- c("ObjectName","NBytes","ObjectClass")

ftp_connect <- function(p, con_list, id) {
    con_list[[id]]

    #while(TRUE) {
    #    req <- readLines(con,1)
    #    print(req)
    #    resp <- writeLines(req, con)

    #    if(req == "exit") {
    #        break
    #    }
    #    if(req == "ol") {
    #        writeLines("Received request for object list", con)
    #        next
    #    }
    #}

   # close(con_list[[id]])
}

otpServer <- function(nclnt, p) {
    if(nclnt < 1) {
        print("Invalid nclnt argument")
        return
    }

    con_list <- vector("list", nclnt)
    for(i in 1:nclnt) {
        con_list[[i]] <- socketConnection(host="localhost", port=p,
                                          blocking=TRUE, server=TRUE)
    }

    if(nclnt == 1) {
        ftp_connect(p, con_list, 1)
    }else {
        cluster <- makeCluster(nclnt)
        mgrinit(cluster)
        clusterExport(cluster, "ftp_connect")
        clusterExport(cluster, "p", envir=environment())
        clusterExport(cluster, "con_list", envir=environment())
        clusterEvalQ(cluster, ftp_connect(p,con_list, myinfo$id))
    }
}

otpServer(2,6011)
