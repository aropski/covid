# add daily difference (continuous)
compute_daily_diff <- function(in_data, app_colnames, level) { 

	#print(unique(in_data$State))
	#print(unique(in_data$Country))
	

	# Remove leading Confirmed==0
	roi <- which(in_data$Confirmed > 1)[1]
	in_data <- in_data[roi:nrow(in_data),]

	# enforce order
	in_data <- in_data[order(in_data$Update), ]

	# check for missing days
	first_date <- min( in_data$Update )
	last_date  <- max( in_data$Update )
	
	# match against range
	dr1_len <-  length( seq(first_date, last_date, 1) )
	dr2_len <-  length( in_data$Update )

	# check same numbers of dates
	if( dr1_len == dr2_len ) {
	
		# check that dates are identical
		date_match <-  all( seq(first_date, last_date, 1) == in_data$Update )
		if( !date_match ) {
			print('ERROR_2: func2 is missing dates')
			return('ERROR_2: func2 is missing dates')
		}
		
	} else {
	
		tmp1 <- seq(first_date, last_date, 1)
		tmp2 <- in_data$Update 
		doi  <- tmp1[!tmp1%in%tmp2]
	
		roi <- which( tmp2 == (doi+1) )


		if( length(roi) == 1 ) {
		
			in_data <- in_data[doi:nrow(in_data),]
		
		} else {
		
			# different number of dates exist
			print('ERROR_1: func2 is missing dates')
			#print(unique(in_data$FIPS))
			#print( dr1_len[!dr1_len %in% dr2_len] )
			return('ERROR_1: func2 is missing dates')
		}
	
	}

	# Compute differences
	
	case_diff <- in_data[, app_colnames] - shift(in_data[, app_colnames])
	diff_data <- cbind(in_data[,c('Update',level)], case_diff)
	
	# Drop 1st row NA for shifting, drop total
	return( diff_data[-1, ])
	
}
