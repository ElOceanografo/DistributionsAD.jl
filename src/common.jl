## Linear Algebra ##

function turing_chol(A::AbstractMatrix, check)
    chol = cholesky(A, check=check)
    (chol.factors, chol.info)
end
function ChainRules.rrule(::typeof(turing_chol), A::AbstractMatrix, check)
    factors, info = turing_chol(A, check)
    function pullback(Ȳ)
        f̄, _ = Ȳ
        ∂X = @thunk(ChainRules.chol_blocked_rev(f̄, factors, 25, true))
        return (ChainRules.NO_FIELDS, ∂X, ChainRules.DoesNotExist)
    end
    (factors,info), pullback
end

function symm_turing_chol(A::AbstractMatrix, check, uplo)
    chol = cholesky(Symmetric(A, uplo), check=check)
    (chol.factors, chol.info)
end
function ChainRules.rrule(::typeof(symm_turing_chol), A::AbstractMatrix, check, uplo)
    factors, info = symm_turing_chol(A, check, uplo)
    function pullback(Ȳ)
        f̄, _ = Ȳ
        ∂X = @thunk(ChainRules.chol_blocked_rev(f̄, factors, 25, true))
        return (ChainRules.NO_FIELDS, ∂X, ChainRules.DoesNotExist)
    end
    return (factors,info), pullback
end

# Tracker's implementation of ldiv isn't good. We'll use Zygote's instead.
zygote_ldiv(A::AbstractMatrix, B::AbstractVecOrMat) = A \ B
