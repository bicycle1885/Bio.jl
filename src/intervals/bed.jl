# WARNING: This file was generated from bed.rl using ragel. Do not edit!
immutable BED <: FileFormat end


	"""Metadata for BED interval records"""
	type BEDMetadata
	used_fields::Int # how many of the first n fields are used
	name::StringField
	score::Int
	thick_first::Int
	thick_last::Int
	item_rgb::RGB{	Float32}
block_count::Int
block_sizes::Vector{Int}
block_firsts::Vector{Int}
end

	function 	BEDMetadata()
	return BEDMetadata(0, StringField(), 0, 0, 0, RGB{Float32}(0.0, 0.0, 0.0),
	0, Int[], Int[])
end

function Base.copy(metadata::BEDMetadata)
	return BEDMetadata(
	metadata.used_fields, copy(metadata.name),
	metadata.score, metadata.thick_first, metadata.thick_last,
	metadata.item_rgb, metadata.block_count,
	metadata.block_sizes[1:metadata.block_count],
	metadata.block_firsts[1:metadata.block_count])
end

function Base.(:(==))(a::BEDMetadata, b::BEDMetadata)
	if a.used_fields != b.used_fields
		return false
	end

	n = a.used_fields
	ans = (n < 1 || a.name == b.name) &&
	(n < 2 || a.score == b.score) &&
	(n < 4 || a.thick_first == b.thick_first) &&
	(n < 5 || a.thick_last == b.thick_last) &&
	(n < 6 || a.item_rgb == b.item_rgb) &&
	(n < 7 || a.block_count == b.block_count)
	if !ans
		return false
	end

	if n >= 8
		for i in 1:a.block_count
		if a.block_sizes[i] != b.block_sizes[i]
			return false
		end
	end
end

if n >= 9
	for i in 1:a.block_count
	if a.block_sizes[i] != b.block_sizes[i]
		return false
	end
end
end

	return true
	end

# TODO
#function show(io::IO, metadata::BEDMetadata)
	#end

"An `Interval` with associated metadata from a BED file"
typealias BEDInterval Interval{BEDMetadata}

function Base.print(out::IO, interval::BEDInterval)
	print(out, interval.seqname, '\t', interval.first - 1, '\t', interval.last)
	write_optional_fields(out, interval)
	println(out)
	end

function write_optional_fields(out::IO, interval::BEDInterval, leadingtab::Bool=true)
	if 	interval.metadata.used_fields >= 1
	if leadingtab
		print(out, '\t')
	end
	print(out, interval.metadata.name)
else return end

if interval.metadata.used_fields >= 2
	print(out, '\t', interval.metadata.score)
else return end

if interval.metadata.used_fields >= 3
	print(out, '\t', interval.strand)
else return end

if interval.metadata.used_fields >= 4
	print(out, '\t', interval.metadata.thick_first - 1)
else return end

if interval.metadata.used_fields >= 5
	print(out, '\t', interval.metadata.thick_last)
else return end

if interval.metadata.used_fields >= 6
	item_rgb = interval.metadata.item_rgb
	print(out, '\t',
	round(Int, 255 * item_rgb.r), ',',
	round(Int, 255 * item_rgb.g), ',',
	round(Int, 255 * item_rgb.b))
else return end

if interval.metadata.used_fields >= 7
	print(out, '\t', interval.metadata.block_count)
else return end

if interval.metadata.used_fields >= 8
	block_sizes = interval.metadata.block_sizes
	if !isempty(block_sizes)
		print(out, '\t', block_sizes[1])
		for i in 2:length(block_sizes)
		print(out, ',', block_sizes[i])
	end
end
else 	return end

if interval.metadata.used_fields >= 9
	block_firsts = interval.metadata.block_firsts
	if !isempty(block_firsts)
		print(out, '\t', block_firsts[1] - 1)
		for i in 2:length(block_firsts)
		print(out, ',', block_firsts[i] - 1)
	end
end
end
	end


const bedparser_start  = 41
const bedparser_first_final  = 41
const bedparser_error  = 0
const bedparser_en_main  = 41
const _bedparser_nfa_targs = Int8[ 0, 0 ,  ]
const _bedparser_nfa_offsets = Int8[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,  ]
const _bedparser_nfa_push_actions = Int8[ 0, 0 ,  ]
const _bedparser_nfa_pop_trans = Int8[ 0, 0 ,  ]
type BEDParser <: AbstractParser
state::Ragel.State

# intermediate values used during parsing
red::Float32
green::Float32
blue::Float32
block_size_idx::Int
block_first_idx::Int

function BEDParser(input::BufferedInputStream)
	return new(Ragel.State(bedparser_start, input), 0, 0, 0, 1, 1)
	end
end

function Intervals.metadatatype(::BEDParser)
return BEDMetadata
end

function Base.eltype(::Type{BEDParser})
return BEDInterval
end

function Base.open(input::BufferedInputStream, ::Type{BED})
return BEDParser(input)
end

function IntervalCollection(interval_stream::BEDParser)
intervals = collect(BEDInterval, interval_stream)
return IntervalCollection{BEDMetadata}(intervals, true)
end

Ragel.@generate_read_fuction("bedparser", BEDParser, BEDInterval,
begin
begin
if ( p == pe  )
@goto _test_eof

end
if ( cs  == 41 )
@goto st_case_41
elseif ( cs  == 0 )
@goto st_case_0
elseif ( cs  == 1 )
@goto st_case_1
elseif ( cs  == 2 )
@goto st_case_2
elseif ( cs  == 3 )
@goto st_case_3
elseif ( cs  == 4 )
@goto st_case_4
elseif ( cs  == 5 )
@goto st_case_5
elseif ( cs  == 6 )
@goto st_case_6
elseif ( cs  == 7 )
@goto st_case_7
elseif ( cs  == 8 )
@goto st_case_8
elseif ( cs  == 9 )
@goto st_case_9
elseif ( cs  == 10 )
@goto st_case_10
elseif ( cs  == 11 )
@goto st_case_11
elseif ( cs  == 12 )
@goto st_case_12
elseif ( cs  == 13 )
@goto st_case_13
elseif ( cs  == 14 )
@goto st_case_14
elseif ( cs  == 15 )
@goto st_case_15
elseif ( cs  == 16 )
@goto st_case_16
elseif ( cs  == 17 )
@goto st_case_17
elseif ( cs  == 18 )
@goto st_case_18
elseif ( cs  == 19 )
@goto st_case_19
elseif ( cs  == 20 )
@goto st_case_20
elseif ( cs  == 21 )
@goto st_case_21
elseif ( cs  == 22 )
@goto st_case_22
elseif ( cs  == 23 )
@goto st_case_23
elseif ( cs  == 24 )
@goto st_case_24
elseif ( cs  == 25 )
@goto st_case_25
elseif ( cs  == 26 )
@goto st_case_26
elseif ( cs  == 27 )
@goto st_case_27
elseif ( cs  == 28 )
@goto st_case_28
elseif ( cs  == 29 )
@goto st_case_29
elseif ( cs  == 30 )
@goto st_case_30
elseif ( cs  == 42 )
@goto st_case_42
elseif ( cs  == 31 )
@goto st_case_31
elseif ( cs  == 32 )
@goto st_case_32
elseif ( cs  == 33 )
@goto st_case_33
elseif ( cs  == 34 )
@goto st_case_34
elseif ( cs  == 35 )
@goto st_case_35
elseif ( cs  == 36 )
@goto st_case_36
elseif ( cs  == 37 )
@goto st_case_37
elseif ( cs  == 38 )
@goto st_case_38
elseif ( cs  == 39 )
@goto st_case_39
elseif ( cs  == 40 )
@goto st_case_40
end
@goto st_out
@label ctr2
begin
input.state.linenum += 1
end
@goto st41
@label st41
p+= 1;
if ( p == pe  )
@goto _test_eof41

end
@label st_case_41
if ( (data[1+(p )]) == 9 )
begin
@goto ctr85

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr2

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st2

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st3

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto ctr86

end
end
if ( 33 <= (data[1+(p )])&& (data[1+(p )])<= 126  )
begin
@goto ctr87

end

end
begin
@goto st0

end
@label st_case_0
@label st0
cs = 0;
@goto _out
@label ctr83
begin
output.metadata.used_fields = 0; Ragel.@copy_from_anchor!(output.seqname)
end
@goto st1
@label ctr85
begin
Ragel.@anchor!
end
begin
output.metadata.used_fields = 0; Ragel.@copy_from_anchor!(output.seqname)
end
@goto st1
@label st1
p+= 1;
if ( p == pe  )
@goto _test_eof1

end
@label st_case_1
if ( (data[1+(p )]) == 10 )
begin
@goto ctr2

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st3

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st2

end
end
if ( (data[1+(p )])> 11  )
begin
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr4

end

end

end

elseif ( (data[1+(p )])>= 9  )
begin
@goto st2

end

end
begin
@goto st0

end
@label st2
p+= 1;
if ( p == pe  )
@goto _test_eof2

end
@label st_case_2
if ( (data[1+(p )]) == 10 )
begin
@goto ctr2

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st3

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st2

end
end
if ( 9 <= (data[1+(p )])&& (data[1+(p )])<= 11  )
begin
@goto st2

end

end
begin
@goto st0

end
@label st3
p+= 1;
if ( p == pe  )
@goto _test_eof3

end
@label st_case_3
if ( (data[1+(p )])== 10  )
begin
@goto ctr2

end

end
begin
@goto st0

end
@label ctr4
begin
Ragel.@anchor!
end
@goto st4
@label st4
p+= 1;
if ( p == pe  )
@goto _test_eof4

end
@label st_case_4
if ( (data[1+(p )])== 9  )
begin
@goto ctr5

end

end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st4

end

end
begin
@goto st0

end
@label ctr5
begin
output.first = 1 + Ragel.@int64_from_anchor!
end
@goto st5
@label st5
p+= 1;
if ( p == pe  )
@goto _test_eof5

end
@label st_case_5
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr7

end

end
begin
@goto st0

end
@label ctr7
begin
Ragel.@anchor!
end
@goto st6
@label st6
p+= 1;
if ( p == pe  )
@goto _test_eof6

end
@label st_case_6
if ( (data[1+(p )]) == 9 )
begin
@goto ctr8

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr9

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr10

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st6

end

end
begin
@goto st0

end
@label ctr8
begin
output.last = Ragel.@int64_from_anchor!
end
@goto st7
@label st7
p+= 1;
if ( p == pe  )
@goto _test_eof7

end
@label st_case_7
if ( (data[1+(p )]) == 9 )
begin
@goto ctr12

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr13

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr14

end
end
if ( 32 <= (data[1+(p )])&& (data[1+(p )])<= 126  )
begin
@goto ctr15

end

end
begin
@goto st0

end
@label ctr12
begin
Ragel.@anchor!
end
begin
Ragel.@copy_from_anchor!(output.metadata.name)
end
begin
output.metadata.used_fields += 1
end
@goto st8
@label ctr79
begin
Ragel.@copy_from_anchor!(output.metadata.name)
end
begin
output.metadata.used_fields += 1
end
@goto st8
@label st8
p+= 1;
if ( p == pe  )
@goto _test_eof8

end
@label st_case_8
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr16

end

end
begin
@goto st0

end
@label ctr16
begin
Ragel.@anchor!
end
@goto st9
@label st9
p+= 1;
if ( p == pe  )
@goto _test_eof9

end
@label st_case_9
if ( (data[1+(p )]) == 9 )
begin
@goto ctr17

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr18

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr19

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st9

end

end
begin
@goto st0

end
@label ctr17
begin
output.metadata.score = Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
@goto st10
@label st10
p+= 1;
if ( p == pe  )
@goto _test_eof10

end
@label st_case_10
if ( (data[1+(p )]) == 43 )
begin
@goto ctr21

end
elseif ( (data[1+(p )]) == 63 )
begin
@goto ctr21

end
end
if ( 45 <= (data[1+(p )])&& (data[1+(p )])<= 46  )
begin
@goto ctr21

end

end
begin
@goto st0

end
@label ctr21
begin
output.strand = convert(Strand, (Ragel.@char))
end
@goto st11
@label st11
p+= 1;
if ( p == pe  )
@goto _test_eof11

end
@label st_case_11
if ( (data[1+(p )]) == 9 )
begin
@goto ctr22

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr23

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr24

end
end
begin
@goto st0

end
@label ctr22
begin
output.metadata.used_fields += 1
end
@goto st12
@label st12
p+= 1;
if ( p == pe  )
@goto _test_eof12

end
@label st_case_12
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr25

end

end
begin
@goto st0

end
@label ctr25
begin
Ragel.@anchor!
end
@goto st13
@label st13
p+= 1;
if ( p == pe  )
@goto _test_eof13

end
@label st_case_13
if ( (data[1+(p )]) == 9 )
begin
@goto ctr26

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr27

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr28

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st13

end

end
begin
@goto st0

end
@label ctr26
begin
output.metadata.thick_first = 1 + Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
@goto st14
@label st14
p+= 1;
if ( p == pe  )
@goto _test_eof14

end
@label st_case_14
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr30

end

end
begin
@goto st0

end
@label ctr30
begin
Ragel.@anchor!
end
@goto st15
@label st15
p+= 1;
if ( p == pe  )
@goto _test_eof15

end
@label st_case_15
if ( (data[1+(p )]) == 9 )
begin
@goto ctr31

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr32

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr33

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st15

end

end
begin
@goto st0

end
@label ctr31
begin
output.metadata.thick_last = Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
@goto st16
@label st16
p+= 1;
if ( p == pe  )
@goto _test_eof16

end
@label st_case_16
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr35

end

end
begin
@goto st0

end
@label ctr35
begin
Ragel.@anchor!
end
@goto st17
@label st17
p+= 1;
if ( p == pe  )
@goto _test_eof17

end
@label st_case_17
if ( (data[1+(p )]) == 9 )
begin
@goto ctr36

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr37

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto ctr38

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr39

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto ctr38

end
elseif ( (data[1+(p )]) == 44 )
begin
@goto ctr40

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st17

end

end
begin
@goto st0

end
@label ctr36
begin
input.red = input.green = input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
begin
output.metadata.item_rgb = RGB{Float32}(input.red, input.green, input.blue)
end
begin
output.metadata.used_fields += 1
end
@goto st18
@label st18
p+= 1;
if ( p == pe  )
@goto _test_eof18

end
@label st_case_18
if ( (data[1+(p )]) == 9 )
begin
@goto st19

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st19

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st19

end
elseif ( (data[1+(p )]) == 44 )
begin
@goto st20

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr44

end

end
begin
@goto st0

end
@label ctr38
begin
input.red = input.green = input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
@goto st19
@label st19
p+= 1;
if ( p == pe  )
@goto _test_eof19

end
@label st_case_19
if ( (data[1+(p )]) == 9 )
begin
@goto st19

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st19

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st19

end
elseif ( (data[1+(p )]) == 44 )
begin
@goto st20

end
end
begin
@goto st0

end
@label ctr40
begin
input.red = input.green = input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
@goto st20
@label st20
p+= 1;
if ( p == pe  )
@goto _test_eof20

end
@label st_case_20
if ( (data[1+(p )]) == 9 )
begin
@goto st20

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st20

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st20

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr45

end

end
begin
@goto st0

end
@label ctr45
begin
Ragel.@anchor!
end
@goto st21
@label st21
p+= 1;
if ( p == pe  )
@goto _test_eof21

end
@label st_case_21
if ( (data[1+(p )]) == 9 )
begin
@goto ctr46

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto ctr46

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto ctr46

end
elseif ( (data[1+(p )]) == 44 )
begin
@goto ctr47

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st21

end

end
begin
@goto st0

end
@label ctr46
begin
input.green = (Ragel.@int64_from_anchor!) / 255.0
end
@goto st22
@label st22
p+= 1;
if ( p == pe  )
@goto _test_eof22

end
@label st_case_22
if ( (data[1+(p )]) == 9 )
begin
@goto st22

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st22

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st22

end
elseif ( (data[1+(p )]) == 44 )
begin
@goto st23

end
end
begin
@goto st0

end
@label ctr47
begin
input.green = (Ragel.@int64_from_anchor!) / 255.0
end
@goto st23
@label st23
p+= 1;
if ( p == pe  )
@goto _test_eof23

end
@label st_case_23
if ( (data[1+(p )]) == 9 )
begin
@goto st23

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st23

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st23

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr51

end

end
begin
@goto st0

end
@label ctr51
begin
Ragel.@anchor!
end
@goto st24
@label st24
p+= 1;
if ( p == pe  )
@goto _test_eof24

end
@label st_case_24
if ( (data[1+(p )]) == 9 )
begin
@goto ctr52

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr53

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr54

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st24

end

end
begin
@goto st0

end
@label ctr52
begin
input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
begin
output.metadata.item_rgb = RGB{Float32}(input.red, input.green, input.blue)
end
begin
output.metadata.used_fields += 1
end
@goto st25
@label st25
p+= 1;
if ( p == pe  )
@goto _test_eof25

end
@label st_case_25
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr44

end

end
begin
@goto st0

end
@label ctr44
begin
Ragel.@anchor!
end
@goto st26
@label st26
p+= 1;
if ( p == pe  )
@goto _test_eof26

end
@label st_case_26
if ( (data[1+(p )]) == 9 )
begin
@goto ctr56

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr57

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr58

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st26

end

end
begin
@goto st0

end
@label ctr56
begin
output.metadata.block_count = Ragel.@int64_from_anchor!

if (output.metadata.block_count > length(output.metadata.block_sizes))
resize!(output.metadata.block_sizes, output.metadata.block_count)
end

if (output.metadata.block_count > length(output.metadata.block_firsts))
resize!(output.metadata.block_firsts, output.metadata.block_count)
end
end
begin
output.metadata.used_fields += 1
end
@goto st27
@label st27
p+= 1;
if ( p == pe  )
@goto _test_eof27

end
@label st_case_27
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr60

end

end
begin
@goto st0

end
@label ctr60
begin
Ragel.@anchor!
end
@goto st28
@label st28
p+= 1;
if ( p == pe  )
@goto _test_eof28

end
@label st_case_28
if ( (data[1+(p )]) == 9 )
begin
@goto ctr61

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr62

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr63

end
elseif ( (data[1+(p )]) == 44 )
begin
@goto ctr64

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st28

end

end
begin
@goto st0

end
@label ctr78
begin
output.metadata.used_fields += 1
end
@goto st29
@label ctr61
begin
if input.block_size_idx > length(output.metadata.block_sizes)
error("More size blocks encountered than BED block count field suggested.")
end
output.metadata.block_sizes[input.block_size_idx] = Ragel.@int64_from_anchor!
input.block_size_idx += 1
end
begin
output.metadata.used_fields += 1
end
@goto st29
@label st29
p+= 1;
if ( p == pe  )
@goto _test_eof29

end
@label st_case_29
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr66

end

end
begin
@goto st0

end
@label ctr66
begin
Ragel.@anchor!
end
@goto st30
@label st30
p+= 1;
if ( p == pe  )
@goto _test_eof30

end
@label st_case_30
if ( (data[1+(p )]) == 10 )
begin
@goto ctr67

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr68

end
elseif ( (data[1+(p )]) == 44 )
begin
@goto ctr69

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto st30

end

end
begin
@goto st0

end
@label ctr72
begin
input.state.linenum += 1
end
@goto st42
@label ctr9
begin
output.last = Ragel.@int64_from_anchor!
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr13
begin
Ragel.@anchor!
end
begin
Ragel.@copy_from_anchor!(output.metadata.name)
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr18
begin
output.metadata.score = Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr23
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr27
begin
output.metadata.thick_first = 1 + Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr32
begin
output.metadata.thick_last = Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr37
begin
input.red = input.green = input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
begin
output.metadata.item_rgb = RGB{Float32}(input.red, input.green, input.blue)
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr53
begin
input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
begin
output.metadata.item_rgb = RGB{Float32}(input.red, input.green, input.blue)
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr57
begin
output.metadata.block_count = Ragel.@int64_from_anchor!

if (output.metadata.block_count > length(output.metadata.block_sizes))
resize!(output.metadata.block_sizes, output.metadata.block_count)
end

if (output.metadata.block_count > length(output.metadata.block_firsts))
resize!(output.metadata.block_firsts, output.metadata.block_count)
end
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr62
begin
if input.block_size_idx > length(output.metadata.block_sizes)
error("More size blocks encountered than BED block count field suggested.")
end
output.metadata.block_sizes[input.block_size_idx] = Ragel.@int64_from_anchor!
input.block_size_idx += 1
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr67
begin
if input.block_first_idx > length(output.metadata.block_firsts)
error("More start blocks encountered than BED block count field suggested.")
end
output.metadata.block_firsts[input.block_first_idx] = 1 + Ragel.@int64_from_anchor!
input.block_first_idx += 1
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label ctr80
begin
Ragel.@copy_from_anchor!(output.metadata.name)
end
begin
output.metadata.used_fields += 1
end
begin
input.state.linenum += 1
end
@goto st42
@label st42
p+= 1;
if ( p == pe  )
@goto _test_eof42

end
@label st_case_42
if ( (data[1+(p )]) == 9 )
begin
@goto ctr88

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr72

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st32

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st33

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto ctr89

end
end
if ( 33 <= (data[1+(p )])&& (data[1+(p )])<= 126  )
begin
@goto ctr90

end

end
begin
@goto st0

end
@label ctr74
begin
output.metadata.used_fields = 0; Ragel.@copy_from_anchor!(output.seqname)
end
@goto st31
@label ctr88
begin
input.block_size_idx = 1
input.block_first_idx = 1
Ragel.@anchor!
Ragel.@yield 31
end
begin
Ragel.@anchor!
end
begin
output.metadata.used_fields = 0; Ragel.@copy_from_anchor!(output.seqname)
end
@goto st31
@label st31
p+= 1;
if ( p == pe  )
@goto _test_eof31

end
@label st_case_31
if ( (data[1+(p )]) == 10 )
begin
@goto ctr72

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st33

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st32

end
end
if ( (data[1+(p )])> 11  )
begin
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr4

end

end

end

elseif ( (data[1+(p )])>= 9  )
begin
@goto st32

end

end
begin
@goto st0

end
@label st32
p+= 1;
if ( p == pe  )
@goto _test_eof32

end
@label st_case_32
if ( (data[1+(p )]) == 10 )
begin
@goto ctr72

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st33

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st32

end
end
if ( 9 <= (data[1+(p )])&& (data[1+(p )])<= 11  )
begin
@goto st32

end

end
begin
@goto st0

end
@label ctr10
begin
output.last = Ragel.@int64_from_anchor!
end
@goto st33
@label ctr14
begin
Ragel.@anchor!
end
begin
Ragel.@copy_from_anchor!(output.metadata.name)
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr19
begin
output.metadata.score = Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr24
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr28
begin
output.metadata.thick_first = 1 + Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr33
begin
output.metadata.thick_last = Ragel.@int64_from_anchor!
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr39
begin
input.red = input.green = input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
begin
output.metadata.item_rgb = RGB{Float32}(input.red, input.green, input.blue)
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr54
begin
input.blue = (Ragel.@int64_from_anchor!) / 255.0
end
begin
output.metadata.item_rgb = RGB{Float32}(input.red, input.green, input.blue)
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr58
begin
output.metadata.block_count = Ragel.@int64_from_anchor!

if (output.metadata.block_count > length(output.metadata.block_sizes))
resize!(output.metadata.block_sizes, output.metadata.block_count)
end

if (output.metadata.block_count > length(output.metadata.block_firsts))
resize!(output.metadata.block_firsts, output.metadata.block_count)
end
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr63
begin
if input.block_size_idx > length(output.metadata.block_sizes)
error("More size blocks encountered than BED block count field suggested.")
end
output.metadata.block_sizes[input.block_size_idx] = Ragel.@int64_from_anchor!
input.block_size_idx += 1
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr68
begin
if input.block_first_idx > length(output.metadata.block_firsts)
error("More start blocks encountered than BED block count field suggested.")
end
output.metadata.block_firsts[input.block_first_idx] = 1 + Ragel.@int64_from_anchor!
input.block_first_idx += 1
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label ctr81
begin
Ragel.@copy_from_anchor!(output.metadata.name)
end
begin
output.metadata.used_fields += 1
end
@goto st33
@label st33
p+= 1;
if ( p == pe  )
@goto _test_eof33

end
@label st_case_33
if ( (data[1+(p )])== 10  )
begin
@goto ctr72

end

end
begin
@goto st0

end
@label ctr89
begin
input.block_size_idx = 1
input.block_first_idx = 1
Ragel.@anchor!
Ragel.@yield 34
end
begin
Ragel.@anchor!
end
@goto st34
@label st34
p+= 1;
if ( p == pe  )
@goto _test_eof34

end
@label st_case_34
if ( (data[1+(p )]) == 9 )
begin
@goto ctr74

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr72

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st32

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st33

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st34

end
end
if ( 33 <= (data[1+(p )])&& (data[1+(p )])<= 126  )
begin
@goto st35

end

end
begin
@goto st0

end
@label ctr87
begin
Ragel.@anchor!
end
@goto st35
@label ctr90
begin
input.block_size_idx = 1
input.block_first_idx = 1
Ragel.@anchor!
Ragel.@yield 35
end
begin
Ragel.@anchor!
end
@goto st35
@label st35
p+= 1;
if ( p == pe  )
@goto _test_eof35

end
@label st_case_35
if ( (data[1+(p )])== 9  )
begin
@goto ctr77

end

end
if ( 32 <= (data[1+(p )])&& (data[1+(p )])<= 126  )
begin
@goto st35

end

end
begin
@goto st0

end
@label ctr77
begin
output.metadata.used_fields = 0; Ragel.@copy_from_anchor!(output.seqname)
end
@goto st36
@label st36
p+= 1;
if ( p == pe  )
@goto _test_eof36

end
@label st_case_36
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr4

end

end
begin
@goto st0

end
@label ctr69
begin
if input.block_first_idx > length(output.metadata.block_firsts)
error("More start blocks encountered than BED block count field suggested.")
end
output.metadata.block_firsts[input.block_first_idx] = 1 + Ragel.@int64_from_anchor!
input.block_first_idx += 1
end
@goto st37
@label st37
p+= 1;
if ( p == pe  )
@goto _test_eof37

end
@label st_case_37
if ( (data[1+(p )]) == 10 )
begin
@goto ctr23

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr24

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr66

end

end
begin
@goto st0

end
@label ctr64
begin
if input.block_size_idx > length(output.metadata.block_sizes)
error("More size blocks encountered than BED block count field suggested.")
end
output.metadata.block_sizes[input.block_size_idx] = Ragel.@int64_from_anchor!
input.block_size_idx += 1
end
@goto st38
@label st38
p+= 1;
if ( p == pe  )
@goto _test_eof38

end
@label st_case_38
if ( (data[1+(p )]) == 9 )
begin
@goto ctr78

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr23

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr24

end
end
if ( 48 <= (data[1+(p )])&& (data[1+(p )])<= 57  )
begin
@goto ctr60

end

end
begin
@goto st0

end
@label ctr15
begin
Ragel.@anchor!
end
@goto st39
@label st39
p+= 1;
if ( p == pe  )
@goto _test_eof39

end
@label st_case_39
if ( (data[1+(p )]) == 9 )
begin
@goto ctr79

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr80

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto ctr81

end
end
if ( 32 <= (data[1+(p )])&& (data[1+(p )])<= 126  )
begin
@goto st39

end

end
begin
@goto st0

end
@label ctr86
begin
Ragel.@anchor!
end
@goto st40
@label st40
p+= 1;
if ( p == pe  )
@goto _test_eof40

end
@label st_case_40
if ( (data[1+(p )]) == 9 )
begin
@goto ctr83

end
elseif ( (data[1+(p )]) == 10 )
begin
@goto ctr2

end
elseif ( (data[1+(p )]) == 11 )
begin
@goto st2

end
elseif ( (data[1+(p )]) == 13 )
begin
@goto st3

end
elseif ( (data[1+(p )]) == 32 )
begin
@goto st40

end
end
if ( 33 <= (data[1+(p )])&& (data[1+(p )])<= 126  )
begin
@goto st35

end

end
begin
@goto st0

end
@label st_out
@label _test_eof41
cs = 41;
@goto _test_eof
@label _test_eof1
cs = 1;
@goto _test_eof
@label _test_eof2
cs = 2;
@goto _test_eof
@label _test_eof3
cs = 3;
@goto _test_eof
@label _test_eof4
cs = 4;
@goto _test_eof
@label _test_eof5
cs = 5;
@goto _test_eof
@label _test_eof6
cs = 6;
@goto _test_eof
@label _test_eof7
cs = 7;
@goto _test_eof
@label _test_eof8
cs = 8;
@goto _test_eof
@label _test_eof9
cs = 9;
@goto _test_eof
@label _test_eof10
cs = 10;
@goto _test_eof
@label _test_eof11
cs = 11;
@goto _test_eof
@label _test_eof12
cs = 12;
@goto _test_eof
@label _test_eof13
cs = 13;
@goto _test_eof
@label _test_eof14
cs = 14;
@goto _test_eof
@label _test_eof15
cs = 15;
@goto _test_eof
@label _test_eof16
cs = 16;
@goto _test_eof
@label _test_eof17
cs = 17;
@goto _test_eof
@label _test_eof18
cs = 18;
@goto _test_eof
@label _test_eof19
cs = 19;
@goto _test_eof
@label _test_eof20
cs = 20;
@goto _test_eof
@label _test_eof21
cs = 21;
@goto _test_eof
@label _test_eof22
cs = 22;
@goto _test_eof
@label _test_eof23
cs = 23;
@goto _test_eof
@label _test_eof24
cs = 24;
@goto _test_eof
@label _test_eof25
cs = 25;
@goto _test_eof
@label _test_eof26
cs = 26;
@goto _test_eof
@label _test_eof27
cs = 27;
@goto _test_eof
@label _test_eof28
cs = 28;
@goto _test_eof
@label _test_eof29
cs = 29;
@goto _test_eof
@label _test_eof30
cs = 30;
@goto _test_eof
@label _test_eof42
cs = 42;
@goto _test_eof
@label _test_eof31
cs = 31;
@goto _test_eof
@label _test_eof32
cs = 32;
@goto _test_eof
@label _test_eof33
cs = 33;
@goto _test_eof
@label _test_eof34
cs = 34;
@goto _test_eof
@label _test_eof35
cs = 35;
@goto _test_eof
@label _test_eof36
cs = 36;
@goto _test_eof
@label _test_eof37
cs = 37;
@goto _test_eof
@label _test_eof38
cs = 38;
@goto _test_eof
@label _test_eof39
cs = 39;
@goto _test_eof
@label _test_eof40
cs = 40;
@goto _test_eof
@label _test_eof
begin

end
if ( p == eof  )
begin
if ( cs  == 42 )
begin
input.block_size_idx = 1
input.block_first_idx = 1
Ragel.@anchor!
Ragel.@yield 0
end

break;
end

end

end
@label _out
begin

end

end
end)
