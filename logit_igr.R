logit_igr<- function(tij) {
    logit <- function(x) {
        log(x/(1-x))
    }
    linkfun <- function(mu) {
        logit(1-exp(-mu/tij))
    }
    linkinv <- function(eta) {
        -tij*log((exp(eta)+1)^(-1))
    }
    mu.eta <- function(eta) {
        tij*exp(eta)*(exp(eta)+1)^(-1)
    }
    valideta <- function(eta) {
        TRUE
    }
    link <- "logit(1-exp(-mu/t_ij))"
    structure(list(linkfun = linkfun, linkinv = linkinv, mu.eta = mu.eta,
                   valideta = valideta, name = link), class = "link-glm")
}