# Integration with LIBRIS

## Analysis

To get a statistical summary of element usage and frequency from a collection
of EAD files, run:

    $ python count_ead_freq.py EAD_FOLDER

## Conversion to RDF

The script `convert_ead.py` creates JSON-LD from EAD input.

Usage example:

    $ pip install lxml rdflib rdflib-jsonld

    $ python convert_ead.py EAD_FILE > result.jsonld

    $ rdfpipe -ijson-ld:base=http://libris.kb.se/ result.jsonld

