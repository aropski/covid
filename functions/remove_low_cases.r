
remove_low_cases <- function( in_data, min_cases ) {
	
	#print(unique(in_data$State))
	#print(unique(in_data$Country))
		
	first_qual_N <- which(in_data[,'Confirmed'] > min_cases)[1]
	
	if( is.na(first_qual_N) ) {
		return()
	} else {
		return( in_data[ first_qual_N:(nrow(in_data)),  ] )
	}
	
}
