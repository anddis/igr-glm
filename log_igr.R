log_igr <- function(tij) {
    linkfun <- function(mu) {
        log(-exp(-mu/tij)+1)
    }
    linkinv <- function(eta) {
        -tij*log(-exp(eta)+1)
    }
    mu.eta <- function(eta) {
        tij*exp(eta)*(-exp(eta)+1)^(-1)
    }
    valideta <- function(eta) {
        eta < 0
    }
    link <- "log(1-exp(-mu/t_ij))"
    structure(list(linkfun = linkfun, linkinv = linkinv, mu.eta = mu.eta,
                   valideta = valideta, name = link), class = "link-glm")
}