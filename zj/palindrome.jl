using Base.Iterators

is_palindrome(n) = begin
    dn = digits(n)
    all(dn .== reverse(dn))
end

lim  = Int64(1e6)
res = filter(is_palindrome,lim:-1:0)

using DataFrames
lp = DataFrame(k = 1:1_000_000, largest_palindrome = Array{Int64,1}(lim))

# found stores the integers backwardds
ok(lim, res, lp) = begin
    found = BitArray(lim)
    found .= false
    tot = Int128(0)

    cap = lim
    r = res[1]

    for r in res[1:end-1]
        bs = res[res .<= (cap - r)]
        cs = res[res .<= ceil((cap - r)/2)]

        res1 = vec([r + b + c for (b,  c) in product(bs,cs)])

        res1 = res1[res1 .<= cap]

        for rr in res1
            if !found[rr]
                lp[rr,:largest_palindrome] = r
                tot = tot + r
                found[rr] = true
            end
        end

        for i in lim:-1:1
            if !found[i]
                cap = i
                break
            end
        end
    end

    (tot, found, lp)
end

using BenchmarkTools
@benchmark ok(lim, res)

using CSVFiles
save("zj/integer_largest_palin_pair.csv",lp)
