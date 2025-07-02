*Last edit: JM (July 2, 2025)*
Stata version 18.5
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

*** Descriptives

** Table 1: Sample descriptives
summ $controls antiimmigrant everyday treatment percep_inc percep_opp belief_succ belief_work affirmative

** Table 2: Correlations
corr everyday antiimmigrant migrationbackground edu percep_inc percep_opp belief_succ belief_work affirmative 

*** Direct effects
** Model 1a-I
regress percep_inc i.treatment // ns
estimates store Model1AI
** Model 1a-II
regress percep_opp i.treatment // ***
estimates store Model1AII
** Model 1b-I
regress belief_succ i.treatment // ns
estimates store Model1BI
** Model 1b-II
regress belief_work i.treatment // ns
estimates store Model1BII
** Model 1c
regress affirmative i.treatment // **
estimates store Model1C

** Table 3: Direct treatment effects 
etable, estimates(Model1AI Model1AII Model1BI Model1BII Model1C) mstat(N)  showstars showstarsnote title("Table 1. Direct treatment effects") export(model.docx, replace) 

*** Conditional treatment effects 
** Model 2a-I
regress percep_inc i.treatment##c.everyday antiimmigrant $controls
estimates store Model2AI
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic income disparities", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2AI.gph, replace
graph export graph2AI.png, replace

** Model 2a-II
regress percep_opp i.treatment##c.everyday antiimmigrant $controls 
estimates store Model2AII
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic inequality of opportunity", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-0 1.2) axis(1)) ylabel("", axis(2)) ylabel(-0(.2)1.2) ymtick(-0(.1)1.2) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2AII.gph, replace
graph export graph2AII.png, replace

** Model 2b-I
regress belief_succ i.treatment##c.everyday antiimmigrant $controls
estimates store Model2BI
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that people make their own success", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2BI.gph, replace
graph export graph2BI.png, replace

** Model 2b-II
regress belief_work i.treatment##c.everyday antiimmigrant $controls
estimates store Model2BII
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that minorities work less hard", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2BII.gph, replace
graph export graph2BII.png, replace

** Model 2c
regress affirmative i.treatment##c.everyday antiimmigrant $controls
estimates store Model2C
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Support for affirmative action", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save graph2C.gph, replace
graph export graph2C.png, replace

** Figure 2: Moderated treatment effects
graph combine graph2AI.gph graph2AII.gph graph2BI.gph graph2BII.gph graph2C.gph, graphregion(color(white)) b1title("Everyday interactions with people with a migration background", size(small)) l1title("Marginal effect of treatment on linear prediction", size(small)) holes(3)
graph save 2combined.pgh, replace
graph export 2combined.png, replace

*** Robustness checks
** Check A. Manipulation check
gen check=.
recode check (.=1) if random==1 & mani==1 // n = 1165
recode check (.=0) if random==1 & mani==2 // n = 3
recode check (.=0) if random==1 & mani==3 // n = 68
recode check (.=0) if random==1 & mani==4 // n = 83
recode check (.=0) if random==1 & mani==999 // n = 52
recode check (.=0) if random==1 & mani==. // n = 9
disp 1165/1380 // 84.4% of participants in treatment condition passed manipulation check

** Rerunning conditional treatment effects
drop if random==1 & check==0 // drop participants in treatment condition who failed manipulation check

** Direct effects
regress percep_inc i.treatment 
estimates store Model1AI
regress percep_opp i.treatment 
estimates store Model1AII
regress belief_succ i.treatment
estimates store Model1BI
regress belief_work i.treatment
estimates store Model1BII
regress affirmative i.treatment
estimates store Model1C

** Table 5: Direct treatment effects, excluding participants in treatment group who failed manipulation check
etable, estimates(Model1AI Model1AII Model1BI Model1BII Model1C) mstat(N)  showstars showstarsnote title("Table 1. Direct treatment effects, excluding participants in treatment group who failed manipulation check") export(model.docx, replace) 

** Conditional effects
regress percep_inc i.treatment##c.everyday antiimmigrant $controls
estimates store mani2AI
regress percep_opp i.treatment##c.everyday antiimmigrant $controls 
estimates store mani2AII
regress belief_succ i.treatment##c.everyday antiimmigrant $controls
estimates store mani2BI
regress belief_work i.treatment##c.everyday antiimmigrant $controls
estimates store mani2BII
regress affirmative i.treatment##c.everyday antiimmigrant $controls
estimates store mani2C

** Table 6: Conditional treatment effects, excluding participants in treatment condition who failed manipulation check
etable, estimates(mani2AI mani2AII mani2BI mani2BII mani2C) mstat(N)  showstars showstarsnote title("Table 6. Conditional treatment effects (excluding participants in treatment condition who failed manipulation check)") export(mani.docx, replace) 

*** Visualization of conditional treatment effects 
regress percep_inc i.treatment##c.everyday antiimmigrant $controls
estimates store mani2AI
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic income disparities", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save mani2AI.gph, replace

regress percep_opp i.treatment##c.everyday antiimmigrant $controls 
estimates store mani2AII
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic inequality of opportunity", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-0 1.2) axis(1)) ylabel("", axis(2)) ylabel(-0(.2)1.2) ymtick(-0(.1)1.2) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save mani2AII.gph, replace

regress belief_succ i.treatment##c.everyday antiimmigrant $controls
estimates store mani2BI
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that people make their own success", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save mani2BI.gph, replace

regress belief_work i.treatment##c.everyday antiimmigrant $controls
estimates store mani2BII
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that minorities work less hard", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save mani2BII.gph, replace

regress affirmative i.treatment##c.everyday antiimmigrant $controls
estimates store mani2C
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Support for affirmative action", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save mani2C.gph, replace

** Figure 3: Visualization of the moderated treatment effects, excluding participants in the treatment condition who failed the manipulation check
graph combine mani2AI.gph mani2AII.gph mani2BI.gph mani2BII.gph mani2C.gph, graphregion(color(white)) b1title("Everyday interactions with people with a migration background", size(small)) l1title("Marginal effect of treatment on linear prediction", size(small)) holes(3)
graph save manicombined.pgh, replace
graph export manicombined.png, replace

use "G:\My Drive\Data\LISS Positie minderheden (2024)\Working data 2024-11-27.dta", clear // reload data

*** Check B. Respecification of main model
regress percep_inc i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
estimates store checkb1
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic income disparities", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkb1.gph, replace

regress percep_opp i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
estimates store checkb2
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic inequality of opportunity", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-0 1.2) axis(1)) ylabel("", axis(2)) ylabel(-0(.2)1.2) ymtick(-0(.1)1.2) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkb2.gph, replace

regress belief_succ i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
estimates store checkb3
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that people make their own success", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkb3.gph, replace

regress belief_work i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
estimates store checkb4
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that minorities work less hard", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkb4.gph, replace

regress affirmative i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
estimates store checkb5
margins, dydx(treatment) at(everyday=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Support for affirmative action", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram everyday, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkb5.gph, replace

** Table 7: Moderated treatment effects, respecified model 
etable, estimates(checkb1 checkb2 checkb3 checkb4 checkb5) mstat(N)  showstars showstarsnote title("Table x. Conditional treatment effects (respecification)") export(checkb.docx, replace) // export results

** Fig 4: Visualization of the moderated treatment effects, respecified model
graph combine checkb1.gph checkb2.gph checkb3.gph checkb4.gph checkb5.gph, graphregion(color(white)) b1title("Everyday interactions with people with a migration background", size(small)) l1title("Marginal effect of treatment on linear prediction", size(small)) holes(3)
graph save checkbcombined.pgh, replace
graph export checkbcombined.png, replace

*** Check C. Conditional treatment effects by anti-immigrant attitudes
regress percep_inc i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(antiimmigrant=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic income disparities", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram antiimmigrant, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkc1.gph, replace

regress percep_opp i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(antiimmigrant=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic inequality of opportunity", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram antiimmigrant, percent yscale(r(-0 1.2) axis(1)) ylabel("", axis(2)) ylabel(-0(.2)1.2) ymtick(-0(.1)1.2) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkc2.gph, replace

regress belief_succ i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(antiimmigrant=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that people make their own success", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram antiimmigrant, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkc3.gph, replace

regress belief_work i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(antiimmigrant=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that minorities work less hard", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram antiimmigrant, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkc4.gph, replace

regress affirmative i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(antiimmigrant=(1 (0.5) 7))
marginsplot, yline(0) graphregion(color(white)) title ("Support for affirmative action", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram antiimmigrant, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(1(1)7, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkc5.gph, replace

** Fig 5: Visualization of the moderated treatment effect by anti-immigration attitudes
graph combine checkc1.gph checkc2.gph checkc3.gph checkc4.gph checkc5.gph, graphregion(color(white)) b1title("Anti-immigrant attitudes", size(small)) l1title("Marginal effect of treatment on linear prediction", size(small)) holes(3)
graph save checkccombined.pgh, replace
graph export checkccombined.png, replace

*** Check D. Conditional treatment effects by migration background 
la de migrationbackground 0 "No" 1 "Yes", replace
la val migrationbackground migrationbackground 

regress percep_inc i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(migrationbackground=(0 1)) 
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic income disparities", size(med)) recast(scatter) plot1opt(msize(vlarge)) ci1opt(fcolor(none) lcolor(black) lpattern(solid)) ytitle(" ") legend(off) addplot(histogram migrationbackground, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(0(1)1, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40)) 
graph save checkd1.gph, replace

regress percep_opp i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(migrationbackground=(0 1)) 
marginsplot, yline(0) recast(scatter) graphregion(color(white)) title ("Perception of ethnic inequality of opportunity", size(medium)) plot1opt(msize(vlarge)) ci1opt(fcolor(none) lcolor(black) lpattern(solid)) ytitle(" ") legend(off) addplot(histogram migrationbackground, percent yscale(r(-0 1.2) axis(1)) ylabel("", axis(2)) ylabel(-0(.2)1.2) ymtick(-0(.1)1.2) xtitle(" ") xlabel(0(1)1, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkd2.gph, replace

regress belief_succ i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(migrationbackground=(0 1)) 
marginsplot, yline(0) graphregion(color(white)) title ("Belief that people make their own success", size(med)) recast(scatter) plot1opt(msize(vlarge)) ci1opt(fcolor(none) lcolor(black) lpattern(solid)) ytitle(" ") legend(off) addplot(histogram migrationbackground, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(0(1)1, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkd3.gph, replace

regress belief_work i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(migrationbackground=(0 1)) 
marginsplot, yline(0) graphregion(color(white)) title ("Belief that minorities work less hard", size(med)) recast(scatter) plot1opt(msize(vlarge)) ci1opt(fcolor(none) lcolor(black) lpattern(solid)) ytitle(" ") legend(off) addplot(histogram migrationbackground, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(0(1)1, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkd4.gph, replace

regress affirmative i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(migrationbackground=(0 1)) 
marginsplot, yline(0) graphregion(color(white)) title ("Support for affirmative action", size(med)) recast(scatter) plot1opt(msize(vlarge)) ci1opt(fcolor(none) lcolor(black) lpattern(solid)) ytitle(" ") legend(off) addplot(histogram migrationbackground, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(0(1)1, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40))
graph save checkd5.gph, replace

** Fig 6: Visualization of the moderated treatment effect by migration background
graph combine checkd1.gph checkd2.gph checkd3.gph checkd4.gph checkd5.gph, graphregion(color(white)) b1title("Migration background", size(small)) l1title("Marginal effect of treatment on linear prediction", size(small)) holes(3)
graph save checkdcombined.pgh, replace
graph export checkdcombined.png, replace

*** Check E. Conditional treatment effects by level of education
regress percep_inc i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(edu=(8 12 13.5 14 17 18))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic income disparities", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram edu, percent yscale(r(-.6 .7) axis(1)) ylabel("", axis(2)) ylabel(-0.6(0.2).6) ymtick(-.6(.1).6) xtitle(" ") xlabel(8(2)18, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40)) 
graph save checke1.gph, replace

regress percep_opp i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(edu=(8 12 13.5 14 17 18))
marginsplot, yline(0) graphregion(color(white)) title ("Perception of ethnic inequality of opportunity", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram edu, percent yscale(r(01.2) axis(1)) ylabel("", axis(2)) ylabel(0(0.2)1.2) ymtick(0(.2)1.2) xtitle(" ") xlabel(8(2)18, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40)) 
graph save checke2.gph, replace

regress belief_succ i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(edu=(8 12 13.5 14 17 18))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that people make their own success", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram edu, percent yscale(r(-.6(.2).6) axis(1)) ylabel("", axis(2)) ylabel(-.6(.2).6) ymtick(-.6(.2).6) xtitle(" ") xlabel(8(2)18, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40)) 
graph save checke3.gph, replace

regress belief_work i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(edu=(8 12 13.5 14 17 18))
marginsplot, yline(0) graphregion(color(white)) title ("Belief that minorities work less hard", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram edu, percent yscale(r(-.6(.2).6) axis(1)) ylabel("", axis(2)) ylabel(-.6(.2).6) ymtick(-.6(.2).6) xtitle(" ") xlabel(8(2)18, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40)) 
graph save checke4.gph, replace

regress affirmative i.treatment##c.everyday i.treatment##c.antiimmigrant i.treatment##c.edu i.treatment##migrationbackground 
margins, dydx(treatment) at(edu=(8 12 13.5 14 17 18))
marginsplot, yline(0) graphregion(color(white)) title ("Support for affirmative action", size(med)) recast(line) recastci(rarea) plot1opt(lwidth(vthick)) ci1opt(fcolor(none) lcolor(black) lpattern(dash)) ytitle(" ") legend(off) addplot(histogram edu, percent yscale(r(-.6(.2).6) axis(1)) ylabel("", axis(2)) ylabel(-.6(.2).6) ymtick(-.6(.2).6) xtitle(" ") xlabel(8(2)18, labsize(small)) yaxis(2) ytitle(" ", axis(2)) ysc(axis(2) alt) fcolor(gs14%40) lcolor(gs14%40)) 
graph save checke5.gph, replace

** Fig 7: Visualization of the moderated treatment effect by level of education 
graph combine checke1.gph checke2.gph checke3.gph checke4.gph checke5.gph, graphregion(color(white)) b1title("Level of education (in years)", size(small)) l1title("Marginal effect of treatment on linear prediction", size(small)) holes(3)
graph save checkecombined.pgh, replace
graph export checkecombined.png, replace
