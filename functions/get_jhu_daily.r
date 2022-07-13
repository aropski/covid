get_jhu_daily <- function( in_date ) {

	date_url <- format( in_date, "%m-%d-%Y")
	x <-  RCurl::getURL( paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/", date_url, ".csv") )

	if( x == "404: Not Found") {
		return(NULL)
	} else {
		y <- read.csv( text = x, stringsAsFactors = F )
		return( y )
	}
	
}
