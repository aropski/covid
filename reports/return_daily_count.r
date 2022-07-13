return_daily_count <- function( in_data ) {

	# most recent
	newest_date <- max(in_data$Update)
	out_data <- in_data[in_data$Update == newest_date, ]

	return( out_data ) 

}