## Instantaneous geometric rates via Generalized Linear Models
#### Version 1.0 (2016-12-07)

The instantaneous geometric rate represents the instantaneous probability of an event of interest per unit of time. We propose to model the effect of covariates on the instantaneous geometric rate with two models: the proportional instantaneous geometric rate and the proportional instantaneous geometric odds model. These models can be fit within the Generalized Linear Model framework by using two nonstandard link functions, which we implement in the user-defined link programs `log_igr` and `logit_igr`. 

---

### Quick description of the files contained in this repository:

**Stata files**:
* `log_igr.ado`: Log-IGR link program for GLM
* `logit_igr.ado`: Logit-IGR link program for GLM
* `example_stata.do`: Worked-out example in Stata (survival in metastatic renal carcinoma)

To install these Stata programs directly from GitHub, type

	net describe igr_glm, from("https://raw.githubusercontent.com/anddis/igr_glm/master/")

from within a web-aware Stata and follow the instructions.

**R files**:
* `log_igr.R`: Log-IGR link function for GLM
* `logit_igr.R`: Logit-IGR link function for GLM
* `example_R.R`: Worked-out example in R (survival in metastatic renal carcinoma)

### Authors

Andrea Discacciati and Matteo Bottai (Karolinska Institutet, Stockholm, Sweden)

### References

Discacciati A, Bottai M. _Instantaneous geometric rates via generalized linear models_. Stata J. 2017;17(2):358-371.

See also: http://www.imm.ki.se/biostatistics/gr/index.htm
