from __future__ import unicode_literals#, print_function
from urllib import quote
from lxml import etree
from lxml.html.diff import serialize_html_fragment
import json


ID, TYPE, VALUE = '@id', '@type', '@value'
ctx = {
    "@vocab": "http://id.kb.se/vocab/",
    "id": "http://id.kb.se/",
    "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
}

def ead2jsonld(source):
    ead = etree.parse(source).getroot().xpath('/html/body/ead')[0]

    quoted = {}

    # TODO: pick out record details
    #header = ead.find('eadheader')

    desc = ead.find('archdesc')
    item = convert_desc(quoted, desc, base='/archive/')

    item['subject'] = [to_entity(quoted, term_el)
            for term_el in desc.xpath('controlaccess/*')]

    for ent_el in desc.xpath('acqinfo//*[self::persname|self::corpname]'):
        role = ent_el.attrib['role']
        item.setdefault(role, []).append(to_entity(quoted, ent_el))

    itemid = item[ID]
    recid = itemid + '/data'
    record = {ID: recid, 'mainEntity': {ID: itemid}}

    return {"@context": ctx, "@graph": [record, item] + quoted.values()}

def convert_desc(quoted, desc, descid=None, depth=0, base='archive/unit/'):
    did = desc.find('did')
    desctype = desc.attrib.get('type', "").title() + desc.attrib['level'].title()
    unitid = did.findtext('unitid').strip() or None
    descid = descid or (base + unitid.replace(' ', '')) if unitid else None
    item = {
        ID: descid,
        TYPE:desctype,
        'title': did.findtext('unittitle') or None,
        'date': did.findtext('unitdate') or None,
        'extent': did.findtext('physdesc/extent') or None,
        'identifier': unitid,
        'language': [{ID: 'id:language/%s' % lang.attrib['langcode']}
                     for lang in did.findall('langmaterial/language')],
        'qualifiedAttribution': [
            {'agent': to_entity(quoted, el), 'roleName': el.attrib.get('label')}
            for el in did.findall('origination')
        ],
        'heldBy': to_entity(quoted, did.find('repository')),
        'accessRights': to_html(desc.find('accessrestrict')),
        'isPrimaryTopicOf': [
            {
                TYPE: {
                    'bioghist': 'Biography',
                    'custodhist': 'CustodialHistory',
                    'scopecontent': 'ContentsSummary'
                }[el.tag],
                'articleBody': to_html(el)
            } for el in desc.xpath('bioghist | custodhist | scopecontent')
        ],
        'hasPart': [
            convert_desc(quoted, component, None, depth + 1) for component in desc.findall(
                    "c{:#02}".format(depth + 1) if depth else 'dsc/c01')
        ],
        'note': to_html(desc.find('note')),
    }
    for dao_el in did.findall('daogrp'):
        loc_el = dao_el.find('daoloc')
        comment = dao_el.findtext('daodesc/p')
        assert loc_el.attrib['linktype'] == 'locator'
        role = loc_el.attrib['role']
        link = loc_el.attrib['href'].replace(' ', '')
        item.setdefault(role, []).append({ID: link, 'comment': comment})
    return item

def to_entity(quoted, el):
    if el is None:
        return None

    entitytype = (
            'OrganizationTerm' if len(el.xpath('self::corpname|corpname')) else
            'PersonTerm' if len(el.xpath('self::persname|persname')) else
            'FamilyTerm' if len(el.xpath('self::famname|famname')) else
            'TopicalTerm' if len(el.xpath('self::subject')) else
            'GeographicalTerm' if len(el.xpath('self::geogname')) else
            'GenreFormTerm' if len(el.xpath('self::genreform')) else
            'OccupationTerm' if len(el.xpath('self::occupation')) else
            None)
    values = [child.text.strip() for child in el if child.text]

    if values:
        label = None
        p = 'q'
    else:
        label = el.text.strip()
        values = [label]
        p = 'prefLabel'

    v = "+".join(quote(v.encode('utf-8')) for v in sorted(values))
    entityid = "id:some?{}={}".format(p, v)
    if entitytype:
        entityid += '&type=' + entitytype

    entity = {ID: entityid, TYPE: entitytype or 'Thing'}
    if label:
        entity[p] = label

    quoted[entityid] = entity

    return {ID: entityid}

def to_html(el):
    if el is None:
        return None
    v = serialize_html_fragment(el, skip_outer=True)
    return {VALUE: v, TYPE: 'rdf:HTML'}


if __name__ == '__main__':
    import sys
    fpath = sys.argv[1]
    data = ead2jsonld(fpath)
    print(json.dumps(data).encode('utf-8'))
