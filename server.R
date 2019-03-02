library(Rdsm)
library(snow)

objList <- data.frame(cbind(c(1),c(1),c(1)))
names(objList) <- c("ObjectName","NBytes","ObjectClass")

ftp_connect <- function(p, con_list, id) {
    con <- con_list[[id]]

    while(TRUE) {
        req <- unserialize(con)

        if(req == "exit") {
            serialize("exit",con)
            break
        }
        if(req == "ol") {
            serialize(objList, con)
        }else if(req == "get") {
            obj <- unserialize(con)
            response <- objList[which(objList$ObjectName == obj),]
            serialize(response,con)
        }else if(req == "put") {
            obj <- unserialize(con)
            
            objcl <- class(obj)
            print(objcl)

            df <- data.frame(cbind(c(obj), c(object.size(obj)), c(objcl)))
            names(df) <- c("ObjectName", "NBytes", "ObjectClass")
            objList <- rbind(objList, df)

            response <- "Added object to list"
            serialize(response, con)
        }
    }

    close(con)
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

otpServer(1,6011)
