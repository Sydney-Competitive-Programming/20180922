using Base.Iterators

add_digit(n, add_orig = false) = begin
    ndigit = maximum(ndigits, n)
    res = vec([a + b for (a,b) in product((1:9) .* 10^(ndigit+1) .+ (1:9), n*10)])
    if add_orig
        res = vcat(n,res)
    end
    res
end

ndigit_palindromes(ndigit) = begin
    if ndigit == 1
        return([0:9...])
    elseif ndigit == 2
        return( [1:9...] .* 10 .+ [1:9...])
    else
        starting = [0:9...]
        digit_so_far = 2
        if iseven(ndigit)
            starting = [0,ndigit_palindromes(2)...]
            digit_so_far = 3
        end

        loopto = div(ndigit-1,2)
        for i in 1:loopto
            starting = add_digit(starting, true)
        end
        return(starting)
    end
end

gen(nm) = begin
    res = ndigit_palindromes(1)
    for j in 2:nm
        res = vcat(res, ndigit_palindromes(j)) |> unique
    end
    res
end

res = sort(gen(7), rev = true)
lim  = Int64(1e7)

# found stores the integers backwardds
ok(lim, res) = begin
    found = Array{Bool,1}(lim)
    found .= false
    tot = Int128(0)

    cap = lim

    for r in res[1:end-1]
        #sprintln(r)
        a = res[res .<= (cap - r)]
        res1 = vec([r + b + c for (b,  c) in product(a,a)])
        res1 = res1[res1 .<= cap]

        for rr in res1
            if !found[rr]
                tot = tot + r
                found[rr] = true
            end
        end

        cap  = findfirst(found) - 1
        #println(tot)
    end

    tot
end

@time hehe = ok(lim, res)
@time hehe = ok(lim, res)

using BenchmarkTools
@benchmark ok(lim, res)
