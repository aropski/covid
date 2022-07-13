
#daily_w_state_pop( ds_7 )

daily_w_state_pop <- function( in_data, order_col = 'Confirmed' ) {

	
	in_data$inc_rate <- in_data[,'Population'] / in_data[, order_col]
	roi <- which(in_data$inc_rate == Inf)
	in_data$inc_rate[roi] <- NA
	
	# order by order_col
	out_data <- in_data[ order( in_data[,'inc_rate'], decreasing = T ), ]

	

	return( out_data )

}

