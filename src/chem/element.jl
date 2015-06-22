export Element

bitstype 8 Element

import Base: box, unbox

convert(::Type{Element}, no::Uint8) = box(Element, unbox(Uint8, no))
convert(::Type{Uint8}, elm::Element) = box(Uint8, unbox(Element, elm))

# List of elements (118 elements + 1 invalid element)
const elements = [
    # 1
    :H,  :He, :Li, :Be, :B,  :C,  :N,  :O,  :F,  :Ne,
    :Na, :Mg, :Al, :Si, :P,  :S,  :Cl, :Ar, :K,  :Ca,
    :Sc, :Ti, :V,  :Cr, :Mn, :Fe, :Co, :Ni, :Cu, :Zn,
    :Ga, :Ge, :As, :Se, :Br, :Kr, :Rb, :Sr, :Y,  :Zr,
    :Nb, :Mo, :Tc, :Ru, :Rh, :Pd, :Ag, :Cd, :In, :Sn,
    # 51
    :Sb, :Te, :I,  :Xe, :Cs, :Ba, :La, :Ce, :Pr, :Nd,
    :Pm, :Sm, :Eu, :Gd, :Tb, :Dy, :Ho, :Er, :Tm, :Yb,
    :Lu, :Hf, :Ta, :W,  :Re, :Os, :Ir, :Pt, :Au, :Hg,
    :Tl, :Pb, :Bi, :Po, :At, :Rn, :Fr, :Ra, :Ac, :Th,
    :Pa, :U,  :Np, :Pu, :Am, :Cm, :Bk, :Cf, :Es, :Fm,
    # 101
    :Md, :No, :Lr, :Rf, :Db, :Sg, :Bh, :Hs, :Mt, :Ds,
    :Rg, :Cn, :Uut,:Fl, :Uup,:Lv, :Uus,:Uuo,

    :INVALID,
]

for (n, elm) in enumerate(elements)
    @eval begin
        const $(symbol(string("Elm_", elm))) = convert(Element, uint8($n))
    end
end

const element_number = @compat Dict{ASCIIString,Uint8}([lowercase(string(elm)) => n for (n, elm) in enumerate(elements)])

show(io::IO, elm::Element) = print(io, string(elements[uint8(elm)]))

function parse(::Type{Element}, s::String)
    n = element_number[lowercase(strip(s))]
    return convert(Element, n)
end
