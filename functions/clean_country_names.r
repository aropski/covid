# Compare country names between jhu and wiki



clean_country_names <- function(master_data, pop_country) {

	cn_jhu_raw  <- master_data[, 'Country']
	cn_wiki_raw <- pop_country[, 'Country']

	### filter wiki strings ###

	# drop after brackets and parantheses
	cn_wiki <- gsub("[\\[\\(,].*","", cn_wiki_raw)
	# remove leading/trailing whitespace
	cn_wiki <- gsub("^\\s+|\\s+$", "", cn_wiki)

	# drop after brackets and parantheses
	cn_jhu <- gsub("[\\*\\[\\(,].*","", cn_jhu_raw)
	# remove leading/trailing whitespace
	cn_jhu <- gsub("^\\s+|\\s+$", "", cn_jhu)
	cn_jhu <- gsub("Republic of |Republic of the ", "", cn_jhu)
	cn_jhu <- gsub(" SAR", "", cn_jhu)
	cn_jhu <- gsub("^The ", "", cn_jhu)


	### direct subs
	cn_wiki[ which( cn_wiki == 'United States' ) ]  <- 'US'
	cn_jhu[  which( cn_jhu  == 'United States' ) ]  <- 'US'
	cn_jhu[  which( cn_jhu  == 'UK' ) ]             <- 'United Kingdom'
	cn_jhu[  which( cn_jhu  == 'Viet Nam' ) ]       <- 'Vietnam'
	cn_jhu[  which( cn_jhu  == 'Mainland China' ) ] <- 'China'


	# which countries are perfect matches
	# must perform against unique
	#cn_pmatch <- cn_wiki[ cn_wiki %in% cn_jhu ]

	master_data[, 'Country'] <- cn_jhu
    pop_country[, 'Country'] <- cn_wiki
	
	return(list(master_data=master_data, pop_country=pop_country))

}


