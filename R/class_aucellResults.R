#' @title Wrapper to the matrix that stores the AUC or the cell rankings.
#' @aliases getAUC getRanking show
#' @description
#' This class extends SummarizedExperiment to contain the AUC matrix and cell
#' rankings (as 'assays').
#'
#' The results are stored in the assays slot, but they can be accessed through
#' the regular methods (i.e. nrow, rownames... )
#'
#' Types:
#'
#'  - "AUC": The assays contains the AUC for the gene-sets (or region-sets)
#'  & cells.
#'
#'  - "ranking": The assays contains the gene rankings for each cell.
#'
#' @param object Results from \code{AUCell_buildRanking}
#' or \code{AUCell_calcAUC}.
#' @return
#' \itemize{
#' \item show: Prints a summary of the object
#' \item getAUC: Returns the matrix containing the AUC
#' \item getRanking: Returns the matrix containing the rankings
#' }
#' @method show aucellResults
#' @method getAUC aucellResults
#' @method getRanking aucellResults
#' @example inst/examples/example_aucellResults_class.R
#' @rawNamespace import(data.table, except = shift)
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#' @importMethodsFrom SummarizedExperiment assay assays assayNames
#' @importFrom utils head
#' @rdname aucellResults-class
#' @export aucellResults
aucellResults <- setClass("aucellResults",
         contains="SummarizedExperiment",
         representation=representation(
           nGenesDetected = "numeric"
         )
)
#' @importFrom R.utils capitalize
#' @rdname aucellResults-class
#' @aliases show,aucellResults-method
setMethod("show",
  signature="aucellResults",
  definition = function(object) {
    message <- paste(R.utils::capitalize(assayNames(object)), " for ",
           nrow(object)," ", names(dimnames(assay(object)))[1],
           " (rows) and ",
           ncol(object)," ", names(dimnames(assay(object)))[2],
           " (columns).\n", sep="")

    if(assayNames(object) == "AUC")
      message <- paste(message,
                       "\nTop-left corner of the AUC matrix:\n", sep="")
    if(assayNames(object) == "ranking")
      message <- paste(message,
                       "\nTop-left corner of the ranking:\n", sep="")

    cat(message)
    show(head(assay(object)[,seq_len(min(5, ncol(object))),drop=FALSE]))

    if(is.numeric(object@nGenesDetected) &&
       (length(object@nGenesDetected)>0)) {
      cat("\nQuantiles for the number of genes detected by cell:\n")
      show(object@nGenesDetected)
    }
  }
)
##### Access the matrix:
#' @name getAUC
#' @rdname aucellResults-class
# Export generic, for RcisTarget
#' @export getAUC 
setGeneric(name="getAUC",
           def=function(object) standardGeneric("getAUC"))

#' @rdname aucellResults-class
#' @aliases getAUC,aucellResults-method
#' @exportMethod getAUC
setMethod("getAUC",
          signature="aucellResults",
          definition = function(object) {
            if("AUC" %in% assayNames(object)) {
              SummarizedExperiment::assays(object)[["AUC"]]
            }else{
              stop("This object does not contain an AUC matrix.")
            }
          }
)

##### Access the rankings:
# setGeneric
# @method test data.frame
#' @name getRanking
#' @rdname aucellResults-class
# Export generic, for RcisTarget
#' @export getRanking 
setGeneric(name="getRanking",
           def=function(object) standardGeneric("getRanking"))

#' @rdname aucellResults-class
#' @aliases getRanking,aucellResults-method
#' @exportMethod getRanking
setMethod("getRanking",
          signature="aucellResults",
          definition = function(object) {
            if("ranking" %in% assayNames(object)) {
              SummarizedExperiment::assays(object)[["ranking"]]
            }else{
              stop("This object does not contain a ranking.")
            }
          }
)
