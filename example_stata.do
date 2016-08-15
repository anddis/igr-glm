** Instantaneous geometric rates via Generalized Linear Models
** Andrea Discacciati, Matteo Bottai

* Code to reproduce examples in the manuscript

// chunk 1
use http://www.imm.ki.se/biostatistics/data/kidney, clear
stset survtime, failure(cens) id(pid) scale(365.24)
stsplit click, every(`=1/52')
generate risktime = _t - _t0
rcsgen _t, df(3) if2(_d == 1) gen(_rcs) 
//

// chunk 2
glm _d i.trt c._rcs?, family(poisson) link(log_igr risktime) vce(robust) nolog search
//

// chunk 3
predict log_igr, xb
generate igr = exp(log_igr)

tw (line igr _t if trt == 0, sort lw(medthick) lp(l) lc(black)) ///
 (line igr _t if trt == 1, sort lw(medthick) lp(_) lc(black)), ///
 yscale(log) graphr(color(white) lw(thick) lc(white)) bgcolor(white) ///
 ytitle("Instantaneous geometric rate (per year)") ///
 ylabel(0.25(0.1)0.75, format(%3.2f) angle(horiz)) ///
 xtitle("Years from randomization") xlabel(0/6) xmtick(0(.5)6) ///
 legend(order(1 "MPA" 2 "IFN") cols(1) position(1) ring(0)) name(f1, replace)
drop log_igr igr
//

// chunk 4
glm _d i.trt##c._rcs?, family(poisson) link(log_igr risktime) vce(robust) nolog search
predict log_igr, xb
generate igr = exp(log_igr)
predictnl log_igrr = _b[1.trt] + _b[1.trt#c._rcs1]*_rcs1 + _b[1.trt#c._rcs2]*_rcs2 + ///
 _b[1.trt#c._rcs3]*_rcs3
generate igrr = exp(log_igrr)

tw (line igr _t if trt == 0, sort lw(medthick) lp(l) lc(black) yaxis(1)) ///
	(line igr _t if trt == 1, sort lw(medthick) lp(_) lc(black) yaxis(1)) ///
	(line igrr _t, sort lw(medthick) lp(-) lc(black) yaxis(2)), ///
	yscale(axis(1) r(0.10 .75)  log)  ///
	yscale(axis(2) r(0.65 2.5)  log) ///
	ylabel(0.25 0.35 0.45 0.55 0.65 0.75, format(%3.2f) angle(horiz) axis(1) grid) ///
	ylabel(0.70 0.84 1, format(%3.2f) angle(horiz) axis(2) grid) ///
	yline(0.84, axis(2) lc(gs9))  graphr(color(white) lw(thick) lc(white)) bgcolor(white) ///
	legend(order(1 "MPA" 2 "IFN") cols(1) position(1) ring(0))  ///
	ytitle("                                  Instantaneous" ///
	"                           	geometric rate (per year)", axis(1)) ///
	ytitle("Instantaneous  	            		 			        " ///
	"geometric rate ratio  		       		                            ", axis(2)) ///
	xtitle("Years from randomization") xlabel(0/6) xmtick(0(.5)6) ///
	xsize(7) ysize(4) name(f2, replace)
//

// chunk 5
testparm 1.trt#c._rcs?
//

// chunk 6
glm _d i.trt##c.wcc _rcs?, family(poisson) link(logit_igr risktime) vce(robust) nolog
//

// chunk 7
predictnl log_igor = _b[1.trt] + _b[1.trt#c.wcc]*wcc, se(log_igor_se)
generate igor = exp(log_igor)
generate igor_lo = exp(log_igor - 1.96*log_igor_se)
generate igor_hi = exp(log_igor + 1.96*log_igor_se)

tw (line igor igor_lo igor_hi wcc if inrange(wcc, 0, 20), sort lw(medthick medthick medthick) ///
 lp(l _ _) lc(black black black) yaxis(1)), ///
 yscale(log) graphr(color(white) lw(thick) lc(white)) bgcolor(white) ///
 ytitle("Instantaneous geometric odds ratio") ///
 ylabel(.25 .5 1 2 4 8 16 , format(%3.2f) angle(horiz)) ///
 xtitle("White cell count (x 10{superscript:9} l{superscript:-1})") xlabel(5(5)20) ///
 legend(off) name(f3, replace)
// 
