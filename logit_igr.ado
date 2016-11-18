*! version 1.0 - 20160719

capture program drop logit_igr
program define logit_igr
	version 7
	args todo eta mu return
	
	if `todo' == -1 { /* Title */
		global SGLM_lt "Logit IGR"
		global SGLM_lf "logit(1-exp(-u/$SGLM_p))"
		confirm numeric variable $SGLM_p
		exit
	}	
	if `todo' == 0 { /* eta = g(mu) */
		gen double `eta' = logit(1-exp(-`mu'/$SGLM_p))
		exit
	}
	if `todo' == 1 { /* mu = g^-1(eta) */
		gen double `mu' = -$SGLM_p*log((exp(`eta')+1)^(-1))
		exit
	}
	if `todo' == 2 { /* (d mu)/(d eta) */
		gen double `return' = $SGLM_p*exp(`eta')*(exp(`eta')+1)^(-1)
		exit
	}
	if `todo' == 3 { /* (d^2 mu)/(d eta^2) */
		gen double `return' = $SGLM_p*exp(`eta')*(exp(`eta')+1)^(-2)
		exit
	}
	noi di as err "Unknown call to glm link function"
	exit 198	
end
