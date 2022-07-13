
#Return last days increase
last_day_inc <- function(state_only) {

	doi <- max(state_only$Update)
	roi <- which( state_only$Update == doi )
	return( state_only[roi,-2] )

}