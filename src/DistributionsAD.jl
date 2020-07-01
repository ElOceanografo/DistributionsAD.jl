module DistributionsAD

using PDMats, 
      LinearAlgebra, 
      Distributions, 
      Random, 
      SpecialFunctions,
      StatsFuns,
      Compat,
      Requires,
      ChainRules

using SpecialFunctions: logabsgamma, digamma
using LinearAlgebra: copytri!, AbstractTriangular
using Distributions: AbstractMvLogNormal, 
                     ContinuousMultivariateDistribution
using DiffRules, SpecialFunctions, FillArrays
using Base.Iterators: drop
using ZygoteRules: @adjoint, pullback

import StatsFuns: logsumexp, 
                  binomlogpdf, 
                  nbinomlogpdf, 
                  poislogpdf, 
                  nbetalogpdf
import Distributions: MvNormal, 
                      MvLogNormal, 
                      poissonbinomial_pdf_fft, 
                      logpdf, 
                      quantile, 
                      PoissonBinomial,
                      Binomial,
                      BetaBinomial,
                      Erlang

export TuringScalMvNormal,
       TuringDiagMvNormal,
       TuringDenseMvNormal,
       TuringMvLogNormal,
       TuringPoissonBinomial,
       TuringWishart,
       TuringInverseWishart,
       arraydist,
       filldist

include("common.jl")
include("univariate.jl")
#=
include("multivariate.jl")
include("mvcategorical.jl")
include("matrixvariate.jl")
include("flatten.jl")
include("arraydist.jl")
include("filldist.jl")
=#

include("zygote.jl")

function __init__()
    @require ForwardDiff="f6369f11-7733-5829-9624-2563aa707210" begin
        using .ForwardDiff: @define_binary_dual_op # Needed for `eval`ing diffrules here
        include("forwarddiff.jl")
        include("zygote_forwarddiff.jl")
    end

    @require ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267" begin
        include("reversediff.jl")
    end

    @require Tracker="9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c" begin
        using DiffRules
        using SpecialFunctions
        using LinearAlgebra: AbstractTriangular
        using .Tracker: Tracker, TrackedReal, TrackedVector, TrackedMatrix,
                        TrackedArray, TrackedVecOrMat, track, @grad, data
        include("tracker.jl")
    end
end

end
