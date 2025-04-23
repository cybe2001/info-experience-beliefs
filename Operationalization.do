*Last ediedt: JM (June 16, 2024)*
version 18
set more off, permanently
ssc install fre, replace

*******************************************************
*******************************************************
*****Syntax operationalization ethnic profiling *******
*******************************************************
*******************************************************

use "L_positie_minderheden_1.0p.dta", clear 

cd ""

numlabel, add

** Merge main data with data on time spent on stimulus
* The 26 respondents in the main dataset who are not in dataset on time spent did not reach the stimulus
* n(merged) = 5,183
sort nomem_encr
merge 1:1 nomem_encr using "Time spent on stimulus.dta" 

* drop respondents who saw stimulus for different experiment
tab random, m
drop if random==2
tab random, m // n = 3,475

* drop respondents who spent less than 15 seconds on time spent on stimulus and those with missing values (because they did not see the stimulus)
drop if total_viewtime==. // n = 15
drop if total_viewtime<15 // n = 668 
* n(passed) = 2,792
 
*** Operationalize dependent variables

** Perceptions of ethnic inequalities 
* Perception of ethnic income inequality
tab percep_2, m
clonevar percep_inc = percep_2
label variable percep_inc "Perception of ethnic income inequality"
tab percep_inc, m
* Perception of ethnic inequality of opportunity
tab percep_1, m
recode percep_1 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (.=.), gen(percep_opp)
label variable percep_opp "Perception of ethnic inequality of opportunity"
tab percep_1 percep_opp

** Meritocratic explanations of inequality
* Belief that people make their own succes
tab verkl_1, m
clonevar belief_succ = verkl_1
label variable belief_succ "Belief that success is meritocratic"
tab belief_succ, m
* Belief that people with a migration background do not work as hard
tab verkl_2, m
clonevar belief_work = verkl_2
label variable belief_work "Belief that people with a migration background do not work as hard"
tab belief_work, m

** Support for affirmative action
* It is just reliable enough with 4 items, but item 4 clearly does not fit into the scale (as is also indicated by the factor analysis)
* With item 4 included the alpha is 0.63, without item 4 the alpha is 0.81
* Without 'asis' as an option, the reliability analysis even assumes that the direction of item 4 is reversed (although I already reverse-coded it)
* I propose that we deviate from the pre-registration and proceed with 3 items, because we have good reason for this (it makes a lot more sense)
tab beleid_et_1, m
tab beleid_et_2, m
tab beleid_et_3, m
tab beleid_et_4, m

corr beleid_et_1 beleid_et_2 beleid_et_3 beleid_et_4

alpha beleid_et_1 beleid_et_2 beleid_et_3

egen affirmative_missings = rowmiss(beleid_et_1 beleid_et_2 beleid_et_3)
tab affirmative_missings, m

egen affirmative = rowmean(beleid_et_1 beleid_et_2 beleid_et_3) if affirmative_missings<1
label variable affirmative "Support for affirmative action"
tab affirmative, m

*** Operationalize independent variable

** Treatment
fre random
recode random (3=0), gen(treatment)
la de treatment 0 "Control" 1 "Treatment"
la val treatment treatment 
fre treatment

*** Operationalize moderator

** Everyday interactions with people with a migration background

* reliability (0.91)
factor mind_gspr mind_kennis mind_vriend, pcf
alpha mind_gspr mind_kennis mind_vriend

egen everyday_missings = rowmiss(mind_gspr mind_kennis mind_vriend)
tab everyday_missings, m // n = 0

egen everyday = rowmean(mind_gspr mind_kennis mind_vriend) if everyday_missings<1
label variable everyday "Everyday interactions with people with a migration background"
tab everyday, m

*** Operationalize controls

** Anti-immigrant attitudes

* reverse code first two items
recode etnocentr1 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (.=.), gen(etnocentr1_R)
tab etnocentr1 etnocentr1_R, m
pwcorr etnocentr1 etnocentr1_R

recode etnocentr2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (.=.), gen(etnocentr2_R)
tab etnocentr2 etnocentr2_R, m
pwcorr etnocentr2 etnocentr2_R

* reliability (0.81)
factor etnocentr1_R etnocentr2_R etnocentr3 etnocentr4, pcf
alpha etnocentr1_R etnocentr2_R etnocentr3 etnocentr4

egen antiimmigrant_missings = rowmiss(etnocentr1_R etnocentr2_R etnocentr3 etnocentr4)
tab antiimmigrant_missings, m // n = 0

egen antiimmigrant = rowmean(etnocentr1_R etnocentr2_R etnocentr3 etnocentr4) if antiimmigrant_missings<1
label variable antiimmigrant "Anti-immigrant attitudes"
tab antiimmigrant, m

**Age (missing = 0)
tab leeftijd, m
recode leeftijd (18/27=1) (28/37=2) (38/47=3) (48/57=4) (58/999=5), gen(age)
label variable age "Age (in categories)"
label define agecats 1 "18-27 years" 2 "28-37 years" 3 "38-47 years" 4 "48-57 years" 5 "58 and older"
label values age agecats
tab age leeftijd, m
fre age

** Gender (male) (missing = 0)
tab geslacht, m
recode geslacht (1=1) (2=0) (3=0), gen(gender)
label variable gender  "Gender (male)"
label define gendercats 0 "Not male" 1 "Male"
label values gender gendercats
tab gender geslacht, m

** Income (missing = 219)
su nettohh_f
fre nettohh_f
clonevar income = nettohh_f
* no respondents with incomes of 100,000 or more
tab nettohh_f if nettohh_f>=100000

gen logincome = log(income)
label variable logincome "Net household income (log)"
tab logincome, m
hist logincome

** Education (missing = 163)
tab oplmet, m
recode oplmet (1=8) (2=12) (3=13.5) (4=14) (5=17) (6=18) (7/9=.), generate(edu)
label variable edu "Education in years (years needed to attain highest attained level of education)"
tab oplmet edu, m

** Employment (missing = 0)
tab belbezig, m
recode belbezig (1/2=1) (3=2) (4/6=3) (11/13=3) (10=4) (8=5) (7=6) (9=7) (14=6), gen(employment)
label variable employment "Employment"
label define employmentvalues 1 "employed" 2 "self-employed" 3 "unemployed" 4 "disabled" 5 "homemaker" 6 "student" 7 "retired"
label values employment employmentvalues
tab belbezig employment, m

** Migration background (missing = 51)
tab herkomstgroep, m
recode herkomstgroep (101 102 201 202 = 1) (.=.), generate(migrationbackground)
label define migrationcats 0 "No migration background" 1 "Migration background"
label values migrationbackground migrationcats
label variable migrationbackground "Migration background"
tab herkomstgroep migrationbackground, m
fre migrationbackground

** Urbanization (missing = 8)
tab sted, m
recode sted (1=5) (2=4) (3=3) (4=2) (5=1), generate(urbanization)
label variable urbanization "Urbanization"
la de urban 1 "Non-urban" 2 "Slightly urban" 3 "Moderately urban" 4 "Strongly urban" 5 "Highly urban"
la val urban urban 
tab sted urbanization, m
fre urban

*** Table with descriptives
su percep_inc percep_opp belief_succ belief_work affirmative everyday antiimmigrant i.age i.gender logincome edu i.employment i.migrationbackground urbanization
dtable percep_inc percep_opp belief_succ belief_work affirmative everyday antiimmigrant i.age i.gender logincome edu i.employment i.migrationbackground urbanization, continuous(,statistics(count mean sd min max)) factor(, statistics(fvfrequency fvproportion)) export("descriptive_statistics.docx", replace)

global controls "urban migrationbackground treatment i.employment edu logincome age gender"
sum $controls

***Save data with new name
save "working_data.dta", replace