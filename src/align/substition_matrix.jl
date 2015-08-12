# gap character: -
immutable GAP; end
typealias Character Union{Char,Nucleotide,AminoAcid}

immutable SubstitutionMatrix{C<:Character,T}
    score::Matrix{T}
end

call{C,T}(::Type{SubstitutionMatrix{C}}, score::Matrix{T}) = SubstitutionMatrix{C,T}(score)

getindex{C}(m::SubstitutionMatrix{C}, x::C, y::C) = m.score[convert(UInt8,x)+1,convert(UInt8,y)+1]

function show{T}(io::IO, sm::SubstitutionMatrix{AminoAcid,T})
    aarange = 0x00:0x14
    println(io, "SubstitutionMatrix{AminoAcid,", T, "}")
    print(io, "  ")
    for j in aarange
        b = convert(AminoAcid, j)
        print(io, "  ", b)
    end
    println()
    for i in aarange
        a = convert(AminoAcid, i)
        print(io, " ", a)
        for j in aarange
            b = convert(AminoAcid, j)
            @printf io "%3d" sm[a,b]
        end
        println(io)
    end
end

function parse_subst_matrix_blast(io::IO)
    matrix = Matrix{Int}(21, 21)
    columns = Dict{Int,AminoAcid}()
    i = 0
    for line in eachline(io)
        line[1] == '#' && continue
        values = split(strip(line), r"\s+")
        if i == 0
            # read columns
            for (j, val) in enumerate(values)
                aa = tryparse(AminoAcid, val)
                if !isnull(aa)
                    columns[j] = get(aa)
                end
            end
        else
            aa = tryparse(AminoAcid, values[1])
            for (j, val) in enumerate(values[2:end])
                if haskey(columns, i) && haskey(columns, j)
                    @assert !isnull(aa) && columns[i] == get(aa)
                    i′ = convert(UInt8, columns[i])
                    j′ = convert(UInt8, columns[j])
                    matrix[i′+1,j′+1] = parse(Int, val)
                end
            end
        end
        i += 1
    end
    return SubstitutionMatrix{AminoAcid}(matrix)
end

for name in [:BLOSUM45, :BLOSUM50, :BLOSUM62, :BLOSUM80, :BLOSUM90, :PAM30, :PAM70, :PAM250]
    @eval const $name = open(parse_subst_matrix_blast, joinpath(dirname(@__FILE__), "matrices", $(string(name))))
end
