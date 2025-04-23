*Last edited: JM (June 16, 2024)*
version 18
set more off, permanently
ssc install fre, replace

*******************************************************
*******************************************************
*****Syntax analyses affirmative action ***************
*******************************************************
*******************************************************

use "working_data.dta", clear

cd ""

global controls "gender i.employment edu logincome i.age urban migrationbackground" // n = 2,429
egen missingcontrols = rowmiss(urban migrationbackground employment edu logincome age gender)
fre missingcontrols // n = 363

* Table 1: 
summ $controls antiimmigrant everyday treatment percep_inc percep_opp belief_succ belief_work affirmative

*** Model 1a-I
regress percep_inc i.treatment // ns
estimates store Model1AI

*** Model 1a-II
regress percep_opp i.treatment // ***
estimates store Model1AII

*** Model 1b-I
regress belief_succ i.treatment // ns
estimates store Model1BI

*** Model 1b-II
regress belief_work i.treatment // ns
estimates store Model1BII

*** Model 1c
regress affirmative i.treatment // **
estimates store Model1C

etable, estimates(Model1AI Model1AII Model1BI Model1BII Model1C) mstat(N)  showstars showstarsnote title("Table 1. Direct treatment effects") export(model.docx, replace) // export results

*** Model 2a-I
regress percep_inc i.treatment##c.everyday antiimmigrant $controls
estimates store Model2AI
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic income disparities", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2AI.gph, replace
graph export graph2AI.png, replace

*** Model 2a-II
regress percep_opp i.treatment##c.everyday antiimmigrant $controls 
estimates store Model2AII
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic inequality of opportunity", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-0 1.2) axis(1)) ylabel("", axis(2)) ylabel(-0(.2)1.2) ymtick(-0(.1)1.2) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2AII.gph, replace
graph export graph2AII.png, replace

*** Model 2b-I
regress belief_succ i.treatment##c.everyday antiimmigrant $controls
estimates store Model2BI
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that success is meritocratic", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2BI.gph, replace
graph export graph2BI.png, replace

*** Model 2b-II
regress belief_work i.treatment##c.everyday antiimmigrant $controls
estimates store Model2BII
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that minorities don't work hard", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2BII.gph, replace
graph export graph2BII.png, replace

*** Model 2c
regress affirmative i.treatment##c.everyday antiimmigrant $controls
estimates store Model2C
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Support for affirmative action", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2C.gph, replace
graph export graph2C.png, replace

graph combine graph2AI.gph graph2AII.gph graph2BI.gph graph2BII.gph graph2C.gph, graphregion(color(white)) b1title("Everyday interactions with people with a migration background", size(small)) l1title("Marginal effect of the informational treatment", size(small)) holes(3)
graph save 2combined.pgh, replace
graph export 2combined.png, replace

outreg2 [Model2AI Model2AII Model2BI Model2BII Model2C] using "TableA1", excel replace stats(coef se pval) level(95) sideway label alpha(0.001, 0.01, 0.05) dec(2) title("TableA1")

