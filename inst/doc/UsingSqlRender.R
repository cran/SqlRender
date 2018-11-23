## ---- echo = FALSE, message = FALSE--------------------------------------
library(SqlRender)
knitr::opts_chunk$set(
  cache = FALSE,
  comment = "#>",
  error = FALSE,
  tidy = FALSE)

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM table WHERE id = @a;"
renderSql(sql, a=123)$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM @x WHERE id = @a;"
renderSql(sql, x="my_table", a=123)$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM table WHERE id IN (@a);"
renderSql(sql,a = c(1,2,3))$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "{DEFAULT @a = 1} SELECT * FROM table WHERE id = @a;"
renderSql(sql)$sql
renderSql(sql,a=2)$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "{DEFAULT @a = 1} {DEFAULT @x = 'my_table'} SELECT * FROM @x WHERE id = @a;"
renderSql(sql)$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM table {@x} ? {WHERE id = 1}"
renderSql(sql,x = FALSE)$sql
renderSql(sql,x = TRUE)$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM table {@x == 1} ? {WHERE id = 1};"
renderSql(sql,x = 1)$sql
renderSql(sql,x = 2)$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM table {@x IN (1,2,3)} ? {WHERE id = 1};"
renderSql(sql,x = 2)$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM table {@x IN (1,2,3) | @y != 3} ? {WHERE id = @x AND value = @y};"
renderSql(sql,x = 4, y = 4)$sql

sql <- "SELECT * FROM table {(@x == 1 | @x == 3) & @y != 3} ? {WHERE id = @x AND val = @y};"
renderSql(sql,x = 3, y = 4)$sql


## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT DATEDIFF(dd,a,b) FROM table; "
translateSql(sql,targetDialect = "oracle")$sql

## ----echo=FALSE----------------------------------------------------------
funs <- c("ABS", "ACOS", "ASIN", "ATAN", "AVG", "CAST", "CEILING", "CHARINDEX", "CONCAT", "COS", "COUNT", "COUNT_BIG", "DATEADD", "DATEDIFF", "DATEFROMPARTS", "DATETIMEFROMPARTS", "DAY", "EOMONTH", "EXP", "FLOOR", "GETDATE", "HASHBYTES*", "ISNULL", "ISNUMERIC", "LEFT", "LEN", "LOG", "LOG10", "LOWER", "LTRIM", "MAX", "MIN", "MONTH", "NEWID", "PI", "POWER", "RAND", "RANK", "RIGHT", "ROUND", "ROW_NUMBER", "RTRIM", "SIN", "SQRT", "SQUARE", "STDEV", "SUM", "TAN", "UPPER", "VAR", "YEAR", "")


knitr::kable(matrix(funs, ncol = 4), col.names = rep("Function",4), caption = "Functions supported by translateSql")

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
sql <- "SELECT * FROM #children;"
translateSql(sql, targetDialect = "oracle", oracleTempSchema = "temp_schema")$sql

## ----tidy=TRUE,echo=TRUE-------------------------------------------------
foo <- function(databaseSchema, dbms) {
  database <- strsplit(databaseSchema ,"\\.")[[1]][1]
  sql <- "SELECT * FROM @databaseSchema.person; USE @database; SELECT * FROM person;"
  sql <- renderSql(sql, databaseSchema = databaseSchema, database = database)$sql
  sql <- translateSql(sql, targetDialect = dbms)$sql
  return(sql)
}
foo("cdm_data.dbo", "sql server")
foo("cdm_data", "postgresql")

## ----tidy=TRUE,eval=FALSE------------------------------------------------
#  launchSqlRenderDeveloper()

## ----tidy=TRUE,eval=FALSE------------------------------------------------
#  translateSqlFile("parameterizedSql.txt","renderedSql.txt")

## ----eval=FALSE----------------------------------------------------------
#  createRWrapperForSql(sqlFilename = "test.sql",
#                       rFilename = "test.R",
#                       packageName = "myPackage")

## ----tidy=TRUE,eval=FALSE------------------------------------------------
#  #' Todo: add title
#  #'
#  #' @description
#  #' Todo: add description
#  #'
#  #' @details
#  #' Todo: add details
#  #'
#  #' @param connectionDetails   An R object of type \code{ConnectionDetails} created ...
#  #' @param selectedValue
#  #'
#  #' @export
#  test <- function(connectionDetails,
#                          selectedValue = 1) {
#    renderedSql <- loadRenderTranslateSql("test.txt",
#                packageName = "myPackage",
#                dbms = connectionDetails$dbms,
#                selected_value = selectedValue)
#    conn <- connect(connectionDetails)
#  
#    writeLines("Executing multiple queries. This could take a while")
#    executeSql(conn,renderedSql)
#    writeLines("Done")
#  
#    dummy <- dbDisconnect(conn)
#  }
#  

