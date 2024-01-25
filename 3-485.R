library(httr)
library(httr2)
library(jsonlite)
library(rvest)

load("demo_data/i485_id.rda")

case_id <- 
i485_id

result <- vector("list", length(case_id))
names(result) <- case_id

for(i in 1:length(case_id)){
    temp_case_id = case_id[i]
    cat(i, " ")
url <- paste0("https://www.casestatusext.com/cases/", temp_case_id)
page_data <- 
tryCatch(read_html(url), error = function(e) NULL)

if(is.null(page_data)){
    next()
}

case_type = 
page_data %>%
html_nodes(".ant-descriptions-view")  %>% 
html_table()

if(length(case_type) == 0){
    next()
}

case_type = 
as.data.frame(case_type[[1]])[1,6]

cat(case_type, " ")

if(case_type != "I-485"){
    next()
}

final_result <- 
page_data %>% 
html_nodes(".ant-timeline-item-left")  %>% 
html_text()  %>% 
lapply(function(x){
    time = stringr::str_extract(x, "[0-9]{4}-[0-9]{2}-[0-9]{2}")
    action = stringr::str_replace(x, "[0-9]{4}-[0-9]{2}-[0-9]{2}", "")
    data.frame(time, action)
})  %>% 
do.call(rbind, .)  %>% 
as.data.frame()

cat(tail(final_result$time, 1), "\n")

result[[temp_case_id]] <- final_result

}

result2024_1_24 <- result
save(result2024_1_24, file = "demo_data/result2024_1_24.rda")


result2024_1_24  %>% 
lapply(function(x){
    tail(x$time, 1) == "2023-01-23"
})


crp_idx <- 
lapply(result2024_1_24, function(x){
     any(x$action == "Case Remains Pending")
})   %>% 
unlist()  %>% 
which() 


result2024_1_24[crp_idx]  %>% 
lapply(function(x){
    tail(x$action, 1)
})  %>% 
unlist()  %>% 
table()
