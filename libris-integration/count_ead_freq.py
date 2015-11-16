from __future__ import division, unicode_literals, print_function
from collections import OrderedDict
from lxml import etree


class Node(object):
    def __init__(self, name=None, depth=0):
        self.name = name
        self.depth = depth
        self.sources = {}
        self.children = OrderedDict()

    def process(self, elem, source):
        for attr in elem.attrib:
            self.add('@' + attr, source)
        if not list(elem) and elem.text and elem.text.strip():
            self.add('#text', source)
        for child in elem:
            name = child.tag if child.tag != etree.Comment else '#comment'
            node = self.add(name, source)
            node.process(child, source)

    def note_source(self, source):
        self.sources[source] = self.sources.get(source, 0) + 1

    def add(self, name, source):
        node = self.children.setdefault(name, Node(name, self.depth + 1))
        node.note_source(source)
        return node


def visualize(node, indent=2, source_count=0, parent_ratio=None):
    source_count = source_count or len(node.sources)
    ratio = len(node.sources) / source_count
    if node.name:
        note = ""
        if ratio < 1.0 and ratio != parent_ratio:
            note = " # in %.3f%%" % (ratio*100)
        if not node.name.startswith(('@', '#')):
            note += " # occurrences: %s" % sorted(set(node.sources.values()), reverse=True)
        print((' ' * indent) * node.depth + node.name + note)
    for child in node.children.values():
        visualize(child, indent, source_count, ratio)


if __name__ == '__main__':
    import glob, os, sys

    root = sys.argv[1]

    tree = Node()
    for source in glob.glob(os.path.join(root, b'*.ead')):
        try:
            root = etree.parse(source).getroot()
        except etree.XMLSyntaxError:
            print("XML syntax error in:", source, file=sys.stderr)
        else:
            tree.name = root.tag
            tree.note_source(source)
            tree.process(root, source)

    visualize(tree)
