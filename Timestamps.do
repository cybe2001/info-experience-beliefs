*Last edited: JM (June 16, 2024)*
version 18
set more off, permanently

*******************************************************
*******************************************************
*****Syntax timestamps affirmative action**************
*******************************************************
*******************************************************

use "L_positie_minderheden_timestamps_stimulus_1.0p.dta", clear

cd ""

** Some respondents have multiple entries for the time they spent on the page with the stimulus (variable "difference")
** This code combines these, resulting in a single entry for each respondent, adding up the time spent on the pages with the stimulus

* how many unique respondents in dataset: 5183 (out of 5545 entries). Note that number of unique respondents is smaller dan in main dataset, because respondents who did not make it to stimulus page are not include in timestamps data (see email d.d. May 18 2024)
clonevar respondent_id = nomem_encr
egen unique_id = tag(respondent_id)
tab unique_id, m
count if unique_id == 1

* combine values for same respondents
clonevar view_time = difference
replace view_time = 0 if missing(view_time)
sort respondent_id
bysort respondent_id: egen total_viewtime=total(view_time)
su total_viewtime
bysort respondent_id: keep if _n==1
su total_viewtime


* create dataset to merge with main data
keep nomem_encr total_viewtime

* sort (in preparation for merge)

sort nomem_encr

*Save data with new name
save "Time spent on stimulus.dta", replace