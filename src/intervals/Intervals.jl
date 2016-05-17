# Bio.Intervals
# =============
#
# Module for genomic intervals.
#
# This file is a part of BioJulia.
# License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md

module Intervals

export
    Strand,
    Interval,
    IntervalCollection,
    IntervalStream,
    STRAND_NA,
    STRAND_POS,
    STRAND_NEG,
    STRAND_BOTH,
    coverage,
    isoverlapping,
    seqname,
    strand,
    BED,
    BEDMetadata,
    BEDInterval,
    BigBed,
    BigWig

import ..Ragel: tryread!
export tryread!

using
    Bio.Ragel,
    Bio.StringFields,
    BufferedStreams,
    IntervalTrees,
    Libz,
    Colors,
    Compat

using Base.Collections:
    heappush!,
    heappop!

using Bio:
    AbstractParser,
    FileFormat

import Iterators

include("strand.jl")
include("interval.jl")
include("stream_buffer.jl")
include("intervalcollection.jl")
include("intervalstream.jl")

# Parsing file types
include("bed.jl")
include("bed-parser.jl")
include("bigbed.jl")

end # module Intervals
