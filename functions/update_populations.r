# scrape wiki for country population
# scrape wiki for state population


update_country_pop <- function() {

	wiki_pop_url <- 'https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population#Sovereign_states_and_dependencies_by_population'
	wiki_pop_country <- wiki_pop_url %>%
	  rvest::html_session() %>%
	  rvest::html_nodes(xpath='//*[@id="mw-content-text"]/div/table') %>%
	  rvest::html_table()

	# Extract table from list object as DF
	pop_country <- as.data.frame( wiki_pop_country[[1]] )

	# Adjust column names and subset
	col_idx1 <- which( grepl('Country', names(pop_country) ) )
	names(pop_country)[col_idx1] <- 'Country'
	col_idx2 <- which( grepl('Population', names(pop_country) ) )
	names(pop_country)[col_idx2] <- 'Population'
	pop_country <- pop_country[,c(col_idx1, col_idx2)]

	# Convery character population to numeric
	pop_country[, 'Population'] <- as.numeric(gsub(",", "", pop_country[, 'Population']) )

	# Drop row with sum
	world_pop <- pop_country[nrow(pop_country), 'Population']
	pop_country <- pop_country[-nrow(pop_country),]

	save( pop_country, file = './data/pop_country.RData' )

	return( pop_country )

}



update_state_pop <- function() {

	wiki_pop_url2 <- 'https://simple.wikipedia.org/wiki/List_of_U.S._states_by_population'

	pop_state <- wiki_pop_url2 %>%
	  rvest::html_session() %>%
	  rvest::html_nodes(xpath='//*[@id="mw-content-text"]/div/table[1]') %>%
	  rvest::html_table()
	pop_state <- pop_state[[1]]


	pop_idx <- which( grepl("Population estimate", colnames(pop_state) ) ) 
	st_idx  <- which( grepl("State", colnames(pop_state) ) ) 

	pop_state <- pop_state[1:56, c(st_idx, pop_idx)]
	colnames(pop_state)[2] <- 'Population'

	pop_state[,'Population'] <- as.numeric(gsub(",", "", pop_state[, 'Population']) )

	# Check matches against base R state list
	state_name_match <- table(state.name %in% pop_state$State)[[TRUE]] == length(state.name)
	if( !state_name_match ) { print('States are mismatched against base R list.') }

	save( pop_state, file = './data/pop_state.RData' )	

	return( pop_state )

}



  
  
  

